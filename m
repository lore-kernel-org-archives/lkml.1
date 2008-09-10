Return-Path: <linux-kernel-owner+w=401wt.eu-S1752088AbYIJLWr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752088AbYIJLWr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 07:22:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752132AbYIJLVn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 07:21:43 -0400
Received: from ey-out-2122.google.com ([74.125.78.27]:27847 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754154AbYIJLVm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 07:21:42 -0400
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: linux-kernel@vger.kernel.org
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>,
       David Woodhouse <dwmw2@infradead.org>,
       Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH] include <linux/videodev2.h> into linux/ivtv.h
Date: Wed, 10 Sep 2008 14:22:06 +0300
Message-Id: <1221045726-5674-4-git-send-email-kirill@shutemov.name>
X-Mailer: git-send-email 1.5.6.5.GIT
In-Reply-To: <1221045726-5674-3-git-send-email-kirill@shutemov.name>
References: <1221045726-5674-1-git-send-email-kirill@shutemov.name>
 <1221045726-5674-2-git-send-email-kirill@shutemov.name>
 <1221045726-5674-3-git-send-email-kirill@shutemov.name>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

linux/videodev2.h defines enum v4l2_buf_type and struct v4l2_rect

Signed-off-by: Kirill A. Shutemov <kirill@shutemov.name>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
---
 include/linux/ivtv.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/include/linux/ivtv.h b/include/linux/ivtv.h
index 17ca64b..f272028 100644
--- a/include/linux/ivtv.h
+++ b/include/linux/ivtv.h
@@ -23,6 +23,7 @@
 
 #include <linux/compiler.h>
 #include <linux/types.h>
+#include <linux/videodev2.h>
 
 /* ivtv knows several distinct output modes: MPEG streaming,
    YUV streaming, YUV updates through user DMA and the passthrough
-- 
1.5.6.5.GIT

