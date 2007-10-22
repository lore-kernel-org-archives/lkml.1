Return-Path: <linux-kernel-owner+w=401wt.eu-S1753872AbXJVOrU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753872AbXJVOrU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 10:47:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752206AbXJVOrM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 10:47:12 -0400
Received: from hpsmtp-eml19.KPNXCHANGE.COM ([213.75.38.84]:9094 "EHLO
	hpsmtp-eml19.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751937AbXJVOrL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 10:47:11 -0400
From: Frans Pop <elendil@planet.nl>
To: linux-acpi@vger.kernel.org
Subject: [PATCH] Remove double mention of Support for ACPI option
Date: Mon, 22 Oct 2007 16:47:07 +0200
User-Agent: KMail/1.9.7
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_rfLHHUrjGI1i44L"
Message-Id: <200710221647.07911.elendil@planet.nl>
X-OriginalArrivalTime: 22 Oct 2007 14:47:08.0212 (UTC) FILETIME=[6B9F1740:01C814BA]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_rfLHHUrjGI1i44L
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

From: Frans Pop <elendil@planet.nl>

Current description for CONFIG_ACPI includes the word "Support" twice.
One effect of this is that in menuconfig the "--->" that indicates the 
presence of sub-options will not show up unless you have a very wide 
console.

Signed-off-by: Frans Pop <elendil@planet.nl>
---

--Boundary-00=_rfLHHUrjGI1i44L
Content-Type: text/x-diff;
  charset="us-ascii";
  name="remove_double_mention_of_support.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
	filename="remove_double_mention_of_support.patch"

diff --git a/drivers/acpi/Kconfig b/drivers/acpi/Kconfig
index 5d0e26a..92422a3 100644
--- a/drivers/acpi/Kconfig
+++ b/drivers/acpi/Kconfig
@@ -3,7 +3,7 @@
 #
 
 menuconfig ACPI
-	bool "ACPI Support (Advanced Configuration and Power Interface) Support"
+	bool "ACPI (Advanced Configuration and Power Interface) Support"
 	depends on !X86_NUMAQ
 	depends on !X86_VISWS
 	depends on !IA64_HP_SIM

--Boundary-00=_rfLHHUrjGI1i44L--
