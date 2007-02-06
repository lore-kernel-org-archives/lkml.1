Return-Path: <linux-kernel-owner+w=401wt.eu-S964934AbXBFQKW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964934AbXBFQKW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 11:10:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965128AbXBFQKW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 11:10:22 -0500
Received: from nz-out-0506.google.com ([64.233.162.224]:61221 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965041AbXBFQKU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 11:10:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:to:cc:subject:message-id:mime-version:content-type:content-disposition:in-reply-to:user-agent:from;
        b=RWUgKZkP6lj/ohZ4v1oBRoKgjPtP6c55UDQq+h3Cjw11izmSj5tdQZJQdBVjoXN0jUhY+Eccp17z0e9dghkhcHJGqm6jI16/BGXavdpBRtz2+OQFxpk5/yEvmTE2Wd9RkHcFVhLvl7Y8pUkTpCQXCVaTQcGRgJk+x6tOOzw2HKA=
Date: Tue, 6 Feb 2007 18:10:05 +0200
To: airlied@linux.ie
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.sourceforge.net
Subject: [PATCH 2.6.20] drm: Use ARRAY_SIZE macro when appropriate
Message-ID: <20070206161005.GQ8991@Ahmed>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070206160204.GA8991@Ahmed>
User-Agent: Mutt/1.5.11
From: "Ahmed S. Darwish" <darwish.07@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

A patch to use ARRAY_SIZE macro already defined in kernel.h

Signed-off-by: Ahmed S. Darwish <darwish.07@gmail.com>
---
diff --git a/drivers/char/drm/drm_proc.c b/drivers/char/drm/drm_proc.c
index 62d5fe1..8943ad1 100644
--- a/drivers/char/drm/drm_proc.c
+++ b/drivers/char/drm/drm_proc.c
@@ -72,7 +72,7 @@ static struct drm_proc_list {
 #endif
 };
 
-#define DRM_PROC_ENTRIES (sizeof(drm_proc_list)/sizeof(drm_proc_list[0]))
+#define DRM_PROC_ENTRIES ARRAY_SIZE(drm_proc_list)
 
 /**
  * Initialize the DRI proc filesystem for a device.


-- 
Ahmed S. Darwish
http://darwish-07.blogspot.com
