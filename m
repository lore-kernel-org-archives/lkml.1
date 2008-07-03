Return-Path: <linux-kernel-owner+w=401wt.eu-S1754086AbYGCRYV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754086AbYGCRYV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 13:24:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752621AbYGCRYN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 13:24:13 -0400
Received: from wa-out-1112.google.com ([209.85.146.177]:47248 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752478AbYGCRYM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 13:24:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent:sender;
        b=QGpB2tYvGGgZwyyZ+q0enUU5xnaGt1/ibOJ3kEnvM7+xwnI37qTNnUToTYrhgUcu56
         2IiLfBao42rWqxfXXi+W3IpSHND6AanEIKIQ9HnH5oeSznzO48nhDY7xNX0tEa9S/YAg
         oZSnreysd2efUVRk9qQ9sNdOA9hHDZAsPTCI4=
Date: Thu, 3 Jul 2008 22:52:57 +0530
From: Rabin Vincent <rabin@rab.in>
To: lkml <linux-kernel@vger.kernel.org>
Cc: trivial@kernel.org, Randy Dunlap <randy.dunlap@oracle.com>
Subject: [PATCH] doc: remove incorrect config option location
Message-ID: <20080703172257.GA1498@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CONFIG_INITRAMFS_SOURCE is no longer under Devices->Block Devices, but
is now in General Setup.  The correct location is easily found using
menuconfig's search, so remove the mention of the incorrect location
from the docs.

Signed-off-by: Rabin Vincent <rabin@rab.in>
---
 .../filesystems/ramfs-rootfs-initramfs.txt         |   11 +++++------
 1 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/Documentation/filesystems/ramfs-rootfs-initramfs.txt b/Documentation/filesystems/ramfs-rootfs-initramfs.txt
index 7be232b..08547cf 100644
--- a/Documentation/filesystems/ramfs-rootfs-initramfs.txt
+++ b/Documentation/filesystems/ramfs-rootfs-initramfs.txt
@@ -130,12 +130,11 @@ The 2.6 kernel build process always creates a gzipped cpio format initramfs
 archive and links it into the resulting kernel binary.  By default, this
 archive is empty (consuming 134 bytes on x86).
 
-The config option CONFIG_INITRAMFS_SOURCE (for some reason buried under
-devices->block devices in menuconfig, and living in usr/Kconfig) can be used
-to specify a source for the initramfs archive, which will automatically be
-incorporated into the resulting binary.  This option can point to an existing
-gzipped cpio archive, a directory containing files to be archived, or a text
-file specification such as the following example:
+The config option CONFIG_INITRAMFS_SOURCE can be used to specify a source for
+the initramfs archive, which will automatically be incorporated into the
+resulting binary.  This option can point to an existing gzipped cpio archive, a
+directory containing files to be archived, or a text file specification such as
+the following example:
 
   dir /dev 755 0 0
   nod /dev/console 644 0 0 c 5 1
-- 
1.5.6

