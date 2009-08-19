Return-Path: <linux-kernel-owner+w=401wt.eu-S1752842AbZHSOUc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752842AbZHSOUc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 10:20:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752737AbZHSOUb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 10:20:31 -0400
Received: from fallback-out2.mxes.net ([216.86.168.191]:23712 "EHLO
	fallback-in2.mxes.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752675AbZHSOUb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 10:20:31 -0400
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
To: mjg@redhat.com
Cc: marcel@holtmann.org, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
       Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Subject: [PATCH 4/5] dell-laptop: add __init to init functions
Date: Wed, 19 Aug 2009 15:06:50 +0100
Message-Id: <1250690811-21203-4-git-send-email-alan-jenkins@tuffmail.co.uk>
X-Mailer: git-send-email 1.6.3.2
In-Reply-To: <4A8C0623.8030808@tuffmail.co.uk>
References: <4A8C0623.8030808@tuffmail.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
---
 drivers/platform/x86/dell-laptop.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/platform/x86/dell-laptop.c b/drivers/platform/x86/dell-laptop.c
index a13a9f7..250c4b1 100644
--- a/drivers/platform/x86/dell-laptop.c
+++ b/drivers/platform/x86/dell-laptop.c
@@ -82,7 +82,7 @@ static const struct dmi_system_id __initdata dell_device_table[] = {
 	{ }
 };
 
-static void parse_da_table(const struct dmi_header *dm)
+static void __init parse_da_table(const struct dmi_header *dm)
 {
 	/* Final token is a terminator, so we don't want to copy it */
 	int tokens = (dm->length-11)/sizeof(struct calling_interface_token)-1;
@@ -111,7 +111,7 @@ static void parse_da_table(const struct dmi_header *dm)
 	da_num_tokens += tokens;
 }
 
-static void find_tokens(const struct dmi_header *dm, void *dummy)
+static void __init find_tokens(const struct dmi_header *dm, void *dummy)
 {
 	switch (dm->type) {
 	case 0xd4: /* Indexed IO */
@@ -214,7 +214,7 @@ static const struct rfkill_ops dell_rfkill_ops = {
 	.query = dell_rfkill_query,
 };
 
-static int dell_setup_rfkill(void)
+static int __init dell_setup_rfkill(void)
 {
 	struct calling_interface_buffer buffer;
 	int status;
-- 
1.6.3.2

