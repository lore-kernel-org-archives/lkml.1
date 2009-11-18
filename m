Return-Path: <linux-kernel-owner+w=401wt.eu-S1757191AbZKRO00@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757191AbZKRO00 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 09:26:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757159AbZKRO00
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 09:26:26 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:46391 "EHLO
	bob.linux.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757035AbZKRO0Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 09:26:25 -0500
From: Alan Cox <alan@linux.intel.com>
Subject: [PATCH 0/7] more beating of serial in the direction of sanity
To: greg@kroah.com, linux-kernel@vger.kernel.org
Date: Wed, 18 Nov 2009 14:09:59 +0000
Message-ID: <20091118140935.2798.32517.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

---

Alan Cox (7):
      istallion: tty port open/close methods
      stallion: Convert to the tty_port_open/close methods
      tty_port: Move the IO_ERROR clear
      tty_port: Add IO_ERROR bit handling
      riscom8: switch to the tty_port_open API
      n_tty: fix throttling
      tty_port: Change the buffer allocator locking


 drivers/char/istallion.c |  177 ++++++++++++++++------------------------------
 drivers/char/n_tty.c     |   35 +++++++--
 drivers/char/riscom8.c   |   89 +++++++++++------------
 drivers/char/stallion.c  |  118 +++++++++----------------------
 drivers/char/tty_port.c  |   15 +++-
 include/linux/tty.h      |    1 
 6 files changed, 174 insertions(+), 261 deletions(-)

