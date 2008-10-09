Return-Path: <linux-kernel-owner+w=401wt.eu-S1757964AbYJIXze@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757964AbYJIXze (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 19:55:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753290AbYJIXy6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 19:54:58 -0400
Received: from xenotime.net ([66.160.160.81]:48226 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752448AbYJIXy5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 19:54:57 -0400
Date: Thu, 09 Oct 2008 16:52:35 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 3/8] docs: fix ramfs hello program build name
Message-ID: <12235963552219@xenotime.net>
In-Reply-To: <12235963551043@xenotime.net>
X-Mailer: gregkh_patchbomb
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Frans Meulenbroeks <fransmeulenbroeks@gmail.com>

A trivial patch on ramfs-rootfs-initramfs.txt 
First a file hello.c is created, then the file hello2.c is compiled.
Changed this to hello.c

Mailed this before to trivial@kernel.org only but did not get a reply and
haven't seen it applied yet, so resubmitting to a wider audience...

Signed-off-by: Frans Meulenbroeks <fransmeulenbroeks@gmail.com>
Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 Documentation/filesystems/ramfs-rootfs-initramfs.txt |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.27-rc9-git2.orig/Documentation/filesystems/ramfs-rootfs-initramfs.txt
+++ linux-2.6.27-rc9-git2/Documentation/filesystems/ramfs-rootfs-initramfs.txt
@@ -263,7 +263,7 @@ User Mode Linux, like so:
     sleep(999999999);
   }
   EOF
-  gcc -static hello2.c -o init
+  gcc -static hello.c -o init
   echo init | cpio -o -H newc | gzip > test.cpio.gz
   # Testing external initramfs using the initrd loading mechanism.
   qemu -kernel /boot/vmlinuz -initrd test.cpio.gz /dev/zero


-- 

