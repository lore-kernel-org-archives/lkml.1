Return-Path: <linux-kernel-owner+w=401wt.eu-S1757288AbZA3WGK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757288AbZA3WGK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 17:06:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757167AbZA3WFy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 17:05:54 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:41238 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755793AbZA3WFx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 17:05:53 -0500
Date: Fri, 30 Jan 2009 23:05:50 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ben Dooks <ben-linux@fluff.org>,
       Tony Lindgren <tony@atomide.com>,
       linux-arm-kernel@lists.arm.linux.org.uk
Subject: Re: Patches for linux-rt on ARM
Message-ID: <20090130220550.GA20596@pengutronix.de>
References: <20090125123023.GA12248@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090125123023.GA12248@pengutronix.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Steven,

> as a reply I send some patches that fix compilation of most ARM
> defconfigs for the linux-rt tree and allow enabling PREEMPT_RT for ARM.
> Two commits are already in Linus' tree and so cherry-picked from there.
> My commits are new.

as requested by you in irc the following changes since commit
4a6908a3a050aacc9c3a2f36b276b46c0629ad91:
  Linus Torvalds (1):
        Linux 2.6.28

(e.g. your "linus" branch) are available in the git repository at:

  git://git.pengutronix.de/git/ukl/linux-2.6.git rt-arm

There is one patch that I dropped since the first post, because you
fixed it yourself in 2766d45892aa914abc96ec8c9f3688ca3ea468e8.  In turn
there is a new fix for the am79c961a driver that hit mainline in the
meantime.

Apart from "Use kernel/Kconfig.preempt for ARM" all patches are
cherry-picked from Linus' tree to fix compilation errors in your -rt
tree.

Shortlog and diffstat can be found below.

Best regards
Uwe

Ben Dooks (1):
      [ARM] S3C24XX: Add gpio_to_irq() facility

Tony Lindgren (1):
      ARM: OMAP: Fix gpio.c compile on 15xx with CONFIG_DEBUGFS

Uwe Kleine-König (2):
      Use kernel/Kconfig.preempt for ARM
      [NET] am79c961a: fix spin_lock usage

 arch/arm/Kconfig                          |   13 +------------
 arch/arm/mach-s3c2410/include/mach/gpio.h |    1 +
 arch/arm/plat-omap/gpio.c                 |    3 +++
 drivers/net/arm/am79c961a.c               |   20 ++++++++++----------
 kernel/Kconfig.preempt                    |    2 ++
 5 files changed, 17 insertions(+), 22 deletions(-)

-- 
Pengutronix e.K.                              | Uwe Kleine-König            |
Industrial Linux Solutions                    | http://www.pengutronix.de/  |
Peiner Strasse 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686              | Fax:   +49-5121-206917-5555 |
