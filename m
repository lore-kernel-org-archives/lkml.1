Return-Path: <linux-kernel-owner+w=401wt.eu-S1761068AbZEFUi4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761068AbZEFUi4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 16:38:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760277AbZEFUin
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 16:38:43 -0400
Received: from kroah.org ([198.145.64.141]:33773 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759516AbZEFUim (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 16:38:42 -0400
X-Mailbox-Line: From greg@blue.kroah.org Wed May  6 13:31:28 2009
Message-Id: <20090506203127.849647537@blue.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 06 May 2009 13:30:11 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Zhenyu Wang <zhenyu.z.wang@intel.com>,
       Eric Anholt <eric@anholt.net>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 01/18] drm/i915: add support for G41 chipset
References: <20090506203010.615363711@blue.kroah.org>
Content-Disposition: inline; filename=drm-i915-add-support-for-g41-chipset.patch
In-Reply-To: <20090506203353.GA14624@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Zhenyu Wang <zhenyu.z.wang@intel.com>

commit 72021788678523047161e97b3dfed695e802a5fd upstream.

This had been delayed for some time due to failure to work on the one piece
of G41 hardware we had, and lack of success reports from anybody else.
Current hardware appears to be OK.

Signed-off-by: Zhenyu Wang <zhenyu.z.wang@intel.com>
[anholt: hand-applied due to conflicts with IGD patches]
Signed-off-by: Eric Anholt <eric@anholt.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/i915/i915_drv.h |    6 ++++--
 include/drm/drm_pciids.h        |    1 +
 2 files changed, 5 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/i915/i915_drv.h
+++ b/drivers/gpu/drm/i915/i915_drv.h
@@ -1115,7 +1115,8 @@ extern int i915_wait_ring(struct drm_dev
 		       (dev)->pci_device == 0x2A42 || \
 		       (dev)->pci_device == 0x2E02 || \
 		       (dev)->pci_device == 0x2E12 || \
-		       (dev)->pci_device == 0x2E22)
+		       (dev)->pci_device == 0x2E22 || \
+		       (dev)->pci_device == 0x2E32)
 
 #define IS_I965GM(dev) ((dev)->pci_device == 0x2A02)
 
@@ -1123,7 +1124,8 @@ extern int i915_wait_ring(struct drm_dev
 
 #define IS_G4X(dev) ((dev)->pci_device == 0x2E02 || \
 		     (dev)->pci_device == 0x2E12 || \
-		     (dev)->pci_device == 0x2E22)
+		     (dev)->pci_device == 0x2E22 || \
+		     (dev)->pci_device == 0x2E32)
 
 #define IS_G33(dev)    ((dev)->pci_device == 0x29C2 ||	\
 			(dev)->pci_device == 0x29B2 ||	\
--- a/include/drm/drm_pciids.h
+++ b/include/drm/drm_pciids.h
@@ -412,4 +412,5 @@
 	{0x8086, 0x2e02, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0}, \
 	{0x8086, 0x2e12, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0}, \
 	{0x8086, 0x2e22, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0}, \
+	{0x8086, 0x2e32, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0}, \
 	{0, 0, 0}


