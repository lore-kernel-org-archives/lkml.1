Return-Path: <linux-kernel-owner+w=401wt.eu-S1753868AbZKCMTa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753868AbZKCMTa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 07:19:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752943AbZKCMTa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 07:19:30 -0500
Received: from smtprelay07.ispgateway.de ([80.67.31.41]:41870 "EHLO
	smtprelay07.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752401AbZKCMT3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 07:19:29 -0500
Message-ID: <4AF01FD5.7040205@ladisch.de>
Date: Tue, 03 Nov 2009 13:19:33 +0100
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Dave Airlie <airlied@redhat.com>
CC: dri-devel@lists.sourceforge.net, linux-fbdev-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/3] drm: set the type of the drm_framebuffer::fbdev field
References: <4AEE8CDD.10600@ladisch.de> <4AEE8D6F.60209@ladisch.de> <alpine.LFD.2.00.0911021431360.30135@casper.infradead.org> <4AF01F72.2030605@ladisch.de>
In-Reply-To: <4AF01F72.2030605@ladisch.de>
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
Needed for the next patch.

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

