Return-Path: <linux-kernel-owner+w=401wt.eu-S1760339AbZDWT07@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760339AbZDWT07 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 15:26:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760276AbZDWT0m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 15:26:42 -0400
Received: from mx0.towertech.it ([213.215.222.73]:40269 "HELO mx0.towertech.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1760281AbZDWT0l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 15:26:41 -0400
Date: Thu, 23 Apr 2009 21:26:39 +0200
From: Alessandro Zummo <alessandro.zummo@towertech.it>
To: David Brownell <david-b@pacbell.net>
Cc: rtc-linux@googlegroups.com, Atsushi Nemoto <anemo@mba.ocn.ne.jp>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       hcegtvedt@atmel.com, vapier@gentoo.org, rongkai.zhan@windriver.com,
       balajirrao@openmoko.org, broonie@opensource.wolfsonmicro.com
Subject: Re: [rtc-linux] Re: [PATCH] rtc: Make rtc_update_irq callable with
 irqs enabled
Message-ID: <20090423212639.7ba7cb0b@i1501.lan.towertech.it>
In-Reply-To: <200904231225.01618.david-b@pacbell.net>
References: <20090410005820.4fcfcc1f@i1501.lan.towertech.it>
	<200904231202.49465.david-b@pacbell.net>
	<20090423210900.17311407@i1501.lan.towertech.it>
	<200904231225.01618.david-b@pacbell.net>
Organization: Tower Technologies
X-Mailer: Sylpheed
X-This-Is-A-Real-Message: Yes
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 23 Apr 2009 12:25:01 -0700
David Brownell <david-b@pacbell.net> wrote:

> >  but why rtc_update_irq should disable the IRQs? I believe
> >  it can work just fine with IRQs enabled.  
> 
> The last patch I saw was just changing from "caller must
> disable them" to "rtc_update_irq() disables them".
> 
> If you're talking about a different patch, please forward...

 no patch, just theory.

 the question is, do we need IRQs disabled when
 calling rtc_update_irq?

 and if yes, why? to prevent what?

-- 

 Best regards,

 Alessandro Zummo,
  Tower Technologies - Torino, Italy

  http://www.towertech.it

