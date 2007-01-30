Return-Path: <linux-kernel-owner+w=401wt.eu-S1752637AbXA3BLo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752637AbXA3BLo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 20:11:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752636AbXA3BLo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 20:11:44 -0500
Received: from mailout.stusta.mhn.de ([141.84.69.5]:47379 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752607AbXA3BLn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 20:11:43 -0500
Date: Tue, 30 Jan 2007 02:11:49 +0100
From: Adrian Bunk <bunk@stusta.de>
To: lenb@kernel.org
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [2.6 patch] drivers/acpi/hotkey.c: make 2 structs static
Message-ID: <20070130011149.GB3754@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes two needlessly global structs static.

Signed-off-by: Adrian Bunk <bunk@stusta.de>

--- linux-2.6.20-rc6-mm1/drivers/acpi/hotkey.c.old	2007-01-28 23:31:03.000000000 +0100
+++ linux-2.6.20-rc6-mm1/drivers/acpi/hotkey.c	2007-01-28 23:31:23.000000000 +0100
@@ -234,8 +234,8 @@
 	.release = single_release,
 };
 
-struct acpi_hotkey_list global_hotkey_list;	/* link all ev or pl hotkey  */
-struct list_head hotkey_entries;	/* head of the list of hotkey_list */
+static struct acpi_hotkey_list global_hotkey_list;	/* link all ev or pl hotkey  */
+static struct list_head hotkey_entries;	/* head of the list of hotkey_list */
 
 static int hotkey_info_seq_show(struct seq_file *seq, void *offset)
 {

