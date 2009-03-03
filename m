Return-Path: <linux-kernel-owner+w=401wt.eu-S1756036AbZCCSYT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756036AbZCCSYT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 13:24:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751291AbZCCSYH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 13:24:07 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:50234 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751130AbZCCSYG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 13:24:06 -0500
Date: Tue, 3 Mar 2009 18:24:03 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Jiri Slaby <jirislaby@gmail.com>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
       Hans-Christian Egtvedt <hcegtvedt@atmel.com>
Subject: [PATCH 0/5] WM97xx updates
Message-ID: <20090303182402.GA29542@rakim.wolfsonmicro.main>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Cookie: BOFH excuse
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series updates the review feedback from the first round and
rolls in the additional patches from Mike Rapoport.  I've not addressed
any of the comments for the at32 driver since I have no ability to test
any changes to that driver but repost it for completeness.

Hans-Christian Egtvedt (1):
      Input: add wm97xx accelerated driver for AVR32 AT32AP700X microprocessors

Mark Brown (2):
      Input: Use disable_irq_nosync() for Mainstone
      Input: Accelerated touchscreen support for Marvell Zylonite

Mike Rapoport (2):
      Input: wm97xx: add BTN_TOUCH event to wm97xx to use it with Android
      Input: add BTN_TOUCH event

 drivers/input/touchscreen/Kconfig            |   28 ++
 drivers/input/touchscreen/Makefile           |    2 +
 drivers/input/touchscreen/at32-wm97xx.c      |  416 ++++++++++++++++++++++++++
 drivers/input/touchscreen/at32-wm97xx.h      |   48 +++
 drivers/input/touchscreen/mainstone-wm97xx.c |    3 +-
 drivers/input/touchscreen/ucb1400_ts.c       |    5 +-
 drivers/input/touchscreen/wm97xx-core.c      |    4 +
 drivers/input/touchscreen/zylonite-wm97xx.c  |  239 +++++++++++++++
 8 files changed, 743 insertions(+), 2 deletions(-)
 create mode 100644 drivers/input/touchscreen/at32-wm97xx.c
 create mode 100644 drivers/input/touchscreen/at32-wm97xx.h
 create mode 100644 drivers/input/touchscreen/zylonite-wm97xx.c
