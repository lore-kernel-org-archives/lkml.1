Return-Path: <linux-kernel-owner+w=401wt.eu-S1755051AbZDXTl3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755051AbZDXTl3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 15:41:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751272AbZDXTlV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 15:41:21 -0400
Received: from mx0.towertech.it ([213.215.222.73]:46118 "HELO mx0.towertech.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751822AbZDXTlU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 15:41:20 -0400
Date: Fri, 24 Apr 2009 21:41:17 +0200
From: Alessandro Zummo <alessandro.zummo@towertech.it>
To: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Cc: rtc-linux@googlegroups.com, david-b@pacbell.net, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, hcegtvedt@atmel.com, vapier@gentoo.org,
       rongkai.zhan@windriver.com, balajirrao@openmoko.org,
       broonie@opensource.wolfsonmicro.com
Subject: Re: [rtc-linux] Re: [PATCH] rtc: Make rtc_update_irq callable with
 irqs enabled
Message-ID: <20090424214117.76bc3dda@i1501.lan.towertech.it>
In-Reply-To: <20090425.020612.92585418.anemo@mba.ocn.ne.jp>
References: <200904240410.52543.david-b@pacbell.net>
	<20090424131334.10959f78@i1501.lan.towertech.it>
	<20090425.014850.93020801.anemo@mba.ocn.ne.jp>
	<20090425.020612.92585418.anemo@mba.ocn.ne.jp>
Organization: Tower Technologies
X-Mailer: Sylpheed
X-This-Is-A-Real-Message: Yes
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 25 Apr 2009 02:06:12 +0900 (JST)
Atsushi Nemoto <anemo@mba.ocn.ne.jp> wrote:

>  RTC alarm interrupt handler takes rtc->irq_lock by spin_lock()
> > 2. A timer interrupt handler calls rtc_uie_timer() for UIE emulation
> > 3. rtc_uie_timer() waits on rtc->irq_lock .... deadlock!  
> 
> Oops, this is wrong.  This deadlock cannot happen since
> rtc_uie_timer() will be called in bh (softirq) context, not interrupt
> context.

 Correct.

 And we have only one irq handler per driver. Anything else?

-- 

 Best regards,

 Alessandro Zummo,
  Tower Technologies - Torino, Italy

  http://www.towertech.it

