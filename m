Return-Path: <linux-kernel-owner+w=401wt.eu-S1760635AbXE1DMz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760635AbXE1DMz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2007 23:12:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754916AbXE1DMs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 May 2007 23:12:48 -0400
Received: from mail.tmr.com ([64.65.253.246]:48639 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754706AbXE1DMs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2007 23:12:48 -0400
Message-ID: <465A4953.7030708@tmr.com>
Date: Sun, 27 May 2007 23:15:31 -0400
From: Bill Davidsen <davidsen@tmr.com>
Organization: TMR Associates Inc, Schenectady NY
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: Linux Kernel M/L <linux-kernel@vger.kernel.org>
Subject: Re: [2.6.21.1] resume doesn't run suspended kernel?
References: <4658B7DD.3060309@tmr.com> <20070527211434.GG3989@ucw.cz>
In-Reply-To: <20070527211434.GG3989@ucw.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:
> On Sat 2007-05-26 18:42:37, Bill Davidsen wrote:
>   
>> I was testing susp2disk in 2.6.21.1 under FC6, to 
>> support reliable computing environment (RCE) needs. The 
>> idea is that if power fails, after some short time on 
>> UPS the system does susp2disk with a time set, and boots 
>> back every so often to see if power is stable.
>>
>> No, I don't want susp2mem until I debug it, console come 
>> up in useless mode, console as kalidescope is not what I 
>> need.
>>
>> Anyway, I pulled the plug on the UPS, and the system 
>> shut down. But when it powered up, it booted the default 
>> kernel rather than the test kernel, decided that it 
>> couldn't resume, and then did a cold boot.
>>
>> I can bypass this by making the debug kernel the 
>> default, but WHY? 
>>     
>
> HELL YES :-). We do not save kernel code into image.
>
>   
That's clear, I'll have to use xen or kvm or similar which restores the 
system as suspended. Thanks for the clarification of the limitations.

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979

