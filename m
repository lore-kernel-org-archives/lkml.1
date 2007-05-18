Return-Path: <linux-kernel-owner+w=401wt.eu-S1756816AbXERMjT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756816AbXERMjT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 08:39:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754378AbXERMjN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 08:39:13 -0400
Received: from mithrandir.softwarenexus.net ([66.98.186.96]:1611 "EHLO
	mail.genesi-usa.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754338AbXERMjM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 08:39:12 -0400
Message-ID: <464D9E7E.3090605@genesi-usa.com>
Date: Fri, 18 May 2007 13:39:26 +0100
From: Matt Sealey <matt@genesi-usa.com>
User-Agent: Thunderbird 2.0.0.0 (Windows/20070326)
MIME-Version: 1.0
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
CC: Kumar Gala <galak@kernel.crashing.org>, linuxppc-dev@ozlabs.org,
       tglx@linutronix.de, mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.21-rt2] PowerPC: decrementer clockevent driver
References: <200705172142.26739.sshtylyov@ru.mvista.com>	<8E44DB06-767D-4864-8D2C-6132E4D4370B@kernel.crashing.org>	<464C99FF.8080404@ru.mvista.com>	<135307ED-7125-4859-8594-4B5B900D92D6@kernel.crashing.org>	<464C9E67.2020909@ru.mvista.com>	<6E0D5E13-C939-4FCE-81A3-F29DFA6436A2@kernel.crashing.org> <464CA222.8000407@ru.mvista.com>
In-Reply-To: <464CA222.8000407@ru.mvista.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Sergei Shtylyov wrote:
> Hello.
> 
> Kumar Gala wrote:
> 
>>> Kumar Gala wrote:
> 
>>>> I haven't looked at all the new clock/timer code, is there any   
>>>> utility in having support for more than one clock source?
> 
>>>    Of course, you may register as many as you like.
> 
>> Sure, but is there any utility in registering more than the  decrementer 
>> on PPC?
> 
>     Not yet. I'm not sure I know any other PPC CPU facility fitting for 
> clockevents. In theory, FIT could be used -- but its period is measured in 
> powers of 2, IIRC.

Wouldn't it be possible to use SoC timer functionality, too, and not limit
this to what is only present on the CPU die?

I guess the real question is, how high resolution does a high resolution
timer need to be, and how often do you want to be handling interrupts?

The 52XX has 8 general purpose timers and 2 slice timers. Both will
generate an interrupt once the clock hits a preset value, the timing
of which is determined by prescalers and the IPB clock..

-- 
Matt Sealey <matt@genesi-usa.com>
Genesi, Manager, Developer Relations
