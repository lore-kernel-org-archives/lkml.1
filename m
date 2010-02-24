Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756580Ab0BXKgn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 05:36:43 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:60974 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756442Ab0BXKgl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 05:36:41 -0500
Date: Wed, 24 Feb 2010 11:35:59 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: David Brownell <dbrownell@users.sourceforge.net>
Cc: linux-arm-kernel@lists.infradead.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Jani Nikula <ext-jani.1.nikula@nokia.com>,
       Daniel =?iso-8859-1?Q?Gl=F6ckner?= <dg@emlix.com>,
       Nate Case <ncase@xes-inc.com>,
       H Hartley Sweeten <hsweeten@visionengravers.com>,
       Daniel Silverstone <dsilvers@simtec.co.uk>,
       Arnd Bergmann <arnd@arndb.de>, Mike Frysinger <vapier@gentoo.org>,
       Kevin Wells <kevin.wells@nxp.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] gpiolib: make names array and its values const
Message-ID: <20100224103559.GA15181@pengutronix.de>
References: <20100203155558.GH11354@pengutronix.de> <1265620180-14150-1-git-send-email-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1265620180-14150-1-git-send-email-u.kleine-koenig@pengutronix.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

what do you think about these three patches?  Should I resend?

Best regards
Uwe

The following changes since commit 6339204ecc2aa2067a99595522de0403f0854bb8:
  Linus Torvalds (1):
        Merge branch 'for-linus' of git://git.kernel.org/.../viro/vfs-2.6

are available in the git repository at:

  git://git.pengutronix.de/git/ukl/linux-2.6.git gpiolib/names

Uwe Kleine-König (3):
      gpiolib: make names array and its values const
      gpiolib: a gpio is unsigned, so use %u to print it
      gpiolib: document that names can contain printk format specifiers

 drivers/gpio/gpiolib.c      |    4 ++--
 drivers/gpio/pca953x.c      |    2 +-
 include/asm-generic/gpio.h  |    6 ++++--
 include/linux/i2c/pca953x.h |    2 +-
 4 files changed, 8 insertions(+), 6 deletions(-)
-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
