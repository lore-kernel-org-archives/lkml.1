Return-Path: <linux-kernel-owner+w=401wt.eu-S1756774AbYGFLcQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756774AbYGFLcQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2008 07:32:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752917AbYGFLcA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jul 2008 07:32:00 -0400
Received: from wx-out-0506.google.com ([66.249.82.227]:30537 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751912AbYGFLcA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2008 07:32:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=W1dPArScadR4kzge/Af7s7KXHxp72t2STHAXAeMBgNIUginLVrK+kNua4QcVmDhkBZ
         AQ2Ku1zigFrwBinOlDY3YiXLbOfycdMSFHHAq/6/hdFPOsW1z8lGrqYFqrhCwXjyWQZo
         p8cefL+l8lXbtxqTIvV7PwNBkF8BNOngEhBKI=
Message-ID: <a4423d670807060431w639f0b1ajcbad6471d50ef802@mail.gmail.com>
Date: Sun, 6 Jul 2008 15:31:55 +0400
From: "Alexander Beregalov" <a.beregalov@gmail.com>
To: kernel-janitors@vger.kernel.org, airlied@linux.ie,
       dri-devel@lists.sourceforge.net,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: [PATCH] drm_memory.h: remove double inclusion of linux/vmalloc.h
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexander Beregalov <a.beregalov@gmail.com>

Remove double inclusion of linux/vmalloc.h

drivers/char/drm/drm_memory.h |    2 --
1 files changed, 0 insertions(+), 2 deletions(-)

Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>
---

diff --git a/drivers/char/drm/drm_memory.h b/drivers/char/drm/drm_memory.h
index 63e425b..15af9b3 100644
--- a/drivers/char/drm/drm_memory.h
+++ b/drivers/char/drm/drm_memory.h
@@ -44,8 +44,6 @@

 #if __OS_HAS_AGP

-#include <linux/vmalloc.h>
-
 #ifdef HAVE_PAGE_AGP
 #include <asm/agp.h>
 #else
