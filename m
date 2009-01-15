Return-Path: <linux-kernel-owner+w=401wt.eu-S1761593AbZAON34@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761593AbZAON34 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 08:29:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756484AbZAON3s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 08:29:48 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:47357 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755299AbZAON3r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 08:29:47 -0500
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 0/8] Series short description
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Date: Thu, 15 Jan 2009 13:29:55 +0000
Message-ID: <20090115132718.21366.56187.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Assorted small tty fixes, mostly for the HSO driver which appears not to have
been my finest conversion.

---

Alan Cox (2):
      tty: Fix a kref leak in the HSO driver on re-open
      tty: Fix race in the flush for some ldiscs

Daniel Gagnon (1):
      serial: Add SupraExpress 336i PnP Voice Modem

Denis Joseph Barrow (2):
      hso serial throttled tty kref fix.
      tty: Fix double grabbing of a spinlock

Jim Paris (1):
      ftdi_sio: fix kref leak

Jiri Slaby (1):
      8250_pci: add support for netmos 9835 IBM devices

Mischa Jonker (1):
      When a break signal is detected, the next character should be ignored.


 drivers/char/tty_ioctl.c      |    2 +-
 drivers/net/usb/hso.c         |    8 +++++---
 drivers/serial/8250_pci.c     |    8 ++++++++
 drivers/serial/8250_pnp.c     |    2 ++
 drivers/serial/pnx8xxx_uart.c |   23 ++++++++++++-----------
 drivers/usb/serial/ftdi_sio.c |    2 +-
 6 files changed, 29 insertions(+), 16 deletions(-)

-- 
		Take control of enterprise infrastructure
		   Sign up for starfleet academy today

