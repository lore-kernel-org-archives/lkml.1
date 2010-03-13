Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936285Ab0CMBLr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 20:11:47 -0500
Received: from kroah.org ([198.145.64.141]:46677 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935222Ab0CMAat (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 19:30:49 -0500
X-Mailbox-Line: From gregkh@kvm.kroah.org Fri Mar 12 16:27:07 2010
Message-Id: <20100313002706.995198054@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Fri, 12 Mar 2010 16:25:53 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Zhang Rui <rui.zhang@intel.com>, Len Brown <len.brown@intel.com>
Subject: [020/145] ACPI, i915: blacklist Clevo M5x0N bad_lid state
In-Reply-To: <20100313002816.GA18903@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let me know.

----------------
From: Zhang Rui <rui.zhang@intel.com>

commit 1379d2fef0ec07c7027a5e89036025ce761470c8 upstream.

Wrong Lid state reported.
Need to blacklist this machine for LVDS detection.

Signed-off-by: Zhang Rui <rui.zhang@intel.com>
Signed-off-by: Len Brown <len.brown@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/i915/intel_lvds.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/gpu/drm/i915/intel_lvds.c
+++ b/drivers/gpu/drm/i915/intel_lvds.c
@@ -629,6 +629,13 @@ static const struct dmi_system_id bad_li
 			DMI_MATCH(DMI_PRODUCT_NAME, "PC-81005"),
 		},
 	},
+	{
+		.ident = "Clevo M5x0N",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "CLEVO Co."),
+			DMI_MATCH(DMI_BOARD_NAME, "M5x0N"),
+		},
+	},
 	{ }
 };
 


