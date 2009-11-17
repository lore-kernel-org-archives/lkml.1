Return-Path: <linux-kernel-owner+w=401wt.eu-S1754029AbZKQPG6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754029AbZKQPG6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 10:06:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753442AbZKQPG6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 10:06:58 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:40509 "EHLO
	bob.linux.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752811AbZKQPG5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 10:06:57 -0500
From: Alan Cox <alan@linux.intel.com>
Subject: [PATCH 0/5] Series short description
To: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Date: Tue, 17 Nov 2009 14:50:48 +0000
Message-ID: <20091117144450.15430.83450.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pending experimental bits. Not necessarily ready to apply but so folks know
what is going on.

---

Alan Cox (5):
      pata_piccolo: Driver for old Toshiba chipsets
      pata: Update experimental tags
      cmd64x: implement serialization as per notes
      pata_sis: Implement MWDMA for the UDMA 133 capable chips
      pata_via: Blacklist some combinations of Transcend Flash and via


 drivers/ata/Kconfig        |   33 +++++++---
 drivers/ata/Makefile       |    1 
 drivers/ata/ata_generic.c  |    5 +-
 drivers/ata/pata_cmd64x.c  |  132 +++++++++++++++++++++++++++++++++++++++--
 drivers/ata/pata_piccolo.c |  140 ++++++++++++++++++++++++++++++++++++++++++++
 drivers/ata/pata_sis.c     |   88 +++++++++++++++++++++-------
 drivers/ata/pata_via.c     |   27 ++++++++
 include/linux/pci_ids.h    |    7 +-
 8 files changed, 388 insertions(+), 45 deletions(-)
 create mode 100644 drivers/ata/pata_piccolo.c

-- 
My Git tree is full of regressions, my git tree is full of bad C
My Git tree is full of regressions oh git-clone my codebase and see
Git-clone git-clone, oh git-clone my codebase and see, and see
Git-clone git-clone, oh git-clone my codebase and see

