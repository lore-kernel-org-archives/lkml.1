Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935127Ab0CMBMa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 20:12:30 -0500
Received: from kroah.org ([198.145.64.141]:46659 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935342Ab0CMAaq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 19:30:46 -0500
X-Mailbox-Line: From gregkh@kvm.kroah.org Fri Mar 12 16:27:06 2010
Message-Id: <20100313002706.735972773@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Fri, 12 Mar 2010 16:25:50 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Len Brown <len.brown@intel.com>
Subject: [017/145] ACPI: remove Asus P2B-DS from acpi=ht blacklist
In-Reply-To: <20100313002816.GA18903@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let me know.

----------------
From: Len Brown <len.brown@intel.com>

commit 97c169d39b6846a564dc8d883832e7fef9bdb77d upstream.

We realized when we broke acpi=ht
http://bugzilla.kernel.org/show_bug.cgi?id=14886
that acpi=ht is not needed on this box
and folks have been using acpi=force on it anyway.

Signed-off-by: Len Brown <len.brown@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kernel/acpi/boot.c |    8 --------
 1 file changed, 8 deletions(-)

--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -1348,14 +1348,6 @@ static struct dmi_system_id __initdata a
 	 },
 	{
 	 .callback = force_acpi_ht,
-	 .ident = "ASUS P2B-DS",
-	 .matches = {
-		     DMI_MATCH(DMI_BOARD_VENDOR, "ASUSTeK Computer INC."),
-		     DMI_MATCH(DMI_BOARD_NAME, "P2B-DS"),
-		     },
-	 },
-	{
-	 .callback = force_acpi_ht,
 	 .ident = "ASUS CUR-DLS",
 	 .matches = {
 		     DMI_MATCH(DMI_BOARD_VENDOR, "ASUSTeK Computer INC."),


