Return-Path: <linux-kernel-owner+w=401wt.eu-S1754851AbXLEK12@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754851AbXLEK12 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 05:27:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753030AbXLEK1U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 05:27:20 -0500
Received: from nf-out-0910.google.com ([64.233.182.184]:15798 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752994AbXLEK1T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 05:27:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=received:from:to:cc:subject:date:message-id:x-mailer;
        b=oO/AsJnpXu52LKXB7sTrnGECc/XmJ3Z4mSZChpe18Q6FkxD7ZcP1BXu3VTHJLu9HY6CWBQpkR3D/4NhNTn+YhZKjP/aWYIUUMejDiIBuJSCdn9h2U9NEKlRLlGfoEu4zVggfcy1LnrC11avv5QQtc1vPZRuvHm0hNCo+Pqz1wac=
From: chripell@gmail.com
To: linux-kernel@vger.kernel.org
Cc: Christian Pellegrin <chripell@fsfe.org>
Subject: [PATCH] netmos 9855 fix
Date: Wed,  5 Dec 2007 11:27:27 +0100
Message-Id: <11968504473036-git-send-email-chripell@gmail.com>
X-Mailer: git-send-email 1.4.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixes wrong netmos 9855 serial port configuration.

Generated on  20071205  against v2.6.21

Signed-off-by: Christian Pellegrin <chripell@fsfe.org>
---
 drivers/parport/parport_serial.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/parport/parport_serial.c b/drivers/parport/parport_serial.c
index 78c0a26..5b04e78 100644
--- a/drivers/parport/parport_serial.c
+++ b/drivers/parport/parport_serial.c
@@ -77,7 +77,7 @@ static struct parport_pc_pci cards[] __devinitdata = {
 	/* titan_110l */		{ 1, { { 3, -1 }, } },
 	/* titan_210l */		{ 1, { { 3, -1 }, } },
 	/* netmos_9xx5_combo */		{ 1, { { 2, -1 }, }, netmos_parallel_init },
-	/* netmos_9855 */		{ 1, { { 0, -1 }, }, netmos_parallel_init },
+	/* netmos_9855 */		{ 1, { { 2, -1 }, }, netmos_parallel_init },
 	/* avlab_1s1p     */		{ 1, { { 1, 2}, } },
 	/* avlab_1s2p     */		{ 2, { { 1, 2}, { 3, 4 },} },
 	/* avlab_2s1p     */		{ 1, { { 2, 3}, } },
@@ -185,7 +185,7 @@ static struct pciserial_board pci_parport_serial_boards[] __devinitdata = {
 		.uart_offset	= 8,
 	},
 	[netmos_9855] = {
-		.flags		= FL_BASE2 | FL_BASE_BARS,
+		.flags		= FL_BASE4 | FL_BASE_BARS,
 		.num_ports	= 1,
 		.base_baud	= 115200,
 		.uart_offset	= 8,
--
1.4.4.4
