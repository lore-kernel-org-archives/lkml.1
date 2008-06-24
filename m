Return-Path: <linux-kernel-owner+w=401wt.eu-S1756171AbYFXNh3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756171AbYFXNh3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 09:37:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753035AbYFXNhO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 09:37:14 -0400
Received: from nf-out-0910.google.com ([64.233.182.188]:17922 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753758AbYFXNhF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 09:37:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=tMwmlCbRjZqcFEBtVbbDM+qeU4mmYF3/zxQJpyBXok2K1FTfA2Cvxnsmc2xcOy+dnb
         l+j1eq2AisxRkFiZPJXbMI+6iRxjHMHSU/j1YGt49P//4ewZ5zFlbULVD3S2jFi7id3u
         w0bhZtjJDPLMmCNTn/CWlVO5rU+s/soG5oPp0=
Date: Tue, 24 Jun 2008 14:33:55 +0100
From: WANG Cong <xiyou.wangcong@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Randy Dunlap <rdunlap@xenotime.net>, Vivek Goyal <vgoyal@in.ibm.com>,
       Maneesh Soni <maneesh@in.ibm.com>
Subject: [Patch] Documentation/kdump/kdump.txt: fix some words
Message-ID: <20080624133355.GA10512@hack.voiplan.pt>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This is a trivial patch that only fixes mistakes in
Documentation/kdump/kdump.txt.

Signed-off-by: WANG Cong <wangcong@zeuux.org>
Cc: Randy Dunlap <rdunlap@xenotime.net>
Cc: Vivek Goyal <vgoyal@in.ibm.com>
Cc: Maneesh Soni <maneesh@in.ibm.com>

---
diff --git a/Documentation/kdump/kdump.txt b/Documentation/kdump/kdump.txt
index b8e52c0..0ffa90c 100644
--- a/Documentation/kdump/kdump.txt
+++ b/Documentation/kdump/kdump.txt
@@ -108,15 +108,15 @@ There are two possible methods of using Kdump.
 
 2) Or use the system kernel binary itself as dump-capture kernel and there is
    no need to build a separate dump-capture kernel. This is possible
-   only with the architecutres which support a relocatable kernel. As
-   of today i386 and ia64 architectures support relocatable kernel.
+   only for the architectures which support a relocatable kernel. As
+   of today i386 and ia64 architectures support a relocatable kernel.
 
 Building a relocatable kernel is advantageous from the point of view that
 one does not have to build a second kernel for capturing the dump. But
 at the same time one might want to build a custom dump capture kernel
 suitable to his needs.
 
-Following are the configuration setting required for system and
+Following are the configuration settings required for system and
 dump-capture kernels for enabling kdump support.
 
 System kernel config options
@@ -299,14 +299,14 @@ For ia64:
 	- Use vmlinux or vmlinuz.gz
 
 
-If you are using a uncompressed vmlinux image then use following command
+If you are using an uncompressed vmlinux image then use the following command
 to load dump-capture kernel.
 
    kexec -p <dump-capture-kernel-vmlinux-image> \
    --initrd=<initrd-for-dump-capture-kernel> --args-linux \
    --append="root=<root-dev> <arch-specific-options>"
 
-If you are using a compressed bzImage/vmlinuz, then use following command
+If you are using a compressed bzImage/vmlinuz, then use the following command
 to load dump-capture kernel.
 
    kexec -p <dump-capture-kernel-bzImage> \
@@ -315,7 +315,7 @@ to load dump-capture kernel.
 
 Please note, that --args-linux does not need to be specified for ia64.
 It is planned to make this a no-op on that architecture, but for now
-it should be omitted
+it should be omitted.
 
 Following are the arch specific command line options to be used while
 loading dump-capture kernel.
@@ -347,7 +347,7 @@ Notes on loading the dump-capture kernel:
 * Boot parameter "1" boots the dump-capture kernel into single-user
   mode without networking. If you want networking, use "3".
 
-* We generally don' have to bring up a SMP kernel just to capture the
+* We generally don't have to bring up a SMP kernel just to capture the
   dump. Hence generally it is useful either to build a UP dump-capture
   kernel or specify maxcpus=1 option while loading dump-capture kernel.
 
