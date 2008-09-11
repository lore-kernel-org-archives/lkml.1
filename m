Return-Path: <linux-kernel-owner+w=401wt.eu-S1755989AbYIKMfE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755989AbYIKMfE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2008 08:35:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755650AbYIKMed
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Sep 2008 08:34:33 -0400
Received: from mgw1.diku.dk ([130.225.96.91]:58179 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755597AbYIKMeb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2008 08:34:31 -0400
Date: Thu, 11 Sep 2008 14:34:29 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: maciej.sosnowski@intel.com, linux-kernel@vger.kernel.org,
       vigneshbabu@gmail.com, richard.genoud@gmail.com,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 5/5] drivers/dma/ioat_dma.c: Drop code after return
Message-ID: <Pine.LNX.4.64.0809111434100.9593@pc-004.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

The break after the return serves no purpose.

Signed-off-by: Julia Lawall <julia@diku.dk>
---

 drivers/dma/ioat_dma.c        |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/dma/ioat_dma.c b/drivers/dma/ioat_dma.c
index bc8c6e3..1ef68b3 100644
--- a/drivers/dma/ioat_dma.c
+++ b/drivers/dma/ioat_dma.c
@@ -971,11 +971,9 @@ static struct ioat_desc_sw *ioat_dma_get_next_descriptor(
 	switch (ioat_chan->device->version) {
 	case IOAT_VER_1_2:
 		return ioat1_dma_get_next_descriptor(ioat_chan);
-		break;
 	case IOAT_VER_2_0:
 	case IOAT_VER_3_0:
 		return ioat2_dma_get_next_descriptor(ioat_chan);
-		break;
 	}
 	return NULL;
 }
