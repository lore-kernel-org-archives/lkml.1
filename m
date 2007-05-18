Return-Path: <linux-kernel-owner+w=401wt.eu-S1758031AbXERNoP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758031AbXERNoP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 09:44:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755018AbXERNoD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 09:44:03 -0400
Received: from h155.mvista.com ([63.81.120.155]:31202 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755176AbXERNoA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 09:44:00 -0400
Message-ID: <464DADFC.3080802@ru.mvista.com>
Date: Fri, 18 May 2007 17:45:32 +0400
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Matt Sealey <matt@genesi-usa.com>
Cc: Kumar Gala <galak@kernel.crashing.org>, linuxppc-dev@ozlabs.org,
       tglx@linutronix.de, mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.21-rt2] PowerPC: decrementer clockevent driver
References: <200705172142.26739.sshtylyov@ru.mvista.com>	<8E44DB06-767D-4864-8D2C-6132E4D4370B@kernel.crashing.org>	<464C99FF.8080404@ru.mvista.com>	<135307ED-7125-4859-8594-4B5B900D92D6@kernel.crashing.org>	<464C9E67.2020909@ru.mvista.com>	<6E0D5E13-C939-4FCE-81A3-F29DFA6436A2@kernel.crashing.org> <464CA222.8000407@ru.mvista.com> <464D9E7E.3090605@genesi-usa.com>
In-Reply-To: <464D9E7E.3090605@genesi-usa.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Matt Sealey wrote:

>>>>>I haven't looked at all the new clock/timer code, is there any   
>>>>>utility in having support for more than one clock source?

>>>>   Of course, you may register as many as you like.

>>>Sure, but is there any utility in registering more than the  decrementer 
>>>on PPC?

>>    Not yet. I'm not sure I know any other PPC CPU facility fitting for 
>>clockevents. In theory, FIT could be used -- but its period is measured in 
>>powers of 2, IIRC.

> Wouldn't it be possible to use SoC timer functionality, too, and not limit
> this to what is only present on the CPU die?

    If you have some SoC timers, you're welcome to add support for it. :-)

> I guess the real question is, how high resolution does a high resolution
> timer need to be,

    In the order of microseconds.

 > and how often do you want to be handling interrupts?

    That depends on a kind of functionality you need: HRT and/or dynamic tick...

> The 52XX has 8 general purpose timers and 2 slice timers. Both will
> generate an interrupt once the clock hits a preset value, the timing
> of which is determined by prescalers and the IPB clock..

WBR, Sergei
