Return-Path: <linux-kernel-owner+w=401wt.eu-S1760476AbZEZXVs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760476AbZEZXVs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 19:21:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759106AbZEZXSl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 19:18:41 -0400
Received: from one.firstfloor.org ([213.235.205.2]:53173 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759295AbZEZXSc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 19:18:32 -0400
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org, x86@kernel.org, hpa@zytor.com
Cc: Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 14/17] x86: MCE: Document new 32bit mcelog requirement in Documentation/Changes
Date: Wed, 27 May 2009 01:18:13 +0200
Message-Id: <17986790ae68ad7f93701894fd130cfd84f6adf5.1243377662.git.ak@linux.intel.com>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <ff5aa0b2473d839010ec97dc3dbae4e198c28db9.1243377662.git.ak@linux.intel.com>
References: <1243379896-26869-1-git-send-email-andi@firstfloor.org>
 <bce28247059ad80b138de8ae9f22f9d13c856589.1243377662.git.ak@linux.intel.com>
 <86b35f6b0b17e1edc38fb5c3178967ffc4d1fa0a.1243377662.git.ak@linux.intel.com>
 <5a2337a03ce794fe7cf69e338ffacacb3770797c.1243377662.git.ak@linux.intel.com>
 <4010bb177562589d0fd54043bb7bc6ea4d7998fd.1243377662.git.ak@linux.intel.com>
 <c21d841c7b7d68f60e52c9c20c3d9573cfd8bf95.1243377662.git.ak@linux.intel.com>
 <e625a26c7a082ec6033b4a836c98d7f725fe80f9.1243377662.git.ak@linux.intel.com>
 <b7b15c0ea92409e6641de1e90da9c63664066eba.1243377662.git.ak@linux.intel.com>
 <e2d81decded3202e410a569f8c224986f2e83668.1243377662.git.ak@linux.intel.com>
 <c8c4b619d810eba16e62044a38284761ef69c8f2.1243377662.git.ak@linux.intel.com>
 <91219e907da103fc39dba8d32aaa9f872f0e6cc1.1243377662.git.ak@linux.intel.com>
 <2bc54830cc9e63d090dc461db0bdf99fc3d3cd4a.1243377662.git.ak@linux.intel.com>
 <6dfa191bd595ff969fafb3603ba464254ca895a7.1243377662.git.ak@linux.intel.com>
 <ff5aa0b2473d839010ec97dc3dbae4e198c28db9.1243377662.git.ak@linux.intel.com>
In-Reply-To: <bce28247059ad80b138de8ae9f22f9d13c856589.1243377662.git.ak@linux.intel.com>
References: <bce28247059ad80b138de8ae9f22f9d13c856589.1243377662.git.ak@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 Documentation/Changes |   15 +++++++++++++++
 1 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/Documentation/Changes b/Documentation/Changes
index b95082b..d21b3b5 100644
--- a/Documentation/Changes
+++ b/Documentation/Changes
@@ -48,6 +48,7 @@ o  procps                 3.2.0                   # ps --version
 o  oprofile               0.9                     # oprofiled --version
 o  udev                   081                     # udevinfo -V
 o  grub                   0.93                    # grub --version
+o  mcelog		  0.6
 
 Kernel compilation
 ==================
@@ -276,6 +277,16 @@ before running exportfs or mountd.  It is recommended that all NFS
 services be protected from the internet-at-large by a firewall where
 that is possible.
 
+mcelog
+------
+
+In Linux 2.6.31+ the i386 kernel needs to run the mcelog utility
+as a regular cronjob similar to the x86-64 kernel to process and log
+machine check events when CONFIG_X86_NEW_MCE is enabled. Machine check
+events are errors reported by the CPU. Processing them is strongly encouraged.
+All x86-64 kernels since 2.6.4 require the mcelog utility to
+process machine checks.
+
 Getting updated software
 ========================
 
@@ -365,6 +376,10 @@ FUSE
 ----
 o <http://sourceforge.net/projects/fuse>
 
+mcelog
+------
+o <ftp://ftp.kernel.org/pub/linux/utils/cpu/mce/mcelog/>
+
 Networking
 **********
 
-- 
1.6.0.2

