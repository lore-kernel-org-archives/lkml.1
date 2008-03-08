Return-Path: <linux-kernel-owner+w=401wt.eu-S1754725AbYCHRCu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754725AbYCHRCu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Mar 2008 12:02:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752556AbYCHRCl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Mar 2008 12:02:41 -0500
Received: from mail.tmr.com ([64.65.253.246]:32875 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752248AbYCHRCk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Mar 2008 12:02:40 -0500
Message-ID: <47D2C7D7.2080301@tmr.com>
Date: Sat, 08 Mar 2008 12:07:35 -0500
From: Bill Davidsen <davidsen@tmr.com>
Organization: TMR Associates Inc, Schenectady NY
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Justin Banks <justinb@bakbone.com>,
       "Miller, Mike (OS Dev)" <Mike.Miller@hp.com>,
       linux-kernel@vger.kernel.org
Subject: Re: FW: Linux question
References: <DEE40752C8AF224BB890E455C7B8E0FE042B84B112@G6W0268.americas.hpqcorp.net>	<20080306203841.GA4282@bleen.domain.actdsltmp>	<47D18CE1.7050206@tmr.com> <874pbifit7.fsf@basil.nowhere.org>
In-Reply-To: <874pbifit7.fsf@basil.nowhere.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> Bill Davidsen <davidsen@tmr.com> writes:
>
>   
>> Here's an interesting question, why isn't there an "online" file for
>> each CPU?
>>     
>
> There are still some problems with off lining CPU #0 on x86 at least,
> that is why it is not allowed. iirc they weren't very difficult so it
> would be probably fixable with some effort.
>   

If that's the case I would think that making it read-only would be a 
better solution, since I found this while creating a little tool to scan 
and see what's online and what's not. Obviously there can be exception 
cases for CPU0 and x86, but I would think that having the CPU0 for x86 
be read-only would be a quirk, and handled in the kernel.

-- 
Bill Davidsen <davidsen@tmr.com>
  "Woe unto the statesman who makes war without a reason that will still
  be valid when the war is over..." Otto von Bismark 


