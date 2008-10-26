Return-Path: <linux-kernel-owner+w=401wt.eu-S1754746AbYJZKsA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754746AbYJZKsA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2008 06:48:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752644AbYJZKrw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Oct 2008 06:47:52 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:42399 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752638AbYJZKrv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2008 06:47:51 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: v4l-dvb-maintainer@linuxtv.org, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] linux/video_{de,en}coder.h: cleanup for userspace
Date: Sun, 26 Oct 2008 06:47:44 -0400
Message-Id: <1225018064-3312-1-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.0.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make sure the linux/video_{de,en}coder.h header files include other header
files that they use (for types and structures).

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 include/linux/video_decoder.h |    3 +++
 include/linux/video_encoder.h |    2 ++
 2 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/include/linux/video_decoder.h b/include/linux/video_decoder.h
index 121e26d..25a191a 100644
--- a/include/linux/video_decoder.h
+++ b/include/linux/video_decoder.h
@@ -1,6 +1,9 @@
 #ifndef _LINUX_VIDEO_DECODER_H
 #define _LINUX_VIDEO_DECODER_H
 
+#include <linux/types.h>
+#include <linux/videodev.h>
+
 #define HAVE_VIDEO_DECODER 1
 
 struct video_decoder_capability { /* this name is too long */
diff --git a/include/linux/video_encoder.h b/include/linux/video_encoder.h
index 4b0e690..b7b6423 100644
--- a/include/linux/video_encoder.h
+++ b/include/linux/video_encoder.h
@@ -1,6 +1,8 @@
 #ifndef _LINUX_VIDEO_ENCODER_H
 #define _LINUX_VIDEO_ENCODER_H
 
+#include <linux/types.h>
+
 struct video_encoder_capability { /* this name is too long */
 	__u32	flags;
 #define	VIDEO_ENCODER_PAL	1	/* can encode PAL signal */
-- 
1.6.0.2

