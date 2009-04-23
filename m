Return-Path: <linux-kernel-owner+w=401wt.eu-S1756450AbZDWTJV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756450AbZDWTJV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 15:09:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755408AbZDWTJF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 15:09:05 -0400
Received: from mx0.towertech.it ([213.215.222.73]:55571 "HELO mx0.towertech.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753769AbZDWTJE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 15:09:04 -0400
Date: Thu, 23 Apr 2009 21:09:00 +0200
From: Alessandro Zummo <alessandro.zummo@towertech.it>
To: David Brownell <david-b@pacbell.net>
Cc: rtc-linux@googlegroups.com, Atsushi Nemoto <anemo@mba.ocn.ne.jp>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       hcegtvedt@atmel.com, vapier@gentoo.org, rongkai.zhan@windriver.com,
       balajirrao@openmoko.org, broonie@opensource.wolfsonmicro.com
Subject: Re: [rtc-linux] Re: [PATCH] rtc: Make rtc_update_irq callable with
 irqs enabled
Message-ID: <20090423210900.17311407@i1501.lan.towertech.it>
In-Reply-To: <200904231202.49465.david-b@pacbell.net>
References: <20090410005820.4fcfcc1f@i1501.lan.towertech.it>
	<200904231115.57525.david-b@pacbell.net>
	<20090423202749.767ab73b@i1501.lan.towertech.it>
	<200904231202.49465.david-b@pacbell.net>
Organization: Tower Technologies
X-Mailer: Sylpheed
X-This-Is-A-Real-Message: Yes
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 23 Apr 2009 12:02:48 -0700
David Brownell <david-b@pacbell.net> wrote:

> >  as I stated in the email to Andrew.
> > 
> >  do you agree? :)  
> 
> If (rtc_update_irq() starts disabling them locally,
> 	&& its interface stops requiring callers to do that)
> then
> 	it's fine;
> 

 but why rtc_update_irq should disable the IRQs? I believe
 it can work just fine with IRQs enabled.

-- 

 Best regards,

 Alessandro Zummo,
  Tower Technologies - Torino, Italy

  http://www.towertech.it

