Return-Path: <linux-kernel-owner+w=401wt.eu-S1752443AbZHJSel@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752443AbZHJSel (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 14:34:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752358AbZHJSek
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 14:34:40 -0400
Received: from qw-out-2122.google.com ([74.125.92.24]:25048 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752347AbZHJSek (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 14:34:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=bF6q1wlADx2SWoNeovbZycphbpmkM1VIH7hPZxrnbRdfgQ5rq7cgUGmnIxb60fVtjY
         fztyYtVLbElQsybYPkOg4J837nle+H0gF3q4o0ISdUUOnIDD8NTW/d7fGz9NZEIndZi9
         YTSiM3PAp+Bh/y2BKX90Izd9HqelQ87f0j4lw=
MIME-Version: 1.0
Date: Tue, 11 Aug 2009 03:34:40 +0900
Message-ID: <30046e3b0908101134p6487ddbftd8776e4ddef204be@mail.gmail.com>
Subject: [PATCH] x86: quirk on every 5 series of MacBook/Pro
From: Shunichi Fuji <palglowr@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reboot does not work on my MacBook Pro 13 inch (MacBookPro5,5) too.
Does It seem all unibody MacBook and MacBookPro require handling with
reboot, i guess.

Following model/machine ID list shows unibody MacBook/Pro have the 5
series of model number.

[1] http://www.everymac.com/systems/by_capability/macs-by-machine-model-machine-id.html


Signed-off-by: Shunichi Fuji <palglowr@gmail.com>
---
 arch/x86/kernel/reboot.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
index 9eb8976..a06e8d1 100644
--- a/arch/x86/kernel/reboot.c
+++ b/arch/x86/kernel/reboot.c
@@ -418,20 +418,20 @@ static int __init set_pci_reboot(const struct
dmi_system_id *d)
 }

 static struct dmi_system_id __initdata pci_reboot_dmi_table[] = {
-	{	/* Handle problems with rebooting on Apple MacBook5,2 */
+	{	/* Handle problems with rebooting on Apple MacBook5 */
 		.callback = set_pci_reboot,
-		.ident = "Apple MacBook",
+		.ident = "Apple MacBook5",
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "Apple Inc."),
-			DMI_MATCH(DMI_PRODUCT_NAME, "MacBook5,2"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "MacBook5"),
 		},
 	},
-	{	/* Handle problems with rebooting on Apple MacBookPro5,1 */
+	{	/* Handle problems with rebooting on Apple MacBookPro5 */
 		.callback = set_pci_reboot,
-		.ident = "Apple MacBookPro5,1",
+		.ident = "Apple MacBookPro5",
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "Apple Inc."),
-			DMI_MATCH(DMI_PRODUCT_NAME, "MacBookPro5,1"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "MacBookPro5"),
 		},
 	},
 	{ }
-- 
1.6.4
