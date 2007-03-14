Return-Path: <linux-kernel-owner+w=401wt.eu-S1030740AbXCNJVG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030740AbXCNJVG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 05:21:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030807AbXCNJUW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 05:20:22 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:60510 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030810AbXCNJUA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 05:20:00 -0400
To: torvalds@linux-foundation.org
Subject: [PATCH 13/17] ANSIfy powerpc floppy.h
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Message-Id: <E1HRPeK-0003Yo-26@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Wed, 14 Mar 2007 09:20:00 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 include/asm-powerpc/floppy.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/asm-powerpc/floppy.h b/include/asm-powerpc/floppy.h
index a0f14ee..afa700d 100644
--- a/include/asm-powerpc/floppy.h
+++ b/include/asm-powerpc/floppy.h
@@ -178,7 +178,7 @@ static struct fd_dma_ops virt_dma_ops =
 	._dma_setup = vdma_dma_setup
 };
 
-static int fd_request_dma()
+static int fd_request_dma(void)
 {
 	if (can_use_virtual_dma & 1) {
 		fd_ops = &virt_dma_ops;
-- 
1.5.0-rc2.GIT


