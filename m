Return-Path: <linux-kernel-owner+w=401wt.eu-S1752414AbZCZUp3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752414AbZCZUp3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 16:45:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753881AbZCZUpI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 16:45:08 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:35180 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755432AbZCZUpH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 16:45:07 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH] x86: DMI match for the Dell DXP061 as it needs BIOS reboot
To: linux-kernel@vger.kernel.org, mingo@redhat.com
Date: Thu, 26 Mar 2009 20:45:28 +0000
Message-ID: <20090326204524.4454.8776.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Closes #12901

Signed-off-by: Alan Cox <alan@lxorguk.ukuu.org.uk>
---

 arch/x86/kernel/reboot.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)


diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
index 4526b3a..5336fc5 100644
--- a/arch/x86/kernel/reboot.c
+++ b/arch/x86/kernel/reboot.c
@@ -225,6 +225,14 @@ static struct dmi_system_id __initdata reboot_dmi_table[] = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "Dell XPS710"),
 		},
 	},
+	{	/* Handle problems with rebooting on Dell DXP061 */
+		.callback = set_bios_reboot,
+		.ident = "Dell DXP061",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Dell DXP061"),
+		},
+	},
 	{ }
 };
 

