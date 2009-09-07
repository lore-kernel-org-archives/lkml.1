Return-Path: <linux-kernel-owner+w=401wt.eu-S1758766AbZIGCXb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758766AbZIGCXb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Sep 2009 22:23:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758748AbZIGCXa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Sep 2009 22:23:30 -0400
Received: from mail.gmx.net ([213.165.64.20]:47806 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1758591AbZIGCX2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Sep 2009 22:23:28 -0400
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX18h8+4ztJshs43kaIGkcOjPVRsS5odLWGQ0Qt44eU
	R3N6oUAeuohU+I
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
To: linux-fbdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       JosephChan@via.com.tw, ScottFang@viatech.com.cn,
       Harald Welte <laforge@gnumonks.org>,
       Harald Welte <HaraldWelte@viatech.com>,
       Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Subject: [PATCH 2/3] viafb: remove unused structure member
Date: Mon,  7 Sep 2009 02:24:43 +0000
Message-Id: <1252290284-3668-2-git-send-email-FlorianSchandinat@gmx.de>
X-Mailer: git-send-email 1.6.3.2
In-Reply-To: <1252290284-3668-1-git-send-email-FlorianSchandinat@gmx.de>
References: <1252290284-3668-1-git-send-email-FlorianSchandinat@gmx.de>
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.63
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Harald Welte <laforge@gnumonks.org>

viafb: remove unused structure member

This patch removes a structure member 'on_slot' in the chip_info structure
which is completely unused.

Signed-off-by: Harald Welte <HaraldWelte@viatech.com>
Signed-off-by: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
---
 drivers/video/via/chip.h |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/video/via/chip.h b/drivers/video/via/chip.h
index dde95ed..7f95967 100644
--- a/drivers/video/via/chip.h
+++ b/drivers/video/via/chip.h
@@ -122,7 +122,6 @@ struct lvds_chip_information {
 struct chip_information {
 	int gfx_chip_name;
 	int gfx_chip_revision;
-	int chip_on_slot;
 	struct tmds_chip_information tmds_chip_info;
 	struct lvds_chip_information lvds_chip_info;
 	struct lvds_chip_information lvds_chip_info2;
-- 
1.6.3.2

