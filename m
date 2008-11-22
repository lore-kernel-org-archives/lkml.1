Return-Path: <linux-kernel-owner+w=401wt.eu-S1758358AbYKVOjV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758358AbYKVOjV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2008 09:39:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758082AbYKVOjL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Nov 2008 09:39:11 -0500
Received: from nf-out-0910.google.com ([64.233.182.187]:14973 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758070AbYKVOjJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2008 09:39:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:x-x-sender:to:cc:subject:message-id:user-agent:mime-version
         :content-type:from;
        b=bqsA9pAfeF/BsVUuNmWnzP/o9kTxA4Ti+5/1if8aAFtnZiL72yRZK5S6mftDtUmj70
         htNZZHj8Qck5JDnYAMZqHFJgp1a27FRtHsJVFUprAIGX/sdjTWxNu96HRj3vfd5N2jHc
         32ciGqsjdwTVp/DUVJ7Epi8YyfBOoaIWN7HHI=
Date: Sat, 22 Nov 2008 15:39:06 +0100 (CET)
X-X-Sender: frans@frans-desktop
To: mtk.manpages@gmail.com, rdunlap@xenotime.net, linux-doc@vger.kernel.org,
       torvalds@linux-foundation.org
cc: trivial@kernel.org, rob@landley.net, linux-kernel@vger.kernel.org
Subject: [TRIVIAL] [PATCH]
 Documentation/filesystems/ramfs-rootfs-initramfs.txt
Message-ID: <alpine.DEB.1.00.0811221532020.14306@frans-desktop>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
From: frans <fransmeulenbroeks@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A very minor patch on ramfs-rootfs-initramfs.txt.
update the location where CONFIG_INITRAMFS_SOURCE lives in menuconfig

diff --git a/Documentation/filesystems/ramfs-rootfs-initramfs.txt b/Documentation/filesystems/ramfs-rootfs-initramfs.txt
index 62fe9b1..a8273d5 100644
--- a/Documentation/filesystems/ramfs-rootfs-initramfs.txt
+++ b/Documentation/filesystems/ramfs-rootfs-initramfs.txt
@@ -130,12 +130,12 @@ The 2.6 kernel build process always creates a gzipped cpio format initramfs
 archive and links it into the resulting kernel binary.  By default, this
 archive is empty (consuming 134 bytes on x86).

-The config option CONFIG_INITRAMFS_SOURCE (for some reason buried under
-devices->block devices in menuconfig, and living in usr/Kconfig) can be used
-to specify a source for the initramfs archive, which will automatically be
-incorporated into the resulting binary.  This option can point to an existing
-gzipped cpio archive, a directory containing files to be archived, or a text
-file specification such as the following example:
+The config option CONFIG_INITRAMFS_SOURCE (in General Setup in menuconfig,
+and living in usr/Kconfig) can be used to specify a source for the
+initramfs archive, which will automatically be incorporated into the
+resulting binary.  This option can point to an existing gzipped cpio
+archive, a directory containing files to be archived, or a text file
+specification such as the following example:

   dir /dev 755 0 0
   nod /dev/console 644 0 0 c 5 1

Signed-off-by: Frans Meulenbroeks <fransmeulenbroeks@gmail.com>
