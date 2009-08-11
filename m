Return-Path: <linux-kernel-owner+w=401wt.eu-S1755477AbZHKVk3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755477AbZHKVk3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 17:40:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754807AbZHKVk2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 17:40:28 -0400
Received: from fmmailgate03.web.de ([217.72.192.234]:60267 "EHLO
	fmmailgate03.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754779AbZHKVk2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 17:40:28 -0400
From: Thomas Schlichter <thomas.schlichter@web.de>
To: Dave Airlie <airlied@redhat.com>
Cc: Alex Deucher <alexdeucher@gmail.com>, Eric Anholt <eric@anholt.net>,
       linux-kernel@vger.kernel.org,
       Thomas Schlichter <thomas.schlichter@web.de>
Subject: [PATCH] drm/via: add pci id for VIA VX800 chipset
Date: Tue, 11 Aug 2009 23:40:27 +0200
Message-Id: <1250026827-11167-1-git-send-email-thomas.schlichter@web.de>
X-Mailer: git-send-email 1.6.0.4
X-Provags-ID: V01U2FsdGVkX19kCp9VVA/UKpPJnPt2T69yqqKn+269iiJSRQy8
	BYekyhXC7LH7blQNsWFKhD1AjTdhrsC2e5FHzlbKJ7ZcksOEaw
	GqqDMo4zBZEb6V2X3EKA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The VIA DRM module is able to accelerate 2D video on the VX800
chipset, thus add the corresponding PCI ID. Accelerated 3D video
is not implemented.

The modified VIA DRM module was tested with X.Org openchrome driver on
a Samsung NC20 netbook. Video playback with xine requires nearly 30%
less CPU cycles.

Signed-off-by: Thomas Schlichter <thomas.schlichter@web.de>
---
 include/drm/drm_pciids.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/include/drm/drm_pciids.h b/include/drm/drm_pciids.h
index 8535084..aac8877 100644
--- a/include/drm/drm_pciids.h
+++ b/include/drm/drm_pciids.h
@@ -477,6 +477,7 @@
 	{0x1106, 0x3343, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0}, \
 	{0x1106, 0x3230, PCI_ANY_ID, PCI_ANY_ID, 0, 0, VIA_DX9_0}, \
 	{0x1106, 0x3157, PCI_ANY_ID, PCI_ANY_ID, 0, 0, VIA_PRO_GROUP_A}, \
+	{0x1106, 0x1122, PCI_ANY_ID, PCI_ANY_ID, 0, 0, VIA_DX9_0}, \
 	{0, 0, 0}
 
 #define i810_PCI_IDS \
-- 
1.6.0.4

