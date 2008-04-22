Return-Path: <linux-kernel-owner+w=401wt.eu-S1762165AbYDVBiY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762165AbYDVBiY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 21:38:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933114AbYDVBgD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 21:36:03 -0400
Received: from syd-iport-1.cisco.com ([64.104.193.196]:48111 "EHLO
	syd-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933008AbYDVBf7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 21:35:59 -0400
X-Greylist: delayed 594 seconds by postgrey-1.27 at vger.kernel.org; Mon, 21 Apr 2008 21:35:57 EDT
From: Roland Dreier <rdreier@cisco.com>
To: torvalds@linux-foundation.org, akpm@linux-foundation.org
Cc: general@lists.openfabrics.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] please pull infiniband.git
X-Message-Flag: Warning: May contain useful information
Date: Mon, 21 Apr 2008 18:26:00 -0700
Message-ID: <ada8wz6adef.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 22 Apr 2008 01:26:00.0895 (UTC) FILETIME=[D2DCD4F0:01C8A417]
Authentication-Results: syd-dkim-1; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/syddkim1002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from

    master.kernel.org:/pub/scm/linux/kernel/git/roland/infiniband.git for-linus

This tree is also available from kernel.org mirrors at:

    git://git.kernel.org/pub/scm/linux/kernel/git/roland/infiniband.git for-linus

This will get a few fixes for various things, including one build fix
for the ipath driver:

Paul Bolle (1):
      IB/ipath: Fix module parameter description for disable_sma

Roland Dreier (6):
      RDMA/nes: Remove unneeded function declarations
      IB/ipath: Remove reference to dev->class_dev
      IB/ipath: Build IBA7220 code unconditionally
      IB/ipath: Remove dependency on PCI_MSI || HT_IRQ
      IB/ipath: Remove tests of PCI_MSI in ipath_iba7220.c
      IB/ipath: Correct capitalization "IntX" -> "INTx"

 drivers/infiniband/hw/ipath/Kconfig         |    2 +-
 drivers/infiniband/hw/ipath/Makefile        |    6 ++++--
 drivers/infiniband/hw/ipath/ipath_driver.c  |    2 +-
 drivers/infiniband/hw/ipath/ipath_iba7220.c |   23 +++++++++--------------
 drivers/infiniband/hw/ipath/ipath_verbs.c   |    3 +--
 drivers/infiniband/hw/nes/nes.c             |    6 ------
 drivers/infiniband/hw/nes/nes_nic.c         |    9 ---------
 7 files changed, 16 insertions(+), 35 deletions(-)
