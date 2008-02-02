Return-Path: <linux-kernel-owner+w=401wt.eu-S934322AbYBBUH4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934322AbYBBUH4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2008 15:07:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761223AbYBBUHs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Feb 2008 15:07:48 -0500
Received: from smtp-out1.tiscali.nl ([195.241.79.176]:40939 "EHLO
	smtp-out1.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760083AbYBBUHs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2008 15:07:48 -0500
Message-ID: <47A4CD8A.7060604@tiscali.nl>
Date: Sat, 02 Feb 2008 21:07:38 +0100
From: Roel Kluin <12o3l@tiscali.nl>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: corentincj@iksaif.net, acpi4asus-user@lists.sourceforge.net
CC: lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH] [drivers/misc/asus-laptop.c] add parentheses
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

'!' has a higher priority than '&': bitanding has no effect.

Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
---
diff --git a/drivers/misc/asus-laptop.c b/drivers/misc/asus-laptop.c
index 7dce318..65c67d1 100644
--- a/drivers/misc/asus-laptop.c
+++ b/drivers/misc/asus-laptop.c
@@ -322,7 +322,7 @@ static void write_status(acpi_handle handle, int out, int mask)
 
 	switch (mask) {
 	case MLED_ON:
-		out = !out & 0x1;
+		out = !(out & 0x1);
 		break;
 	case GLED_ON:
 		out = (out & 0x1) + 1;

