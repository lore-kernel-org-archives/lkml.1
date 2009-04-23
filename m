Return-Path: <linux-kernel-owner+w=401wt.eu-S1758583AbZDWS2I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758583AbZDWS2I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 14:28:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753987AbZDWS1x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 14:27:53 -0400
Received: from mx0.towertech.it ([213.215.222.73]:35686 "HELO mx0.towertech.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756589AbZDWS1w convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 14:27:52 -0400
Date: Thu, 23 Apr 2009 20:27:49 +0200
From: Alessandro Zummo <alessandro.zummo@towertech.it>
To: rtc-linux@googlegroups.com
Cc: david-b@pacbell.net, Atsushi Nemoto <anemo@mba.ocn.ne.jp>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       hcegtvedt@atmel.com, vapier@gentoo.org, rongkai.zhan@windriver.com,
       balajirrao@openmoko.org, broonie@opensource.wolfsonmicro.com
Subject: Re: [rtc-linux] Re: [PATCH] rtc: Make rtc_update_irq callable with
 irqs enabled
Message-ID: <20090423202749.767ab73b@i1501.lan.towertech.it>
In-Reply-To: <200904231115.57525.david-b@pacbell.net>
References: <20090410005820.4fcfcc1f@i1501.lan.towertech.it>
	<20090424.002900.11623503.anemo@mba.ocn.ne.jp>
	<20090423174641.2b03e7a7@i1501.lan.towertech.it>
	<200904231115.57525.david-b@pacbell.net>
Organization: Tower Technologies
X-Mailer: Sylpheed
X-This-Is-A-Real-Message: Yes
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 23 Apr 2009 11:15:56 -0700
David Brownell <david-b@pacbell.net> wrote:

> On Thursday 23 April 2009, Alessandro Zummo wrote:
> >  Is not an API change, we are gradually relaxing it if it
> >  proves workable :)
> 
> Erm, it *is* an API change at least to the extent that
> the last version of the patch made the interface spec
> become incorrect.

 I know, I was just playing it down :)
 
> Current interface spec *requires* that function to be
> called with IRQs disabled.
> 
> The downside of that spec is that there's no way to test
> it, since CONFIG_LOCKDEP doesn't understand that almost
> all IRQ handlers don't disable IRQs.  So there are some
> bugs in RTC drivers that can only be uncovered by code
> review.

 That's was what I was proposing. I'll give a code review
 but will not be able to test every driver so I'll need
 help from the authors. 

 But first I need someone to validate the theory that
 says that we don't really need the IRQs to be disabled,
 as I stated in the email to Andrew.

 do you agree? :)

-- 

 Best regards,

 Alessandro Zummo,
  Tower Technologies - Torino, Italy

  http://www.towertech.it

