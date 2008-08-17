Return-Path: <linux-kernel-owner+w=401wt.eu-S1752689AbYHQJHa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752689AbYHQJHa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2008 05:07:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752074AbYHQJHN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Aug 2008 05:07:13 -0400
Received: from ug-out-1314.google.com ([66.249.92.172]:40087 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752021AbYHQJHL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2008 05:07:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:x-x-sender:to:cc:subject:message-id:mime-version:content-type
         :from;
        b=n/4tNIxo5TI6Fn6FHiMeuL87O/8vW597QS/nQXrtPdBesGMDqDA1iK14WrtbzgMQEy
         dvkWpAEjG50gZZdKUCAxkll40JhhwdM14ZzH3EYRH4Df7J5kjzqKAsm5GKTpxNONvxmb
         YyNa+Ds616iXwsVMtekwUyFp8WzKXJUgcuF0w=
Date: Sun, 17 Aug 2008 11:07:04 +0200 (CEST)
X-X-Sender: frans@frans-desktop
To: mtk.manpages@gmail.com, rdunlap@xenotime.net, linux-doc@vger.kernel.org,
       torvalds@linux-foundation.org
cc: trivial@kernel.org, linux-kernel@vger.kernel.org, rob@landley.net
Subject: [TRIVIAL] [PATCH]
 Documentation/filesystems/ramfs-rootfs-initramfs.txt
Message-ID: <alpine.DEB.0.99.0808171058570.6721@frans-desktop>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
From: frans <fransmeulenbroeks@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A trivial patch on ramfs-rootfs-initramfs.txt 
First a file hello.c is created, then the file hello2.c is compiled.
Changed this to hello.c

Mailed this before to trivial@kernel.org only but did not get a reply and
haven't seen it applied yet, so resubmitting to a wider audience...

Signed-off-by: Frans Meulenbroeks <fransmeulenbroeks@gmail.com>

diff --git a/Documentation/filesystems/ramfs-rootfs-initramfs.txt b/Documentation/filesystems/ramfs-rootfs-initramfs.txt
index 7be232b..62fe9b1 100644
--- a/Documentation/filesystems/ramfs-rootfs-initramfs.txt
+++ b/Documentation/filesystems/ramfs-rootfs-initramfs.txt
@@ -263,7 +263,7 @@ User Mode Linux, like so:
     sleep(999999999);
   }
   EOF
-  gcc -static hello2.c -o init
+  gcc -static hello.c -o init
   echo init | cpio -o -H newc | gzip > test.cpio.gz
   # Testing external initramfs using the initrd loading mechanism.
   qemu -kernel /boot/vmlinuz -initrd test.cpio.gz /dev/zero
