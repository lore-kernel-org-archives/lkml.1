Return-Path: <linux-kernel-owner+w=401wt.eu-S1754416AbZDWTzv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754416AbZDWTzv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 15:55:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752677AbZDWTzl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 15:55:41 -0400
Received: from mx0.towertech.it ([213.215.222.73]:51129 "HELO mx0.towertech.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751576AbZDWTzl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 15:55:41 -0400
Date: Thu, 23 Apr 2009 21:55:38 +0200
From: Alessandro Zummo <alessandro.zummo@towertech.it>
To: rtc-linux@googlegroups.com
Cc: david-b@pacbell.net, Atsushi Nemoto <anemo@mba.ocn.ne.jp>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       hcegtvedt@atmel.com, vapier@gentoo.org, rongkai.zhan@windriver.com,
       balajirrao@openmoko.org, broonie@opensource.wolfsonmicro.com
Subject: Re: [rtc-linux] Re: [PATCH] rtc: Make rtc_update_irq callable with
 irqs enabled
Message-ID: <20090423215538.256fb5ff@i1501.lan.towertech.it>
In-Reply-To: <200904231245.33435.david-b@pacbell.net>
References: <20090410005820.4fcfcc1f@i1501.lan.towertech.it>
	<200904231225.01618.david-b@pacbell.net>
	<20090423212639.7ba7cb0b@i1501.lan.towertech.it>
	<200904231245.33435.david-b@pacbell.net>
Organization: Tower Technologies
X-Mailer: Sylpheed
X-This-Is-A-Real-Message: Yes
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 23 Apr 2009 12:45:32 -0700
David Brownell <david-b@pacbell.net> wrote:

> If the spinlock is *ever* acquired with IRQs disabled,
> it must *always* be acquired that way.
> 
> The typical use is ... from IRQ context, which will in
> some cases mean IRQs disabled.  QED.

 the spinlock could be acquired with IRQs disabled,
 with spin_lock_irq, in the alarm setup functions and
 acquired with the standard spinlock calls in the irq
 handler.

 would it work?

-- 

 Best regards,

 Alessandro Zummo,
  Tower Technologies - Torino, Italy

  http://www.towertech.it

