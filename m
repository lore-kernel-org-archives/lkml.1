Return-Path: <linux-kernel-owner+w=401wt.eu-S932852AbYBMVfv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932852AbYBMVfv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 16:35:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763476AbYBMVaQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 16:30:16 -0500
Received: from smtp4.pp.htv.fi ([213.243.153.38]:50784 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754142AbYBMVaN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 16:30:13 -0500
Date: Wed, 13 Feb 2008 23:29:57 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Zhang Rui <rui.zhang@intel.com>, Len Brown <len.brown@intel.com>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [2.6 patch] make acpi_chain_head static
Message-ID: <20080213212957.GQ3383@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

acpi_chain_head can become static.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
cc3a04eb55aeb07d17bb7701b2227079b752508f diff --git a/drivers/acpi/event.c b/drivers/acpi/event.c
index 5479dc0..abec1ca 100644
--- a/drivers/acpi/event.c
+++ b/drivers/acpi/event.c
@@ -110,7 +110,7 @@ static const struct file_operations acpi_system_event_ops = {
 #endif	/* CONFIG_ACPI_PROC_EVENT */
 
 /* ACPI notifier chain */
-BLOCKING_NOTIFIER_HEAD(acpi_chain_head);
+static BLOCKING_NOTIFIER_HEAD(acpi_chain_head);
 
 int acpi_notifier_call_chain(struct acpi_device *dev, u32 type, u32 data)
 {

