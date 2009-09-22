Return-Path: <linux-kernel-owner+w=401wt.eu-S932265AbZIVQDR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932265AbZIVQDR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 12:03:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932255AbZIVQDQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 12:03:16 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:47092 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932254AbZIVQDP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 12:03:15 -0400
Date: Tue, 22 Sep 2009 18:03:17 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: thomas@winischhofer.net, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH] drivers/video/sis: change the field used with the VB_SISLVDS
 constant
Message-ID: <Pine.LNX.4.64.0909221802310.20456@pc-004.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

The constant VB_SISLVDS and other VB_ constants are used elsewhere in this
file with the SiS_VBType field, not the SiS_VBInfo field.

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/video/sis/init301.c         |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/video/sis/init301.c b/drivers/video/sis/init301.c
index da33d80..8b5201b 100644
--- a/drivers/video/sis/init301.c
+++ b/drivers/video/sis/init301.c
@@ -5848,7 +5848,7 @@ SiS_SetGroup1_LVDS(struct SiS_Private *SiS_Pr, unsigned short ModeNo, unsigned s
 #ifdef SIS315H
   if(SiS_Pr->ChipType >= SIS_315H) {
      if(SiS_Pr->SiS_VBInfo & SetCRT2ToLCDA) {
-        if((islvds) || (SiS_Pr->SiS_VBInfo & VB_SISLVDS)) {
+	 if ((islvds) || (SiS_Pr->SiS_VBType & VB_SISLVDS)) {
            SiS_SetReg(SiS_Pr->SiS_Part1Port,0x1e,0x20);
 	}
      } else {
