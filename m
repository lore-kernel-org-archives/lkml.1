Return-Path: <linux-kernel-owner+w=401wt.eu-S1757570AbZJFPQQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757570AbZJFPQQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 11:16:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757498AbZJFPQQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 11:16:16 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:35818 "EHLO
	bob.linux.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757454AbZJFPQP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 11:16:15 -0400
From: Alan Cox <alan@linux.intel.com>
Subject: [PATCH 0/5] tty_port_open
To: greg@kroah.com, linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Date: Tue, 06 Oct 2009 16:05:50 +0100
Message-ID: <20091006145413.9431.47083.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a tty_port_open method and then propogate the effects through the USB
drivers, which nicely fixes a couple of races and cleans up the code.
---

Alan Cox (5):
      opticon: Fix resume logic
      usb_serial: Kill port mutex
      usb_serial: Use the shutdown() operation
      tty_port: coding style cleaning pass
      tty_port: add "tty_port_open" helper


 drivers/char/tty_port.c         |   50 ++++++++++++++++++++---
 drivers/usb/serial/opticon.c    |    7 ++-
 drivers/usb/serial/usb-serial.c |   83 +++++++++++++--------------------------
 include/linux/tty.h             |   10 ++++-
 include/linux/usb/serial.h      |    3 -
 5 files changed, 83 insertions(+), 70 deletions(-)

-- 
The Zenburger: One with everything

