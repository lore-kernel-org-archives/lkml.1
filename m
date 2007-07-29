Return-Path: <linux-kernel-owner+w=401wt.eu-S1764579AbXG2O6p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764579AbXG2O6p (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2007 10:58:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763744AbXG2O5H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jul 2007 10:57:07 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:47757 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1763409AbXG2O5F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2007 10:57:05 -0400
Date: Sun, 29 Jul 2007 16:56:42 +0200
From: Adrian Bunk <bunk@stusta.de>
To: lenb@kernel.org
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [2.6 patch] make drivers/acpi/event.c:acpi_event_seqnum static
Message-ID: <20070729145642.GG16817@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes the needlessly global "acpi_event_seqnum" static.

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---
--- linux-2.6.23-rc1-mm1/drivers/acpi/event.c.old	2007-07-26 02:32:59.000000000 +0200
+++ linux-2.6.23-rc1-mm1/drivers/acpi/event.c	2007-07-26 02:33:07.000000000 +0200
@@ -108,7 +108,7 @@ static const struct file_operations acpi
 };
 
 #ifdef CONFIG_NET
-unsigned int acpi_event_seqnum;
+static unsigned int acpi_event_seqnum;
 struct acpi_genl_event {
 	acpi_device_class device_class;
 	char bus_id[15];

