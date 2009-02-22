Return-Path: <linux-kernel-owner+w=401wt.eu-S1755987AbZBVMTz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755987AbZBVMTz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Feb 2009 07:19:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754466AbZBVMTf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Feb 2009 07:19:35 -0500
Received: from cathcart.site5.com ([74.54.107.137]:43141 "EHLO
	cathcart.site5.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754225AbZBVMTe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Feb 2009 07:19:34 -0500
From: Mike Rapoport <mike@compulab.co.il>
To: dbrownell@users.sourceforge.net
Cc: spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       dcbw@redhat.com, andrey@cozybit.com,
       Mike Rapoport <mike@compulab.co.il>
Subject: [PATCH RESEND 0/3] Add dma_alignment field to spi_master
Date: Sun, 22 Feb 2009 14:19:15 +0200
Message-Id: <cover.1234167048.git.mike@compulab.co.il>
X-Mailer: git-send-email 1.5.6.4
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - cathcart.site5.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - compulab.co.il
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some SPI controllers have restrictions on DMAable buffers alignemt.
Currently if the buffer supplied by protocol driver is not properly
aligned, the controller silently performs transfer in PIO mode.
Addition of dma_alignment field to spi_master allows protocol drivers to
perform proper alignment.

Mike Rapoport (3):
  SPI: add dma_alignment field to spi_master
  pxa2xx_spi: set spi_master.dma_alignment = 8
  spi_imx: set spi_master.dma_alignment = 4

 drivers/spi/pxa2xx_spi.c |    2 ++
 drivers/spi/spi_imx.c    |    2 ++
 include/linux/spi/spi.h  |    6 ++++++
 3 files changed, 10 insertions(+), 0 deletions(-)

