Return-Path: <linux-kernel-owner+w=401wt.eu-S1753182AbZHITyO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753182AbZHITyO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Aug 2009 15:54:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752854AbZHITyN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Aug 2009 15:54:13 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:14585 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752600AbZHITyM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Aug 2009 15:54:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:message-id:x-mailer;
        b=KB1DnTLHuXNyPqMVSpi+ozgdERGPlpSYSuovacslW4BCQV/ZjgYOXAqnPxaQJJMsHL
         h3ltI0vRGrZjTrehQOWfoV0Be1cTNAPuxVzjD3+6C7HqJ+VQPuMwXdQ9aHLTi8RiOd9b
         d5+4n7loN7sgoa17mcJGod0Yya9KGIZOLPng0=
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 00/14] use printk_once
Date: Sun,  9 Aug 2009 21:53:55 +0200
Message-Id: <1249847649-11631-1-git-send-email-marcin.slusarz@gmail.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 arch/alpha/kernel/pci_iommu.c      |    6 +-----
 arch/ia64/kernel/unaligned.c       |    6 ++----
 arch/ia64/sn/kernel/io_common.c    |    8 ++------
 arch/powerpc/kernel/iommu.c        |    6 +-----
 arch/powerpc/kernel/irq.c          |    5 ++---
 arch/powerpc/sysdev/ppc4xx_pci.c   |    9 ++-------
 arch/sh/mm/ioremap_64.c            |    6 +-----
 arch/x86/kernel/irq_32.c           |    5 ++---
 arch/x86/kvm/x86.c                 |    7 +------
 drivers/ata/pata_rz1000.c          |    4 +---
 drivers/block/paride/pcd.c         |   12 ++++--------
 drivers/block/sx8.c                |    4 +---
 drivers/block/viodasd.c            |   12 +++---------
 drivers/char/tty_ioctl.c           |    4 +---
 drivers/char/vt.c                  |    6 +-----
 drivers/ide/ide-proc.c             |    8 +-------
 drivers/infiniband/hw/cxgb3/iwch.c |    4 +---
 drivers/infiniband/hw/mlx4/main.c  |    6 +-----
 drivers/net/mlx4/en_main.c         |    6 +-----
 drivers/net/mv643xx_eth.c          |    4 +---
 drivers/scsi/53c700.c              |    6 +-----
 drivers/scsi/cxgb3i/cxgb3i_init.c  |    7 +------
 lib/vsprintf.c                     |   14 ++------------
 net/ax25/af_ax25.c                 |    6 +-----
 net/dsa/dsa.c                      |    4 +---
 net/ipv4/raw.c                     |    6 ++----
 net/netfilter/xt_recent.c          |   10 +++-------
 net/socket.c                       |    8 ++------
 28 files changed, 43 insertions(+), 146 deletions(-)
