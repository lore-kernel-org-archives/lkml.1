Return-Path: <linux-kernel-owner+w=401wt.eu-S1754108AbZKBHo0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754108AbZKBHo0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 02:44:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754087AbZKBHoZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 02:44:25 -0500
Received: from smtprelay01.ispgateway.de ([80.67.31.35]:43880 "EHLO
	smtprelay01.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754084AbZKBHoX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 02:44:23 -0500
Message-ID: <4AEE8DD9.1090504@ladisch.de>
Date: Mon, 02 Nov 2009 08:44:25 +0100
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Dave Airlie <airlied@redhat.com>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Pavel Roskin <proski@gnu.org>, dri-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: [PATCH] drm/kms: fix spelling of "CLOCK"
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Df-Sender: linux-kernel@cl.domainfactory-kunde.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pavel Roskin <proski@gnu.org>
Signed-off-by: Pavel Roskin <proski@gnu.org>
[clemens@ladisch.de: merged into drm_fb_helper]
Signed-off-by: Clemens Ladisch <clemens@ladisch.de>

--- linux-2.6/drivers/gpu/drm/drm_fb_helper.c
+++ linux-2.6/drivers/gpu/drm/drm_fb_helper.c
@@ -676,7 +676,7 @@ int drm_fb_helper_set_par(struct fb_info
 	int i;
 
 	if (var->pixclock != 0) {
-		DRM_ERROR("PIXEL CLCOK SET\n");
+		DRM_ERROR("PIXEL CLOCK SET\n");
 		return -EINVAL;
 	}
 
