Return-Path: <linux-kernel-owner+w=401wt.eu-S1754511AbZI3ODq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754511AbZI3ODq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 10:03:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754285AbZI3ODq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 10:03:46 -0400
Received: from mgw1.diku.dk ([130.225.96.91]:36586 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753676AbZI3ODp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 10:03:45 -0400
Date: Wed, 30 Sep 2009 16:03:47 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH] drivers/block/DAC960.c: Use DAC960_V2_Controller
Message-ID: <Pine.LNX.4.64.0909301603230.8553@pc-004.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

DAC960_LP_Controller and DAC960_V2_Controller have the same value, but
elsewhere it is DAC960_V1_Controller or DAC960_V2_Controller that is used
in the FirmwareType field.

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/block/DAC960.c              |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/block/DAC960.c b/drivers/block/DAC960.c
index eb4fa19..ce1fa92 100644
--- a/drivers/block/DAC960.c
+++ b/drivers/block/DAC960.c
@@ -7101,7 +7101,7 @@ static struct DAC960_privdata DAC960_BA_privdata = {
 
 static struct DAC960_privdata DAC960_LP_privdata = {
 	.HardwareType =		DAC960_LP_Controller,
-	.FirmwareType 	=	DAC960_LP_Controller,
+	.FirmwareType 	=	DAC960_V2_Controller,
 	.InterruptHandler =	DAC960_LP_InterruptHandler,
 	.MemoryWindowSize =	DAC960_LP_RegisterWindowSize,
 };
