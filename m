Return-Path: <linux-kernel-owner+w=401wt.eu-S1758736AbYGaBc1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758736AbYGaBc1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 21:32:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755239AbYGaBav
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 21:30:51 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:47606 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753749AbYGaBao (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 21:30:44 -0400
Message-Id: <20080731012927.447357400@vergenet.net>
References: <20080731012208.115225969@vergenet.net>
User-Agent: quilt/0.46-1
Date: Thu, 31 Jul 2008 11:22:11 +1000
To: kexec@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Vivek Goyal <vgoyal@redhat.com>, Andrew Morton <akpm@linux-foundation.org>
From: Simon Horman <horms@verge.net.au>
Subject: [patch 3/6] kdump: update elfcorehdr documentation to reflect supported architectures
Content-Disposition: inline; filename=elfcorehdr-doc.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

IA64, PPC and SH also support the elfcorehdr command line.

Signed-off-by: Simon Horman <horms@verge.net.au>
Acked-by: Vivek Goyal <vgoyal@redhat.com>

--- 
Andrew, as this is a very minor documentation fix it can wait until
after 2.6.27 if you prefer.

Index: linux-2.6/Documentation/kernel-parameters.txt
===================================================================
--- linux-2.6.orig/Documentation/kernel-parameters.txt	2008-07-30 09:48:40.000000000 +1000
+++ linux-2.6/Documentation/kernel-parameters.txt	2008-07-30 09:48:45.000000000 +1000
@@ -688,7 +688,7 @@ and is between 256 and 4096 characters. 
 			See Documentation/block/as-iosched.txt and
 			Documentation/block/deadline-iosched.txt for details.
 
-	elfcorehdr=	[X86-32, X86_64]
+	elfcorehdr=	[IA64,PPC,SH,X86-32,X86_64]
 			Specifies physical address of start of kernel core
 			image elf header. Generally kexec loader will
 			pass this option to capture kernel.

-- 

-- 
Horms

