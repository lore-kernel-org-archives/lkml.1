Return-Path: <linux-kernel-owner+w=401wt.eu-S1758692AbZCXKVn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758692AbZCXKVn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 06:21:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755518AbZCXKVc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 06:21:32 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:46146 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753571AbZCXKVb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 06:21:31 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 0/4] libata patches for 2.6.30
To: jeff@garzik.org, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Date: Tue, 24 Mar 2009 10:21:34 +0000
Message-ID: <20090324101952.9152.30261.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just a small set but the libata stuff is fairly important
---

Alan Cox (4):
      libata: Improve timeout handling
      libata: Drain data on errors
      pata_sc1200: Activate secondary channel
      pata_artop: Serializing support


 block/blk-settings.c       |    2 -
 drivers/ata/libata-eh.c    |   19 ++++++++-
 drivers/ata/libata-sff.c   |   91 +++++++++++++++++++++++++++++++++++++++++++-
 drivers/ata/pata_artop.c   |   33 +++++++++++++---
 drivers/ata/pata_isapnp.c  |   12 +++++-
 drivers/ata/pata_pcmcia.c  |   34 ++++++++++++++++
 drivers/ata/pata_sc1200.c  |   29 +++++++++++++-
 drivers/ata/pdc_adma.c     |    2 +
 drivers/ata/sata_mv.c      |    2 +
 drivers/ata/sata_nv.c      |    1 
 drivers/ata/sata_promise.c |    2 +
 drivers/ata/sata_qstor.c   |    1 
 drivers/ata/sata_vsc.c     |    3 +
 include/linux/libata.h     |    5 ++
 14 files changed, 219 insertions(+), 17 deletions(-)

-- 
If this writing is visible please refill and remember to order a new box of
signature files from your supplier

