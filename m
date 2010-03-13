Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935579Ab0CMAcz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 19:32:55 -0500
Received: from kroah.org ([198.145.64.141]:46885 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935411Ab0CMAb2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 19:31:28 -0500
X-Mailbox-Line: From gregkh@kvm.kroah.org Fri Mar 12 16:27:09 2010
Message-Id: <20100313002709.772868249@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Fri, 12 Mar 2010 16:26:25 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Zhenyu Wang <zhenyuw@linux.intel.com>, Eric Anholt <eric@anholt.net>
Subject: [052/145] drm/i915: disable TV hotplug status check
In-Reply-To: <20100313002816.GA18903@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let me know.

----------------
From: Zhenyu Wang <zhenyuw@linux.intel.com>

commit 8fcc501831aa5b37a4a5a8cd9dc965be3cacc599 upstream.

As we removed TV hotplug, don't check its status ever.

Reviewed-by: Adam Jackson <ajax@redhat.com>
Signed-off-by: Zhenyu Wang <zhenyuw@linux.intel.com>
Signed-off-by: Eric Anholt <eric@anholt.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/i915/intel_tv.c |    2 --
 1 file changed, 2 deletions(-)

--- a/drivers/gpu/drm/i915/intel_tv.c
+++ b/drivers/gpu/drm/i915/intel_tv.c
@@ -1801,8 +1801,6 @@ intel_tv_init(struct drm_device *dev)
 	drm_connector_attach_property(connector,
 				   dev->mode_config.tv_bottom_margin_property,
 				   tv_priv->margin[TV_MARGIN_BOTTOM]);
-
-	dev_priv->hotplug_supported_mask |= TV_HOTPLUG_INT_STATUS;
 out:
 	drm_sysfs_connector_add(connector);
 }


