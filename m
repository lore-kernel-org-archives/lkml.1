Return-Path: <linux-kernel-owner+w=401wt.eu-S1755214AbZI3TnH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755214AbZI3TnH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 15:43:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754735AbZI3TnG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 15:43:06 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:36959 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754197AbZI3TnG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 15:43:06 -0400
Date: Wed, 30 Sep 2009 21:42:11 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: spi-devel-general@lists.sourceforge.net
Cc: David Brownell <dbrownell@users.sourceforge.net>,
       Sascha Hauer <s.hauer@pengutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
       spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [PATCH 0/7] Updates for spi-imx
Message-ID: <20090930194211.GB1881@pengutronix.de>
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

as a followup to this mail I'll send some updates for the spi-imx
driver for review.

Overall diffstat and shortlog can be found below.

You can find the patches based on current Linus' master at

  git://git.pengutronix.de/git/ukl/linux-2.6.git spi-imx

Sascha Hauer (3):
      spi-imx: update state correctly
      spi-imx: Fix initial chipselect settings
      spi-imx: setup mode_bits we can handle

Uwe Kleine-König (4):
      spi-imx: rename source file to spi_imx.c
      spi-imx: no need to assert bits_per_word being initialized
      spi-imx: initialize complete config struct
      [RFC] spi-imx: strip down chipselect function to only drive the chipselect

 drivers/spi/Makefile                 |    2 +-
 drivers/spi/{mxc_spi.c => spi_imx.c} |  383 +++++++++++++++++-----------------
 2 files changed, 190 insertions(+), 195 deletions(-)
 rename drivers/spi/{mxc_spi.c => spi_imx.c} (55%)
-- 
Pengutronix e.K.                              | Uwe Kleine-König            |
Industrial Linux Solutions                    | http://www.pengutronix.de/  |
