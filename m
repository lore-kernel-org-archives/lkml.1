Return-Path: <linux-kernel-owner+w=401wt.eu-S932791AbZKFWdh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932791AbZKFWdh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 17:33:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932772AbZKFWdg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 17:33:36 -0500
Received: from kroah.org ([198.145.64.141]:56925 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932484AbZKFWXL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 17:23:11 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Nov  6 14:15:47 2009
Message-Id: <20091106221546.888116969@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 06 Nov 2009 14:14:57 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Fabian Henze <hoacha@quantentunnel.de>,
       Zhenyu Wang <zhenyuw@linux.intel.com>, Eric Anholt <eric@anholt.net>
Subject: [59/99] drm/i915: add B43 chipset support
References: <20091106221358.309857998@mini.kroah.org>
Content-Disposition: inline; filename=drm-i915-add-b43-chipset-support.patch
In-Reply-To: <20091106221850.GA15408@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Fabian Henze <hoacha@quantentunnel.de>

commit 7839c5d5519b6d9e2ccf3cdbf1c39e3817ad0835 upstream.

Signed-off-by: Fabian Henze <hoacha@quantentunnel.de>
Signed-off-by: Zhenyu Wang <zhenyuw@linux.intel.com>
Signed-off-by: Eric Anholt <eric@anholt.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/i915/i915_drv.h |    2 ++
 include/drm/drm_pciids.h        |    1 +
 2 files changed, 3 insertions(+)

--- a/drivers/gpu/drm/i915/i915_drv.h
+++ b/drivers/gpu/drm/i915/i915_drv.h
@@ -854,6 +854,7 @@ extern int i915_wait_ring(struct drm_dev
 		       (dev)->pci_device == 0x2E12 || \
 		       (dev)->pci_device == 0x2E22 || \
 		       (dev)->pci_device == 0x2E32 || \
+		       (dev)->pci_device == 0x2E42 || \
 		       (dev)->pci_device == 0x0042 || \
 		       (dev)->pci_device == 0x0046)
 
@@ -866,6 +867,7 @@ extern int i915_wait_ring(struct drm_dev
 		     (dev)->pci_device == 0x2E12 || \
 		     (dev)->pci_device == 0x2E22 || \
 		     (dev)->pci_device == 0x2E32 || \
+		     (dev)->pci_device == 0x2E42 || \
 		     IS_GM45(dev))
 
 #define IS_IGDG(dev) ((dev)->pci_device == 0xa001)
--- a/include/drm/drm_pciids.h
+++ b/include/drm/drm_pciids.h
@@ -552,6 +552,7 @@
 	{0x8086, 0x2e12, PCI_ANY_ID, PCI_ANY_ID, PCI_CLASS_DISPLAY_VGA << 8, 0xffff00, 0}, \
 	{0x8086, 0x2e22, PCI_ANY_ID, PCI_ANY_ID, PCI_CLASS_DISPLAY_VGA << 8, 0xffff00, 0}, \
 	{0x8086, 0x2e32, PCI_ANY_ID, PCI_ANY_ID, PCI_CLASS_DISPLAY_VGA << 8, 0xffff00, 0}, \
+	{0x8086, 0x2e42, PCI_ANY_ID, PCI_ANY_ID, PCI_CLASS_DISPLAY_VGA << 8, 0xffff00, 0}, \
 	{0x8086, 0xa001, PCI_ANY_ID, PCI_ANY_ID, PCI_CLASS_DISPLAY_VGA << 8, 0xffff00, 0}, \
 	{0x8086, 0xa011, PCI_ANY_ID, PCI_ANY_ID, PCI_CLASS_DISPLAY_VGA << 8, 0xffff00, 0}, \
 	{0x8086, 0x35e8, PCI_ANY_ID, PCI_ANY_ID, PCI_CLASS_DISPLAY_VGA << 8, 0xffff00, 0}, \


