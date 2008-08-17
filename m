Return-Path: <linux-kernel-owner+w=401wt.eu-S1755274AbYHQUX6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755274AbYHQUX6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2008 16:23:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751324AbYHQUXv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Aug 2008 16:23:51 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:56570 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751291AbYHQUXu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2008 16:23:50 -0400
Date: Sun, 17 Aug 2008 23:21:37 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Matthew Garrett <mjg@redhat.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: [2.6 patch] make hp_wmi_notify() static
Message-ID: <20080817202137.GG24619@cs181140183.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes the needlessly global hp_wmi_notify() static.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
627792794e9990e58aee1f523ce9d4c9cb81c402 
diff --git a/drivers/misc/hp-wmi.c b/drivers/misc/hp-wmi.c
index 1dbcbcb..37ecb3b 100644
--- a/drivers/misc/hp-wmi.c
+++ b/drivers/misc/hp-wmi.c
@@ -306,7 +306,7 @@ static int hp_wmi_setkeycode(struct input_dev *dev, int scancode, int keycode)
 	return -EINVAL;
 }
 
-void hp_wmi_notify(u32 value, void *context)
+static void hp_wmi_notify(u32 value, void *context)
 {
 	struct acpi_buffer response = { ACPI_ALLOCATE_BUFFER, NULL };
 	static struct key_entry *key;

