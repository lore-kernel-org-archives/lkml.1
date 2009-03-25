Return-Path: <linux-kernel-owner+w=401wt.eu-S1761344AbZCYTB0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761344AbZCYTB0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 15:01:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754343AbZCYTAy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 15:00:54 -0400
Received: from mx2.redhat.com ([66.187.237.31]:44995 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753490AbZCYTAw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 15:00:52 -0400
From: Bill Nottingham <notting@redhat.com>
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: Bill Nottingham <notting@redhat.com>
Subject: [PATCH] Declare PIO_CMAP/GIO_CMAP as compatbile ioctls.
Date: Wed, 25 Mar 2009 15:00:47 -0400
Message-Id: <1238007647-25752-2-git-send-email-notting@redhat.com>
In-Reply-To: <1238007647-25752-1-git-send-email-notting@redhat.com>
References: <1238007647-25752-1-git-send-email-notting@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Otherwise, these don't work when called from 32-bit userspace on 64-bit kernels.
---
 fs/compat_ioctl.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/fs/compat_ioctl.c b/fs/compat_ioctl.c
index 5235c67..9ee71a0 100644
--- a/fs/compat_ioctl.c
+++ b/fs/compat_ioctl.c
@@ -1937,6 +1937,8 @@ ULONG_IOCTL(SET_BITMAP_FILE)
 /* Big K */
 COMPATIBLE_IOCTL(PIO_FONT)
 COMPATIBLE_IOCTL(GIO_FONT)
+COMPATIBLE_IOCTL(PIO_CMAP)
+COMPATIBLE_IOCTL(GIO_CMAP)
 ULONG_IOCTL(KDSIGACCEPT)
 COMPATIBLE_IOCTL(KDGETKEYCODE)
 COMPATIBLE_IOCTL(KDSETKEYCODE)
-- 
1.6.1.2

