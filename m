Return-Path: <linux-kernel-owner+w=401wt.eu-S1751917AbZDXLNq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751917AbZDXLNq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 07:13:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751128AbZDXLNi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 07:13:38 -0400
Received: from mx0.towertech.it ([213.215.222.73]:33426 "HELO mx0.towertech.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750927AbZDXLNh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 07:13:37 -0400
Date: Fri, 24 Apr 2009 13:13:34 +0200
From: Alessandro Zummo <alessandro.zummo@towertech.it>
To: rtc-linux@googlegroups.com
Cc: david-b@pacbell.net, Atsushi Nemoto <anemo@mba.ocn.ne.jp>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       hcegtvedt@atmel.com, vapier@gentoo.org, rongkai.zhan@windriver.com,
       balajirrao@openmoko.org, broonie@opensource.wolfsonmicro.com
Subject: Re: [rtc-linux] Re: [PATCH] rtc: Make rtc_update_irq callable with
 irqs enabled
Message-ID: <20090424131334.10959f78@i1501.lan.towertech.it>
In-Reply-To: <200904240410.52543.david-b@pacbell.net>
References: <20090410005820.4fcfcc1f@i1501.lan.towertech.it>
	<200904240231.12906.david-b@pacbell.net>
	<20090424120100.76797d20@i1501.lan.towertech.it>
	<200904240410.52543.david-b@pacbell.net>
Organization: Tower Technologies
X-Mailer: Sylpheed
X-This-Is-A-Real-Message: Yes
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 24 Apr 2009 04:10:51 -0700
David Brownell <david-b@pacbell.net> wrote:

> >  use spin_lock() in the IRQ handler and spin_lock_irq/irq_save
> >  in the setup functions.  
> 
> I think you're describing how the *current* scheme is supposed
> to work ... except that some IRQ handlers aren't calling the
> rtc_update_irq() routine with IRQs blocked.
> 
> Yes, that current scheme works ... modulo those buggy handlers.

 ok, but why it's necessary to disable the interrupts? Only because
 the specs says so or because there's a locking issue I'm missing?

-- 

 Best regards,

 Alessandro Zummo,
  Tower Technologies - Torino, Italy

  http://www.towertech.it

