Return-Path: <linux-kernel-owner+w=401wt.eu-S1761552AbYCDOC7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761552AbYCDOC7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 09:02:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753210AbYCDOCu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 09:02:50 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:49988 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751597AbYCDOCt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 09:02:49 -0500
Date: Tue, 4 Mar 2008 14:02:51 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Andrew Morton <akpm@linux-foundation.org>, Dmitry Torokhov <dtor@mail.ru>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
       Hans-Christian Egtvedt <hcegtvedt@atmel.com>,
       Liam Girdwood <liam.girdwood@wolfsonmicro.com>,
       Graeme Gregory <gg@opensource.wolfsonmicro.com>,
       Dmitry Baryshkov <dbaryshkov@gmail.com>,
       Rodolfo Giometti <giometti@enneenne.com>,
       Russell King <rmk@arm.linux.org.uk>,
       Marc Kleine-Budde <mkl@pengutronix.de>,
       Pete MacKay <linux01@architechnical.net>, Ian Molton <spyro@f2s.com>,
       Vince Sanders <vince@kyllikki.org>, Andrew Zabolotny <zap@homelink.ru>
Subject: WM97xx touchscreen drivers
Message-ID: <20080304140251.GA24649@rakim.wolfsonmicro.main>
Mail-Followup-To: Andrew Morton <akpm@linux-foundation.org>,
	Dmitry Torokhov <dtor@mail.ru>, linux-input@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Hans-Christian Egtvedt <hcegtvedt@atmel.com>,
	Liam Girdwood <liam.girdwood@wolfsonmicro.com>,
	Graeme Gregory <gg@opensource.wolfsonmicro.com>,
	Dmitry Baryshkov <dbaryshkov@gmail.com>,
	Rodolfo Giometti <giometti@enneenne.com>,
	Russell King <rmk@arm.linux.org.uk>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Pete MacKay <linux01@architechnical.net>,
	Ian Molton <spyro@f2s.com>, Vince Sanders <vince@kyllikki.org>,
	Andrew Zabolotny <zap@homelink.ru>
References: <20080229165029.GB11451@rakim.wolfsonmicro.main>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080229165029.GB11451@rakim.wolfsonmicro.main>
X-Cookie: NOBODY EXPECTS THE SPANISH INQUISITION!
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series adds support for the touchscreen controllers found in
WM97xx devices.  This revision of the series adds support for
configuration of the interrupt source used for pen down detection in
accelerated touch drivers.

These changes are also available in the git repository at:

  git://opensource.wolfsonmicro.com/linux-2.6-touch upstream

Mark Brown (6):
      Core driver for WM97xx touchscreens
      Add chip driver for WM9705 touchscreen
      Add chip driver for WM9712 touchscreen
      Add chip driver for WM9713 touchscreen
      Driver for WM97xx touchscreens in streaming mode on Mainstone
      Build system and MAINTAINERS entry for WM97xx touchscreen drivers

 MAINTAINERS                                  |   10 +
 drivers/input/touchscreen/Kconfig            |   52 ++
 drivers/input/touchscreen/Makefile           |    7 +
 drivers/input/touchscreen/mainstone-wm97xx.c |  300 ++++++++++
 drivers/input/touchscreen/wm9705.c           |  352 ++++++++++++
 drivers/input/touchscreen/wm9712.c           |  461 ++++++++++++++++
 drivers/input/touchscreen/wm9713.c           |  459 ++++++++++++++++
 drivers/input/touchscreen/wm97xx-core.c      |  762 ++++++++++++++++++++++++++
 include/linux/wm97xx.h                       |  311 +++++++++++
 9 files changed, 2714 insertions(+), 0 deletions(-)
 create mode 100644 drivers/input/touchscreen/mainstone-wm97xx.c
 create mode 100644 drivers/input/touchscreen/wm9705.c
 create mode 100644 drivers/input/touchscreen/wm9712.c
 create mode 100644 drivers/input/touchscreen/wm9713.c
 create mode 100644 drivers/input/touchscreen/wm97xx-core.c
 create mode 100644 include/linux/wm97xx.h
