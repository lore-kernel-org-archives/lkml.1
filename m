Return-Path: <linux-kernel-owner+w=401wt.eu-S1754755AbZKDImy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754755AbZKDImy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 03:42:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754740AbZKDImx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 03:42:53 -0500
Received: from smtprelay02.ispgateway.de ([80.67.31.25]:52150 "EHLO
	smtprelay02.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752133AbZKDImv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 03:42:51 -0500
Message-ID: <4AF13E90.3010709@ladisch.de>
Date: Wed, 04 Nov 2009 09:42:56 +0100
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: James Simmons <jsimmons@infradead.org>, Dave Airlie <airlied@redhat.com>
CC: dri-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [PATCH v3 2/3] drm: set the type of the drm_framebuffer::fbdev field
References: <4AEE8CDD.10600@ladisch.de> <4AEE8D6F.60209@ladisch.de> <alpine.LFD.2.00.0911021431360.30135@casper.infradead.org> <4AF01F72.2030605@ladisch.de> <4AF01FFD.50409@ladisch.de> <alpine.LFD.2.00.0911031718160.14442@casper.infradead.org> <4AF13E04.8000005@ladisch.de>
In-Reply-To: <4AF13E04.8000005@ladisch.de>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Df-Sender: linux-kernel@cl.domainfactory-kunde.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The fbdev field of the drm_framebuffer structure is always used to store
a pointer to a fb_info, so there is no reason for it to be void*.

Signed-off-by: Clemens Ladisch <clemens@ladisch.de>
---
Needed for the next patch; no changes from v2.

 include/drm/drm_crtc.h          |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6/include/drm/drm_crtc.h
+++ linux-2.6/include/drm/drm_crtc.h
@@ -256,7 +256,7 @@ struct drm_framebuffer {
 	unsigned int depth;
 	int bits_per_pixel;
 	int flags;
-	void *fbdev;
+	struct fb_info *fbdev;
 	u32 pseudo_palette[17];
 	struct list_head filp_head;
 	/* if you are using the helper */

