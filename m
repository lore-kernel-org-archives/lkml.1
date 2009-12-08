Return-Path: <linux-kernel-owner+w=401wt.eu-S966162AbZLHVNS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966162AbZLHVNS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 16:13:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756266AbZLHVNN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 16:13:13 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:52204 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756176AbZLHVNM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 16:13:12 -0500
Date: Tue, 8 Dec 2009 22:12:58 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: spi-devel-general@lists.sourceforge.net
Cc: David Brownell <dbrownell@users.sourceforge.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Sascha Hauer <s.hauer@pengutronix.de>, Daniel Mack <daniel@caiaq.de>,
       linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/5] spi-imx: some updates
Message-ID: <20091208211258.GA13706@pengutronix.de>
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

this series depends on "spi: drain MXC SPI transfer buffer when probing
device" which is currently in -mm and also included in my spi-imx branch
(see below).  IMHO at least my first patch should go into .33 as it
fixes an oops.

I'll post the patches for review as a reply to this mail.

Best regards
Uwe

The following changes since commit 6035ccd8e9e40bb654fbfdef325902ab531679a5:
  Linus Torvalds (1):
        Merge branch 'for-2.6.33' of git://git.kernel.dk/linux-2.6-block

are available in the git repository at:

  git://git.pengutronix.de/git/ukl/linux-2.6.git spi-imx

Daniel Mack (1):
      spi: drain MXC SPI transfer buffer when probing device

Sascha Hauer (1):
      spi-imx: Add mx25 support

Uwe Kleine-König (4):
      spi-imx: use platform_driver_probe as probe lives in .init.text
      spi-imx: correct check for platform_get_irq failing
      spi-imx: use positive logic to distinguish cpu variants
      spi-imx: don't access struct device directly but use dev_get_platdata

 drivers/spi/spi_imx.c |   23 +++++++++++++++--------
 1 files changed, 15 insertions(+), 8 deletions(-)
-- 
Pengutronix e.K.                              | Uwe Kleine-König            |
Industrial Linux Solutions                    | http://www.pengutronix.de/  |
