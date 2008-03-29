Return-Path: <linux-kernel-owner+w=401wt.eu-S1760854AbYC2DMg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760854AbYC2DMg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 23:12:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759484AbYC2DKK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 23:10:10 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:50180 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759236AbYC2DKJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 23:10:09 -0400
To: torvalds@linux-foundation.org
Subject: [PATCH] 8250_pci: duplicate initializer in array ([pbn_b0_8_115200])
Cc: alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org
Message-Id: <E1JfRSK-0002w9-Ky@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Sat, 29 Mar 2008 03:10:08 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 drivers/serial/8250_pci.c |    7 -------
 1 files changed, 0 insertions(+), 7 deletions(-)

diff --git a/drivers/serial/8250_pci.c b/drivers/serial/8250_pci.c
index a8bec49..f97224c 100644
--- a/drivers/serial/8250_pci.c
+++ b/drivers/serial/8250_pci.c
@@ -1214,13 +1214,6 @@ static struct pciserial_board pci_boards[] __devinitdata = {
 		.base_baud	= 115200,
 		.uart_offset	= 8,
 	},
-	[pbn_b0_8_115200] = {
-		.flags		= FL_BASE0,
-		.num_ports	= 8,
-		.base_baud	= 115200,
-		.uart_offset	= 8,
-	},
-
 	[pbn_b0_1_921600] = {
 		.flags		= FL_BASE0,
 		.num_ports	= 1,
-- 
1.5.3.GIT


