Return-Path: <linux-kernel-owner+w=401wt.eu-S1752573AbXBDVme@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752573AbXBDVme (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Feb 2007 16:42:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752571AbXBDVme
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Feb 2007 16:42:34 -0500
Received: from mail.tmr.com ([64.65.253.246]:33722 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752574AbXBDVmd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Feb 2007 16:42:33 -0500
Message-ID: <45C65353.5000602@tmr.com>
Date: Sun, 04 Feb 2007 16:42:43 -0500
From: Bill Davidsen <davidsen@tmr.com>
Organization: TMR Associates Inc, Schenectady NY
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
To: Jakub Jelinek <jakub@redhat.com>
CC: Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: [ANN] Userspace M-on-N threading model implementation. Alpha
 release.
References: <66910A579C9312469A7DF9ADB54A8B7D5C2B90@exchange.ZeugmaSystems.local> <45C362D2.2040407@tmr.com> <1170516376.3073.1015.camel@laptopd505.fenrus.org> <45C63E30.4010106@tmr.com> <20070204202053.GC20307@devserv.devel.redhat.com>
In-Reply-To: <20070204202053.GC20307@devserv.devel.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jakub Jelinek wrote:
> On Sun, Feb 04, 2007 at 03:12:32PM -0500, Bill Davidsen wrote:
>   
>> Arjan van de Ven wrote:
>>     
>>>> Because user threading can avoid context switches, there will always be 
>>>> cases where it will outperform o/s threads for hardware reasons.
>>>>         
>>> actually.. switching from one "real" thread to another in Linux is not
>>> an actual context switch in the hardware sense... at least this part of
>>> your argument seems to be incorrect ;)
>>>
>>>       
>> How does that work? Switching between kernel threads requires going into 
>> the kernel, user level thread switches are all done in user mode.
>>
>> Do you have some way to change o/s threads w/o going into the kernel?
>>     
>
> But going into kernel is not very expensive on Linux.
>
> On the other side, the overhead you need to add for every single syscall
> that might block for the M:N threads and the associated complications
> which make it far harder to conform to POSIX IMHO far outweight the costs
> of going into the kernel for a context switch.

That really wasn't my question, Arjan said that switching real threads 
wasn't a context switch in the hardware sense, and I was asking if I 
missed something. It may be cheap, but it would seem to be a context 
switch none-the-less.

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979

