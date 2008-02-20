Return-Path: <linux-kernel-owner+w=401wt.eu-S1761577AbYBTTp3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761577AbYBTTp3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 14:45:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756823AbYBTTpN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 14:45:13 -0500
Received: from nf-out-0910.google.com ([64.233.182.189]:60217 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756547AbYBTTpL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 14:45:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:references:user-agent:date:from:to:cc:subject:content-disposition;
        b=nbskrEYNdMhooBP2irt2Ft0Yw0u6BJBeaMIIgLHq07R1SnG4JBLcQxmMMgx4Pa2NZ4nWHk8O+hRk31AMbi3y13qhbdqqR8QWIV8zSg4kTmH7vimYbDkULiSqzDHzjVHzMtqVCdLcZvKCdyNwkKFzHwSU75lrOckJo/hUioBJQQQ=
Message-Id: <20080220194443.628830230@gmail.com>
References: <20080220194123.114692303@gmail.com>
User-Agent: quilt/0.46-1
Date: Wed, 20 Feb 2008 22:41:24 +0300
From: gorcunov@gmail.com
To: takata@linux-m32r.org, dhowells@redhat.com, schwidefsky@de.ibm.com
Cc: sam@ravnborg.org, gorcunov@gmail.com, linux-kernel@vger.kernel.org
Subject: [patch 1/3] m32r: cleanup - drop .data.idt section in vmlinux.lds script
Content-Disposition: inline; filename=m32r-idt
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The section .data.idt is not used at all - so drop it.

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
---

 vmlinux.lds.S |    3 ---
 1 file changed, 3 deletions(-)

Index: linux-2.6.git/arch/m32r/kernel/vmlinux.lds.S
===================================================================
--- linux-2.6.git.orig/arch/m32r/kernel/vmlinux.lds.S	2008-02-10 10:46:37.000000000 +0300
+++ linux-2.6.git/arch/m32r/kernel/vmlinux.lds.S	2008-02-20 22:23:46.000000000 +0300
@@ -60,9 +60,6 @@ SECTIONS
   . = ALIGN(4096);
   __nosave_end = .;
 
-  . = ALIGN(4096);
-  .data.page_aligned : { *(.data.idt) }
-
   . = ALIGN(32);
   .data.cacheline_aligned : { *(.data.cacheline_aligned) }
 

-- 
