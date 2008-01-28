Return-Path: <linux-kernel-owner+w=401wt.eu-S1761487AbYA1WLZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761487AbYA1WLZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 17:11:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753788AbYA1WJu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 17:09:50 -0500
Received: from smtp4.pp.htv.fi ([213.243.153.38]:52195 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757419AbYA1WJs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 17:09:48 -0500
Date: Tue, 29 Jan 2008 00:10:15 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Len Brown <len.brown@intel.com>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [2.6 patch] ACPI: make struct osi_linux static
Message-ID: <20080128221015.GM8767@does.not.exist>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

struct osi_linux can become static.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
7cdce626bdef64e64e954839553f226ce9dd5b89 
diff --git a/drivers/acpi/osl.c b/drivers/acpi/osl.c
index db074f5..55dccac 100644
--- a/drivers/acpi/osl.c
+++ b/drivers/acpi/osl.c
@@ -120,7 +120,7 @@ static char osi_additional_string[OSI_STRING_LENGTH_MAX];
  */
 #define OSI_LINUX_ENABLE 0
 
-struct osi_linux {
+static struct osi_linux {
 	unsigned int	enable:1;
 	unsigned int	dmi:1;
 	unsigned int	cmdline:1;

