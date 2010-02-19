Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755107Ab0BSRSP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 12:18:15 -0500
Received: from kroah.org ([198.145.64.141]:57374 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754113Ab0BSRAN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 12:00:13 -0500
X-Mailbox-Line: From gregkh@kvm.kroah.org Fri Feb 19 08:32:34 2010
Message-Id: <20100219163233.812220225@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Fri, 19 Feb 2010 08:29:08 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Zhao Yakui <yakui.zhao@intel.com>, Eric Anholt <eric@anholt.net>
Subject: [15/93] drm/i915: Fix the incorrect DMI string for Samsung SX20S laptop
In-Reply-To: <20100219165717.GA15002@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Zhao Yakui <yakui.zhao@intel.com>

commit f034b12dbb5749b11e9390e15e93ffa87ece8038 upstream.

Signed-off-by: Zhao Yakui <yakui.zhao@intel.com>
Reported-by: Philipp Kohlbecher <xt28@gmx.de>
Signed-off-by: Eric Anholt <eric@anholt.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/i915/intel_lvds.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/i915/intel_lvds.c
+++ b/drivers/gpu/drm/i915/intel_lvds.c
@@ -611,7 +611,7 @@ static const struct dmi_system_id bad_li
 	{
 		.ident = "Samsung SX20S",
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Phoenix Technologies LTD"),
+			DMI_MATCH(DMI_SYS_VENDOR, "Samsung Electronics"),
 			DMI_MATCH(DMI_BOARD_NAME, "SX20S"),
 		},
 	},


