Return-Path: <linux-kernel-owner+w=401wt.eu-S1757150AbYLERQ7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757150AbYLERQ7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2008 12:16:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756469AbYLERQg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Dec 2008 12:16:36 -0500
Received: from www.crouse-house.com ([199.45.160.146]:54364 "EHLO
	mail.crouse-house.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756486AbYLERQe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2008 12:16:34 -0500
Message-ID: <493961EE.6000002@cosmicpenguin.net>
Date: Fri, 05 Dec 2008 10:16:30 -0700
From: Jordan Crouse <jordan@cosmicpenguin.net>
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel
To: Harald Dunkel <harald.dunkel@t-online.de>
CC: Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.27.7 built for Geode: Clock drift
References: <49358017.7080009@t-online.de>
In-Reply-To: <49358017.7080009@t-online.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Harald Dunkel wrote:
> Hi folks,
> 
> If I build a kernel for AMD Geode, then I see a clock drift of appr.
> 30 min. to 1 hour per day. If I build the same kernel for i486, then
> the clock drift is gone. Running ntp makes no difference.
> 
> Hardware is a Linutop PC. /proc/cpuinfo says
> 
> processor       : 0
> vendor_id       : AuthenticAMD
> cpu family      : 5
> model           : 10
> model name      : Geode(TM) Integrated Processor by AMD PCS
> stepping        : 2
> cpu MHz         : 0.000
> cache size      : 128 KB
> fdiv_bug        : no
> hlt_bug         : no
> f00f_bug        : no
> coma_bug        : no
> fpu             : yes
> fpu_exception   : yes
> cpuid level     : 1
> wp              : yes
> flags           : fpu de pse tsc msr cx8 sep pge cmov clflush mmx mmxext 3dnowext 3dnow
> bogomips        : 429.05
> clflush size    : 32
> power management:
> 
> BTW, the CPU is running with 500 MHz (AFAIK). 0.000 MHz is surely not
> correct. /proc/cpuinfo reports the same for both kernels.

Hmm - we've heard reports of this before, but nothing came of it.  I 
would be interested in a chance to debug it this time.

Please try turning off CONFIG_GEODE_MFGPT_TIMER=y and try again.  Also, 
try something in the 2.6.28 family to rule out fixes in the timer subsystem.

Thanks,
Jordan
