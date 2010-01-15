Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757712Ab0AOOG5 (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 15 Jan 2010 09:06:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757679Ab0AOOGz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jan 2010 09:06:55 -0500
Received: from ey-out-2122.google.com ([74.125.78.27]:40373 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757672Ab0AOOGx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jan 2010 09:06:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=xYDIjc1X/0K+gCYtzko4mwbFAMJcF0raroyHcRJjPrh9NNl4uoaEmC3XHlAQW+1juV
         QhGSroLtGA/r6kp/UY5952ZGyXoUhGqwhXCF/qACPYKDP7oy3YSEPMCNFwcH0QEL8NJu
         X50O9YIw7oszHFvropoFmcOhPf4nHaVS6Q2wM=
Message-ID: <4B50778F.2010405@gmail.com>
Date: Fri, 15 Jan 2010 15:11:27 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Thunderbird/3.0
MIME-Version: 1.0
To: David Airlie <airlied@linux.ie>, dri-devel@lists.sourceforge.net,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] drm/radeon/kms: crtc_ omitted in display assignments in radeon_atom_mode_fixup()?
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The crtc_ prefix was omitted in h/vdisplay assignments

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
Not sure, but maybe the change below is needed? please ack/nack.

diff --git a/drivers/gpu/drm/radeon/radeon_encoders.c b/drivers/gpu/drm/radeon/radeon_encoders.c
index 82eb551..a9dc073 100644
--- a/drivers/gpu/drm/radeon/radeon_encoders.c
+++ b/drivers/gpu/drm/radeon/radeon_encoders.c
@@ -233,8 +233,8 @@ static bool radeon_atom_mode_fixup(struct drm_encoder *encoder,
 		if (!ASIC_IS_AVIVO(rdev)) {
 			adjusted_mode->hdisplay = mode->hdisplay;
 			adjusted_mode->vdisplay = mode->vdisplay;
-			adjusted_mode->crtc_hdisplay = mode->hdisplay;
-			adjusted_mode->crtc_vdisplay = mode->vdisplay;
+			adjusted_mode->crtc_hdisplay = mode->crtc_hdisplay;
+			adjusted_mode->crtc_vdisplay = mode->crtc_vdisplay;
 		}
 		adjusted_mode->base.id = mode_id;
 	}
