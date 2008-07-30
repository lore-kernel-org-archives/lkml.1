Return-Path: <linux-kernel-owner+w=401wt.eu-S1757369AbYG3Aah@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757369AbYG3Aah (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 20:30:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753173AbYG3Aaa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 20:30:30 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:38034 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752489AbYG3Aa3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 20:30:29 -0400
Date: Wed, 30 Jul 2008 10:30:28 +1000
From: Simon Horman <horms@verge.net.au>
To: linux-kernel@vger.kernel.org, kexec@lists.infradead.org
Cc: Vivek Goyal <vgoyal@redhat.com>
Subject: [patch] kdump: update elfcorehdr documentation to reflect
	supported architectures
Message-ID: <20080730003026.GA22106@verge.net.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

IA64, PPC and SH also support the elfcorehdr command line.

Signed-off-by: Simon Horman <horms@verge.net.au>

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
