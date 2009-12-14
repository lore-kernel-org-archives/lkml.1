Return-Path: <linux-kernel-owner+w=401wt.eu-S1752511AbZLNKcG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752511AbZLNKcG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 05:32:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751318AbZLNKcA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 05:32:00 -0500
Received: from smtp.nokia.com ([192.100.105.134]:47945 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751026AbZLNKb7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 05:31:59 -0500
From: Felipe Balbi <felipe.balbi@nokia.com>
To: linux-kernel@vger.kernel.org
Cc: Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Tony Lindgren <tony@atomide.com>,
       Aaro Koskinen <aaro.koskinen@nokia.com>,
       David Brownell <david-b@pacbell.net>,
       Linux USB Mailing List <linux-usb@vger.kernel.org>,
       Anton Vorontsov <avorontsov@ru.mvista.com>,
       Grazvydas Ignotas <notasas@gmail.com>,
       Madhusudhan Chikkature <madhu.cr@ti.com>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Samuel Ortiz <sameo@openedhand.com>,
       Felipe Balbi <felipe.balbi@nokia.com>
Subject: [RFC/PATCH 0/4] twl4030 threaded_irq support
Date: Mon, 14 Dec 2009 12:30:50 +0200
Message-Id: <1260786654-13294-1-git-send-email-felipe.balbi@nokia.com>
X-Mailer: git-send-email 1.6.6.rc0
In-Reply-To: <20091212183410.GF3092@sirena.org.uk>
References: <20091212183410.GF3092@sirena.org.uk>
X-OriginalArrivalTime: 14 Dec 2009 10:31:25.0622 (UTC) FILETIME=[9695A560:01CA7CA8]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

move twl4030 children to threaded irq.

Felipe Balbi (4):
  input: keyboard: twl4030: move to request_threaded_irq
  input: misc: twl4030: move to request_threaded_irq
  rtc: twl4030: move to request_threaded_irq
  usb: otg: twl4030: move to request_threaded_irq

 drivers/input/keyboard/twl4030_keypad.c |   11 ++---------
 drivers/input/misc/twl4030-pwrbutton.c  |   12 +-----------
 drivers/rtc/rtc-twl4030.c               |   10 +---------
 drivers/usb/otg/twl4030-usb.c           |   10 +---------
 4 files changed, 5 insertions(+), 38 deletions(-)

