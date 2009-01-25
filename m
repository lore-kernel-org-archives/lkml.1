Return-Path: <linux-kernel-owner+w=401wt.eu-S1756946AbZAYMae@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756946AbZAYMae (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2009 07:30:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753158AbZAYMa0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Jan 2009 07:30:26 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:57998 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752268AbZAYMaZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2009 07:30:25 -0500
Date: Sun, 25 Jan 2009 13:30:23 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: Ben Dooks <ben-linux@fluff.org>, Tony Lindgren <tony@atomide.com>,
       linux-arm-kernel@lists.arm.linux.org.uk
Subject: Patches for linux-rt on ARM
Message-ID: <20090125123023.GA12248@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

as a reply I send some patches that fix compilation of most ARM
defconfigs for the linux-rt tree and allow enabling PREEMPT_RT for ARM.
Two commits are already in Linus' tree and so cherry-picked from there.
My commits are new.

There are some commits pending in Russell's queue that should be applied
on linux-rt, too.  I will write another email when they hit Linus'
master branch.

Shortlog and diffstat are below.

Best regards
Uwe

Ben Dooks (1):
      [ARM] S3C24XX: Add gpio_to_irq() facility

Tony Lindgren (1):
      ARM: OMAP: Fix gpio.c compile on 15xx with CONFIG_DEBUGFS

Uwe Kleine-König (2):
      fix compilation error in ide code
      Use kernel/Kconfig.preempt for ARM

 arch/arm/Kconfig                          |   13 +------------
 arch/arm/mach-s3c2410/include/mach/gpio.h |    1 +
 arch/arm/plat-omap/gpio.c                 |    3 +++
 include/linux/ide.h                       |    2 +-
 kernel/Kconfig.preempt                    |    2 ++
 5 files changed, 8 insertions(+), 13 deletions(-)

-- 
Pengutronix e.K.                              | Uwe Kleine-König            |
Industrial Linux Solutions                    | http://www.pengutronix.de/  |
Peiner Strasse 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686              | Fax:   +49-5121-206917-5555 |
