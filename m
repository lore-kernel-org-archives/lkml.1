Return-Path: <linux-kernel-owner+w=401wt.eu-S1754088AbZFKR2V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754088AbZFKR2V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 13:28:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752025AbZFKR2K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 13:28:10 -0400
Received: from d112a2.x-mailer.de ([212.162.53.4]:33585 "EHLO
	d112a2.x-mailer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751985AbZFKR2J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 13:28:09 -0400
Message-Id: <cover.1244739994.git.keil@b1-systems.de>
Date: Thu, 11 Jun 2009 19:06:34 +0200
Subject: [PATCH 0/6] ISDN fixes
From: Karsten Keil <keil@b1-systems.de>
To: linux-kernel@vger.kernel.org
Cc: netdev@vger.kernel.org, David Miller <davem@davemloft.net>,
       i4ldeveloper@listserv.isdn4linux.de
X-Info: valid message
X-Info: original Date
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some more fixes for ISDN.

You can pull it from
git://master.kernel.org/pub/scm/linux/kernel/git/kkeil/ISDN-2.6-net-next.git for_david

Andreas Mohr (1):
  mISDN: Free hfcpci IRQ if init was not successful

Karsten Keil (4):
  ISDN:Fix DMA alloc for hfcpci
  mISDN: Fix overlapping data access
  mISDN: Do not disable IRQ in ph_data_ind()
  mISDN: cleanup mISDNhw.h

Roel Kluin (1):
  drivers/isdn/i4l/isdn_tty.c: fix check for array overindexing

 drivers/isdn/hardware/mISDN/hfcpci.c |    7 ++---
 drivers/isdn/hisax/hfc_pci.c         |   41 ++++++++++++++++++++++++---------
 drivers/isdn/hisax/hisax.h           |    2 +-
 drivers/isdn/i4l/isdn_tty.c          |    2 +-
 drivers/isdn/mISDN/dsp_pipeline.c    |   11 ++++-----
 drivers/isdn/mISDN/tei.c             |    7 +----
 include/linux/mISDNhw.h              |   10 --------
 7 files changed, 42 insertions(+), 38 deletions(-)

