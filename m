Return-Path: <linux-kernel-owner+w=401wt.eu-S1755218AbZC1Fqh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755218AbZC1Fqh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Mar 2009 01:46:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751753AbZC1Fq0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Mar 2009 01:46:26 -0400
Received: from vms173003pub.verizon.net ([206.46.173.3]:13916 "EHLO
	vms173003pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751392AbZC1FqZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Mar 2009 01:46:25 -0400
MIME-version: 1.0
Content-type: multipart/mixed; boundary="Boundary_(ID_HnZfWCUzDLINkj7Hz/yfYA)"
Date: Sat, 28 Mar 2009 01:46:14 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@localhost.localdomain
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: linux-acpi@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Eric Anholt <eric@anholt.net>
Subject: Re: [PATCH v2] acpi: Populate DIDL before registering ACPI video
 device on Intel
In-reply-to: <alpine.LFD.2.00.0903272212390.26419@localhost.localdomain>
Message-id: <alpine.LFD.2.00.0903280143510.26419@localhost.localdomain>
References: <20090311215517.GA32400@srcf.ucam.org>
 <20090319213539.GA24898@srcf.ucam.org>
 <alpine.LFD.2.00.0903272212390.26419@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--Boundary_(ID_HnZfWCUzDLINkj7Hz/yfYA)
Content-type: TEXT/PLAIN; charset=ISO-8859-7
Content-transfer-encoding: 8BIT

From: Len Brown <len.brown@intel.com>
Subject: [PATCH] ACPI: fix CONFIG_ACPI=n build

drivers/gpu/drm/i915/i915_drv.c:102: error: too many arguments to
function ¡intel_opregion_init¢

Signed-off-by: Len Brown <len.brown@intel.com>
---
 drivers/gpu/drm/i915/i915_drv.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_drv.h b/drivers/gpu/drm/i915/i915_drv.h
index 1679a95..b9a92c2 100644
--- a/drivers/gpu/drm/i915/i915_drv.h
+++ b/drivers/gpu/drm/i915/i915_drv.h
@@ -664,7 +664,7 @@ extern void intel_opregion_free(struct drm_device *dev);
 extern void opregion_asle_intr(struct drm_device *dev);
 extern void opregion_enable_asle(struct drm_device *dev);
 #else
-static inline int intel_opregion_init(struct drm_device *dev) { return 0; }
+static inline int intel_opregion_init(struct drm_device *dev, int resume) { return 0; }
 static inline void intel_opregion_free(struct drm_device *dev) { return; }
 static inline void opregion_asle_intr(struct drm_device *dev) { return; }
 static inline void opregion_enable_asle(struct drm_device *dev) { return; }
-- 
1.6.2.1.389.geed1

--Boundary_(ID_HnZfWCUzDLINkj7Hz/yfYA)--
