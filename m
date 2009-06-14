Return-Path: <linux-kernel-owner+w=401wt.eu-S1760596AbZFNNmr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760596AbZFNNmr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jun 2009 09:42:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755331AbZFNNmk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Jun 2009 09:42:40 -0400
Received: from mail-yx0-f171.google.com ([209.85.210.171]:56806 "EHLO
	mail-yx0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755645AbZFNNmj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jun 2009 09:42:39 -0400
X-Greylist: delayed 594 seconds by postgrey-1.27 at vger.kernel.org; Sun, 14 Jun 2009 09:42:39 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=PT0iwFKRoNVfiCPZqb6F+Bcvav7SBZjt6VKnO+gX+1Mn0kxL2gJOnOvjJdadK5mZ9h
         2GbQIXO+SCjGd36TN2wWiBG6Ti3AEeU0Q3hF/EaIDCrH8IZuVpl3/J6ytS2/8s78dqzY
         1HsAr9JSQCDa1JoBlI76qFAo+B2XP1wR1dmpk=
MIME-Version: 1.0
In-Reply-To: <1244649318.9942.33.camel@earl.localdomain>
References: <1244649318.9942.33.camel@earl.localdomain>
Date: Sun, 14 Jun 2009 09:42:40 -0400
Message-ID: <48f7fe350906140642i595fa90ep182838e3ad4893fd@mail.gmail.com>
Subject: [PATCH 1/3] Re: Radeon kernel modesetting patch (as staging) please 
	review
From: Ryan Hope <rmh3093@gmail.com>
To: Jerome Glisse <glisse@freedesktop.org>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.sf.net
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 85adafcf5d18e58c60d9fdbb718abe9149661736
Author: Ryan Hope <rmh3093@gmail.com>
Date:   Fri Jun 12 12:17:54 2009 -0400

    fix ttm kconfig

diff --git a/drivers/gpu/drm/ttm/Makefile b/drivers/gpu/drm/ttm/Makefile
index 0686829..299a73c 100644
--- a/drivers/gpu/drm/ttm/Makefile
+++ b/drivers/gpu/drm/ttm/Makefile
@@ -6,4 +6,4 @@ ttm-y := ttm_agp_backend.o ttm_memory.o ttm_tt.o ttm_bo.o \
        ttm_bo_util.o ttm_bo_vm.o ttm_module.o ttm_global.o


-obj-m += ttm.o
+obj-$(CONFIG_DRM_TTM) += ttm.o
