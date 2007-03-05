Return-Path: <linux-kernel-owner+w=401wt.eu-S1751832AbXCEBr6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751832AbXCEBr6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2007 20:47:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751831AbXCEBrz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Mar 2007 20:47:55 -0500
Received: from mailout.stusta.mhn.de ([141.84.69.5]:49915 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751857AbXCEBrn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2007 20:47:43 -0500
Date: Mon, 5 Mar 2007 02:47:45 +0100
From: Adrian Bunk <bunk@stusta.de>
To: Andrew Morton <akpm@linux-foundation.org>, airlied@linux.ie
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.sourceforge.net
Subject: [-mm patch] make drivers/char/drm/drm_vm.c:drm_io_prot() static
Message-ID: <20070305014745.GS3441@stusta.de>
References: <20070302030026.5eef0c92.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070302030026.5eef0c92.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 02, 2007 at 03:00:26AM -0800, Andrew Morton wrote:
>...
> Changes since 2.6.20-mm2:
>...
>  git-drm.patch
>...
>  git trees
>...

This patch makes the needlessly global drm_io_prot() static.

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---
--- linux-2.6.21-rc2-mm1/drivers/char/drm/drm_vm.c.old	2007-03-04 20:39:25.000000000 +0100
+++ linux-2.6.21-rc2-mm1/drivers/char/drm/drm_vm.c	2007-03-04 20:39:34.000000000 +0100
@@ -41,7 +41,7 @@
 static void drm_vm_open(struct vm_area_struct *vma);
 static void drm_vm_close(struct vm_area_struct *vma);
 
-pgprot_t drm_io_prot(uint32_t map_type, struct vm_area_struct *vma)
+static pgprot_t drm_io_prot(uint32_t map_type, struct vm_area_struct *vma)
 {
 	pgprot_t tmp = vm_get_page_prot(vma->vm_flags);
 

