Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755811Ab0BSRR5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 12:17:57 -0500
Received: from kroah.org ([198.145.64.141]:57396 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754385Ab0BSRAO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 12:00:14 -0500
X-Mailbox-Line: From gregkh@kvm.kroah.org Fri Feb 19 08:32:34 2010
Message-Id: <20100219163234.167515488@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Fri, 19 Feb 2010 08:29:09 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Zhao Yakui <yakui.zhao@intel.com>, Eric Anholt <eric@anholt.net>
Subject: [16/93] drm/i915: Add MALATA PC-81005 to ACPI LID quirk list
In-Reply-To: <20100219165717.GA15002@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Zhao Yakui <yakui.zhao@intel.com>

commit a3cb5195f6db58dbebd8a31b877ddce082c9b63d upstream.

The MALATA PC-81005 laptop always reports that the LID status is closed and we
can't use it reliabily for LVDS detection. So add this box into the quirk list.

https://bugs.freedesktop.org/show_bug.cgi?id=25523

Signed-off-by: Zhao Yakui <yakui.zhao@intel.com>
Review-by: Jesse Barnes <jbarnes@virtuousgeek.org>
Tested-by: Hector <hector1987@gmail.com>
Signed-off-by: Eric Anholt <eric@anholt.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/i915/intel_lvds.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/gpu/drm/i915/intel_lvds.c
+++ b/drivers/gpu/drm/i915/intel_lvds.c
@@ -622,6 +622,13 @@ static const struct dmi_system_id bad_li
 			DMI_MATCH(DMI_PRODUCT_NAME, "Aspire one"),
 		},
 	},
+	{
+		.ident = "PC-81005",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "MALATA"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "PC-81005"),
+		},
+	},
 	{ }
 };
 


