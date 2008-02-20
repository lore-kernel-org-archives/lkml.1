Return-Path: <linux-kernel-owner+w=401wt.eu-S932683AbYBTTqt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932683AbYBTTqt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 14:46:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760344AbYBTTpY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 14:45:24 -0500
Received: from mu-out-0910.google.com ([209.85.134.189]:64813 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759580AbYBTTpX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 14:45:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:references:user-agent:date:from:to:cc:subject:content-disposition;
        b=mGHSQaX9HAC6QYjbAtHpsZ2BzxI59GNe8MR+uFhFY6CwA04kh79k67prb0VRsXEOD6b16ha8hiIotiiKdC3r6nycaWWMn9qxhZkzejGP67zNRI7CGB4wVTr7xpKaim1eD9cXgdb3avleICICq0MOQtIIAXF2IZ/JVkWNVrVbwbM=
Message-Id: <20080220194444.018019215@gmail.com>
References: <20080220194123.114692303@gmail.com>
User-Agent: quilt/0.46-1
Date: Wed, 20 Feb 2008 22:41:25 +0300
From: gorcunov@gmail.com
To: takata@linux-m32r.org, dhowells@redhat.com, schwidefsky@de.ibm.com
Cc: sam@ravnborg.org, gorcunov@gmail.com, linux-kernel@vger.kernel.org
Subject: [patch 2/3] mn10300: cleanup - drop .data.idt section in vmlinux.lds script
Content-Disposition: inline; filename=mn10300-data-idt
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The section .data.idt is not used at all - so drop it.

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
---

 vmlinux.lds.S |    3 ---
 1 file changed, 3 deletions(-)

Index: linux-2.6.git/arch/mn10300/kernel/vmlinux.lds.S
===================================================================
--- linux-2.6.git.orig/arch/mn10300/kernel/vmlinux.lds.S	2008-02-10 10:46:37.000000000 +0300
+++ linux-2.6.git/arch/mn10300/kernel/vmlinux.lds.S	2008-02-20 22:26:01.000000000 +0300
@@ -61,9 +61,6 @@ SECTIONS
   . = ALIGN(4096);
   __nosave_end = .;
 
-  . = ALIGN(4096);
-  .data.page_aligned : { *(.data.idt) }
-
   . = ALIGN(32);
   .data.cacheline_aligned : { *(.data.cacheline_aligned) }
 

-- 
