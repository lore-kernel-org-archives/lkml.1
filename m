Return-Path: <linux-kernel-owner+w=401wt.eu-S1754318AbYACPqA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754318AbYACPqA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 10:46:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754741AbYACPm2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 10:42:28 -0500
Received: from ns1.suse.de ([195.135.220.2]:48627 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754304AbYACPmZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 10:42:25 -0500
From: Andi Kleen <ak@suse.de>
References: <20080103442.621670000@suse.de>
In-Reply-To: <20080103442.621670000@suse.de>
To: hpa@rpath.com, sam@ravnborg.org, linux-kernel@vger.kernel.org
Subject: [PATCH x86] [10/16] Document fdimage/isoimage completely in make help
Message-Id: <20080103154224.47EA914DDB@wotan.suse.de>
Date: Thu,  3 Jan 2008 16:42:24 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Add missing targets and missing options in x86 make help

Cc: hpa@rpath.com
Cc: sam@ravnborg.org

Signed-off-by: Andi Kleen <ak@suse.de>

---
 arch/x86/Makefile |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

Index: linux/arch/x86/Makefile
===================================================================
--- linux.orig/arch/x86/Makefile
+++ linux/arch/x86/Makefile
@@ -247,9 +247,13 @@ define archhelp
   echo  '		   (your) ~/bin/installkernel or'
   echo  '		   (distribution) /sbin/installkernel or'
   echo  '		   install to $$(INSTALL_PATH) and run lilo'
-  echo  '  bzdisk       - Create a boot floppy in /dev/fd0'
-  echo  '  fdimage      - Create a boot floppy image'
-  echo  '  isoimage     - Create a boot CD-ROM image'
+  echo  '  fdimage      - Create 1.4MB boot floppy image (arch/x86/boot/fdimage)'
+  echo  '  fdimage144	- Create 1.4MB boot floppy image (arch/x86/boot/fdimage)'
+  echo  '  fdimage288	- Create 2.8MB boot floppy image (arch/x86/boot/fdimage)'
+  echo  '  isoimage     - Create a boot CD-ROM image (arch/x86/boot/image.iso)'
+  echo  '                  bzdisk/fdimage*/isoimage also accept:'
+  echo  '                  FDARGS="..."  arguments for the booted kernel'
+  echo  '                  FDINITRD=file initrd for the booted kernel'
 endef
 
 CLEAN_FILES += arch/x86/boot/fdimage \
