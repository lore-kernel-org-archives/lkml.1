Return-Path: <linux-kernel-owner+w=401wt.eu-S1757687AbYDAK2j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757687AbYDAK2j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 06:28:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756169AbYDAK23
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 06:28:29 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:42835 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756013AbYDAK22 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 06:28:28 -0400
Date: Tue, 1 Apr 2008 11:28:25 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Andrew Morton <akpm@linux-foundation.org>, Dmitry Torokhov <dtor@mail.ru>,
       Jiri Kosina <jkosina@suse.cz>
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
Message-ID: <20080401102825.GA30868@rakim.wolfsonmicro.main>
Mail-Followup-To: Andrew Morton <akpm@linux-foundation.org>,
	Dmitry Torokhov <dtor@mail.ru>, Jiri Kosina <jkosina@suse.cz>,
	linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
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
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Cookie: Hire the morally handicapped.
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series adds support for the touchscreen controllers found in
WM97xx devices.  This revision of the series fixes some races when
closing an active device and fixes a shadowed variable.

This patch series is also available in the git repository at:

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
 drivers/input/touchscreen/wm9712.c           |  461 +++++++++++++++
 drivers/input/touchscreen/wm9713.c           |  459 +++++++++++++++
 drivers/input/touchscreen/wm97xx-core.c      |  786 ++++++++++++++++++++++++++
 include/linux/wm97xx.h                       |  311 ++++++++++
 9 files changed, 2738 insertions(+), 0 deletions(-)
 create mode 100644 drivers/input/touchscreen/mainstone-wm97xx.c
 create mode 100644 drivers/input/touchscreen/wm9705.c
 create mode 100644 drivers/input/touchscreen/wm9712.c
 create mode 100644 drivers/input/touchscreen/wm9713.c
 create mode 100644 drivers/input/touchscreen/wm97xx-core.c
 create mode 100644 include/linux/wm97xx.h
