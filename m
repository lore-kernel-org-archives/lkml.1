Return-Path: <linux-kernel-owner+w=401wt.eu-S1759443AbYKVRfu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759443AbYKVRfu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2008 12:35:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759272AbYKVReg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Nov 2008 12:34:36 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:55357 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759269AbYKVRef (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2008 12:34:35 -0500
To: torvalds@linux-foundation.org
Subject: [PATCH 8/32] icside section warnings
Cc: linux-kernel@vger.kernel.org, rmk@arm.linux.org.uk
Message-Id: <E1L3wNO-0006Nv-Iw@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Sat, 22 Nov 2008 17:34:34 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


icside_register_v[56] is called from (__devinit) icside_probe

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 drivers/ide/icside.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/ide/icside.c b/drivers/ide/icside.c
--- a/drivers/ide/icside.c
+++ b/drivers/ide/icside.c
@@ -419,7 +419,7 @@ static void icside_setup_ports(hw_regs_t *hw, void __iomem *base,
 	hw->chipset = ide_acorn;
 }
 
-static int __init
+static int __devinit
 icside_register_v5(struct icside_state *state, struct expansion_card *ec)
 {
 	void __iomem *base;
@@ -473,7 +473,7 @@ static const struct ide_port_info icside_v6_port_info __initdata = {
 	.swdma_mask		= ATA_SWDMA2,
 };
 
-static int __init
+static int __devinit
 icside_register_v6(struct icside_state *state, struct expansion_card *ec)
 {
 	void __iomem *ioc_base, *easi_base;
