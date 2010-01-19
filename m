Return-Path: <linux-kernel-owner+w=401wt.eu-S1753579Ab0ASMZx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753579Ab0ASMZx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 07:25:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753021Ab0ASMZw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 07:25:52 -0500
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:60294 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751735Ab0ASMZw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 07:25:52 -0500
X-Sasl-enc: sEZw9Cbop8/3pk7q2hTdp/XOHkk5bM67PYs0twI2JM8k 1263903950
Message-ID: <4B55A4CE.4060000@ladisch.de>
Date: Tue, 19 Jan 2010 13:25:50 +0100
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Dave Airlie <airlied@redhat.com>
CC: Pavel Roskin <proski@gnu.org>, dri-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, Trivial Patch Monkey <trivial@kernel.org>
Subject: [PATCH] drm/kms: fix spelling of "CLOCK"
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pavel Roskin <proski@gnu.org>

Signed-off-by: Pavel Roskin <proski@gnu.org>
[clemens@ladisch.de: merged into drm_fb_helper]
Signed-off-by: Clemens Ladisch <clemens@ladisch.de>

--- a/drivers/gpu/drm/drm_fb_helper.c
+++ b/drivers/gpu/drm/drm_fb_helper.c
@@ -694,7 +694,7 @@ int drm_fb_helper_set_par(struct fb_info
 	int i;
 
 	if (var->pixclock != 0) {
-		DRM_ERROR("PIXEL CLCOK SET\n");
+		DRM_ERROR("PIXEL CLOCK SET\n");
 		return -EINVAL;
 	}
 
