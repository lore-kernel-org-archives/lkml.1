Return-Path: <linux-kernel-owner+w=401wt.eu-S1757329AbZKROfM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757329AbZKROfM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 09:35:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757237AbZKROfL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 09:35:11 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:35713 "EHLO
	bob.linux.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757204AbZKROfK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 09:35:10 -0500
From: Alan Cox <alan@linux.intel.com>
Subject: [PATCH 00/11] Series short description
To: greg@kroah.com, linux-kernel@vger.kernel.org
Date: Wed, 18 Nov 2009 14:18:45 +0000
Message-ID: <20091118141802.3582.47363.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Resend: This patch series reworks the sdio_uart driver into a modern format
and also replaces the circ buffer stuff it uses with a kfifo which makes the
code a good deal easier to follow.
---

Alan Cox (10):
      sdio_uart: add modem functionality
      sdio_uart: Fix the locking on "func" for new code
      sdio_uart: Style fixes
      sdio_uart: Use kfifo instead of the messy circ stuff
      sdio_uart: Fix termios handling
      sdio_uart: Switch to the open/close helpers
      sdio_uart: Move the open lock
      sdio_uart: refcount the tty objects
      sdio_uart: use tty_port
      tty_port: Move hupcl handling

Nicolas Pitre (1):
      sdio_uart: Fix oops caused by the previous changeset


 drivers/char/tty_port.c      |   13 +
 drivers/mmc/card/sdio_uart.c |  393 ++++++++++++++++++++++++------------------
 2 files changed, 235 insertions(+), 171 deletions(-)

