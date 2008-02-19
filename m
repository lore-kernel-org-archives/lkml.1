Return-Path: <linux-kernel-owner+w=401wt.eu-S1756874AbYBSGdZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756874AbYBSGdZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 01:33:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753768AbYBSGdQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 01:33:16 -0500
Received: from qb-out-0506.google.com ([72.14.204.224]:50453 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753702AbYBSGdP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 01:33:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=JnXvYEdh1QH+jk5UY56dDBOWnz7M89EmYnCivASJnkHUWB3C7rsGD4TM2p8yk/ZI/d1bccL1I/4/srLAedSvw9NPp26fRibdZTd3gAhsS+26QkD6FDnN4gluZYtUiAIf5EPfT3MEbl3n0EGJHvGn49LuMOp90ut+xwowLc7xP7M=
Subject: [PATCH] serial: remove double initializer
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       "Krauth.Julien" <Krauth.Julien@addi-data.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 18 Feb 2008 22:33:22 -0800
Message-Id: <1203402802.7766.3.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit:
02c9b5cf9acd8a85313b892dc5196ccf133d4884 serial: add ADDI-DATA GmbH Communication cardsin8250_pci.c and pci_ids.h

Added a second initializer, perhaps sopmething else was intended?

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
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
1.5.4.2.200.g99e75



