Return-Path: <linux-kernel-owner+w=401wt.eu-S1755935AbZHMT73@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755935AbZHMT73 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 15:59:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755906AbZHMT70
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 15:59:26 -0400
Received: from kroah.org ([198.145.64.141]:41682 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755903AbZHMT7X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 15:59:23 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu Aug 13 12:51:27 2009
Message-Id: <20090813195127.056965881@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 13 Aug 2009 12:49:52 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Michael Cousin <mika.cousin@gmail.com>, Eric Anholt <eric@anholt.net>
Subject: [patch 17/74] drm/i915: Skip lvds with Aopen i945GTt-VFA
References: <20090813194935.985368088@mini.kroah.org>
Content-Disposition: inline; filename=0004-drm-i915-Skip-lvds-with-Aopen-i945GTt-VFA.patch
In-Reply-To: <20090813195705.GA22393@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Michael Cousin <mika.cousin@gmail.com

(cherry picked from commit fa0864b26b4bfa1dd4bb78eeffbc1f398cb56425)

Signed-off-by: Michael Cousin <mika.cousin@gmail.com>
Signed-off-by: Eric Anholt <eric@anholt.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/gpu/drm/i915/intel_lvds.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/gpu/drm/i915/intel_lvds.c
+++ b/drivers/gpu/drm/i915/intel_lvds.c
@@ -428,6 +428,13 @@ static const struct dmi_system_id intel_
 			DMI_MATCH(DMI_PRODUCT_NAME, "i965GMx-IF"),
 		},
 	},
+	{
+		.callback = intel_no_lvds_dmi_callback,
+		.ident = "Aopen i945GTt-VFA",
+		.matches = {
+			DMI_MATCH(DMI_PRODUCT_VERSION, "AO00001JW"),
+		},
+	},
 
 	{ }	/* terminating entry */
 };


