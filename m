Return-Path: <linux-kernel-owner+w=401wt.eu-S1751855AbXBAPwx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751855AbXBAPwx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 10:52:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751830AbXBAPwx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 10:52:53 -0500
Received: from gateway-1237.mvista.com ([63.81.120.155]:54607 "EHLO
	imap.sh.mvista.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751839AbXBAPww (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 10:52:52 -0500
Message-ID: <45C20CC6.2070201@ru.mvista.com>
Date: Thu, 01 Feb 2007 18:52:38 +0300
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: v2.6.19-rt6, yum/rpm
References: <20061205171114.GA25926@elte.hu> <4582CAD6.9040404@ru.mvista.com> <20061215161952.GA29191@elte.hu>
In-Reply-To: <20061215161952.GA29191@elte.hu>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Ingo Molnar wrote:

>>>as usual, bugreports, fixes and suggestions are welcome,

>>   Be aware that even with the newest -rt patch, the PowerPC TOD 
>>vsyscalls are still broken, i.e. glibc may return imprecise/incorrect 
>>results for the related calls -- despite arch/powerpc/kernel/time.c 
>>has been at last fixed to at least compile, the PowerPC clocksource 
>>patch removed the important part of TOD vsyscall support, and this 
>>hasn't been dealt with.  I've sent to Thomas Gleixner a patch removing 
>>the affected vsyscalls altogether for the time being in the early 
>>November (unfortunately, I came to know of the breakage too late, and 
>>hadn't time to deal with it propery due to othr woes), however, I'm 
>>not seeing any of my patches (I've also done PowerPC clockevents 
>>support) merged to -rt (or otherwise published). Most of the patches 
>>can be found in the linuxppc-dev list archives, for the interested...

> could you resend them to me please?

    Seeing that GENERIC_TIME has been thrown out from the -rt patch, it makes 
no sense now (even if I had time -- I also decided to leave this to Thomas as 
the HRT maintainer). Concerning this change: tghe patch that comments out 
recalc_time_offset() call in arch/powerpc/kernel/time.c must have be thrown 
out as well since it's breaking TOD vsyscall support now.

> 	Ingo

WBR, Sergei
