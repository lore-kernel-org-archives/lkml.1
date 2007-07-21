Return-Path: <linux-kernel-owner+w=401wt.eu-S936610AbXGUNzK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936610AbXGUNzK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2007 09:55:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763567AbXGUNy6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jul 2007 09:54:58 -0400
Received: from mail.tmr.com ([64.65.253.246]:44779 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757619AbXGUNy6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2007 09:54:58 -0400
Message-ID: <46A2101D.5020400@tmr.com>
Date: Sat, 21 Jul 2007 09:54:37 -0400
From: Bill Davidsen <davidsen@tmr.com>
Organization: TMR Associates Inc, Schenectady NY
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
To: Ken Moffat <zarniwhoop@ntlworld.com>
CC: Randy Dunlap <randy.dunlap@oracle.com>,
       Linux Kernel M/L <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] what should 'uptime' be on suspend?
References: <46A0210E.6010207@tmr.com> <20070720171729.GA19935@deepthought> <20070720104215.476f4cc1.randy.dunlap@oracle.com> <20070720175730.GB21550@deepthought>
In-Reply-To: <20070720175730.GB21550@deepthought>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ken Moffat wrote:
> On Fri, Jul 20, 2007 at 10:42:15AM -0700, Randy Dunlap wrote:
>   
>> man uptime:
>> 	uptime - tell how long the system has been running
>>
>> I claim that the system is not running when it is suspended,
>> so the suspension time should not be included in uptime.
>>
>>     
>  So, maybe I shouldn't have put corrected in inverted commas,
> because this was a real correction and my previous usage was an
> unintended side-effect of an error.
>
>  Anyway, the current behaviour is known and I guess any attempt to
> change it (e.g. to what Bill was expecting) won't be well received.
>   

So is setting it to a random number considered correct behavior? Any of 
the first three values I mentioned would make sense, but the value I see 
is neither time since resume, time since power-on to do the resume, or 
any of the logical uptime values. That was the whole point of the 
original post, the uptime reported makes no sense at all.

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979

