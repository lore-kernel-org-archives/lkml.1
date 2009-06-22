Return-Path: <linux-kernel-owner+w=401wt.eu-S1757726AbZFVQbz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757726AbZFVQbz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 12:31:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754446AbZFVQbq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 12:31:46 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:49523 "EHLO
	t61.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753677AbZFVQbp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 12:31:45 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 00/15] Serial/tty follow up fixes for 2.6,31
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Date: Mon, 22 Jun 2009 18:30:11 +0100
Message-ID: <20090622172929.25341.31151.stgit@t61.ukuu.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

---

Alan Cox (3):
      msm: fixups to match current code
      tty: fix some bogns in the serqt_usb2 driver
      ppp: Fix throttling bugs

Jiri Slaby (3):
      vt_ioctl: fix lock imbalance
      pcmcia/cm4000: fix lock imbalance
      n_r3964: fix lock imbalance

Kevin Hilman (1):
      serial@ add OMAP wakeup-enable register

Mike Frysinger (3):
      serial: bfin_5xx: fix building as module when early printk is enabled
      serial: bfin_5xx: add missing spin_lock init
      bfin_jtag_comm: clean up printk usage

Paul Fulghum (1):
      tty: n_hdlc add buffer flushing

Peter Korsgaard (1):
      serial: samsung.c: mark s3c24xx_serial_remove as __devexit

Richard Röjfors (1):
      timbuart: Fix for tx_empty

Robert Love (1):
      msm_serial: serial driver for MSM7K onboard serial peripheral.

Roel Kluin (1):
      serial: fix off by one errors


 drivers/char/bfin_jtag_comm.c           |   30 +
 drivers/char/n_hdlc.c                   |   46 +-
 drivers/char/n_r3964.c                  |   26 +
 drivers/char/pcmcia/cm4000_cs.c         |    3 
 drivers/char/vt_ioctl.c                 |    3 
 drivers/net/ppp_async.c                 |    1 
 drivers/net/ppp_synctty.c               |    1 
 drivers/serial/Kconfig                  |   10 
 drivers/serial/Makefile                 |    1 
 drivers/serial/bfin_5xx.c               |    5 
 drivers/serial/msm_serial.c             |  772 +++++++++++++++++++++++++++++++
 drivers/serial/msm_serial.h             |  117 +++++
 drivers/serial/s3c2400.c                |    2 
 drivers/serial/s3c2410.c                |    2 
 drivers/serial/s3c2412.c                |    2 
 drivers/serial/s3c2440.c                |    2 
 drivers/serial/s3c24a0.c                |    2 
 drivers/serial/s3c6400.c                |    2 
 drivers/serial/samsung.c                |    2 
 drivers/serial/samsung.h                |    2 
 drivers/serial/sb1250-duart.c           |    6 
 drivers/serial/sunhv.c                  |    2 
 drivers/serial/timbuart.c               |   50 +-
 drivers/serial/zs.c                     |    6 
 drivers/staging/serqt_usb2/serqt_usb2.c |   29 -
 include/linux/serial_core.h             |    3 
 include/linux/serial_reg.h              |    1 
 27 files changed, 1029 insertions(+), 99 deletions(-)
 create mode 100644 drivers/serial/msm_serial.c
 create mode 100644 drivers/serial/msm_serial.h

-- 
ENOJOKE
