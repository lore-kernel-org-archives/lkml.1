Return-Path: <linux-kernel-owner+w=401wt.eu-S1757612AbYBUMeU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757612AbYBUMeU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 07:34:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755587AbYBUMeM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 07:34:12 -0500
Received: from mx1.redhat.com ([66.187.233.31]:60743 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755501AbYBUMeL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 07:34:11 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20080220220542.GB22382@uranus.ravnborg.org>
References: <20080220220542.GB22382@uranus.ravnborg.org> <20080220194123.114692303@gmail.com> <20080220194444.018019215@gmail.com>
To: torvalds@osdl.org, akpm@linux-foundation.org
Cc: dhowells@redhat.com, gorcunov@gmail.com, takata@linux-m32r.org,
       schwidefsky@de.ibm.com, linux-kernel@vger.kernel.org, sam@ravnborg.org
Subject: [patch 2/3] mn10300: cleanup - drop .data.idt section in vmlinux.lds script
X-Mailer: MH-E 8.0.3+cvs; nmh 1.2-20070115cvs; GNU Emacs 23.0.50
Date: Thu, 21 Feb 2008 12:33:51 +0000
Message-ID: <19615.1203597231@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The section .data.idt is not used at all - so drop it.

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
Acked-by: Sam Ravnborg <sam@ravnborg.org>
Acked-by: David Howells <dhowells@redhat.com>
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
 
