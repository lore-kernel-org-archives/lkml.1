Return-Path: <linux-kernel-owner+w=401wt.eu-S932219AbYESWSy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932219AbYESWSy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 18:18:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761555AbYESWMH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 18:12:07 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:43222 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761159AbYESWMF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 18:12:05 -0400
Date: Tue, 20 May 2008 01:09:58 +0300
From: Adrian Bunk <bunk@kernel.org>
To: aia21@cantab.net
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] NTFS: update homepage
Message-ID: <20080519220958.GY17716@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch updates the location of the NTFS homepage in several files.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 Documentation/filesystems/ntfs.txt |    4 ++--
 MAINTAINERS                        |    2 +-
 fs/Kconfig                         |    2 +-
 fs/ntfs/usnjrnl.h                  |    4 ++--
 4 files changed, 6 insertions(+), 6 deletions(-)

8853ddf5282c534fa4d187aeaf896c6d4c6baba9 diff --git a/Documentation/filesystems/ntfs.txt b/Documentation/filesystems/ntfs.txt
index e79ee2d..ac2a261 100644
--- a/Documentation/filesystems/ntfs.txt
+++ b/Documentation/filesystems/ntfs.txt
@@ -40,7 +40,7 @@ Web site
 ========
 
 There is plenty of additional information on the linux-ntfs web site
-at http://linux-ntfs.sourceforge.net/
+at http://www.linux-ntfs.org/
 
 The web site has a lot of additional information, such as a comprehensive
 FAQ, documentation on the NTFS on-disk format, information on the Linux-NTFS
@@ -272,7 +272,7 @@ And you would know that /dev/hda2 has a size of 37768814 - 4209030 + 1 =
 For Win2k and later dynamic disks, you can for example use the ldminfo utility
 which is part of the Linux LDM tools (the latest version at the time of
 writing is linux-ldm-0.0.8.tar.bz2).  You can download it from:
-	http://linux-ntfs.sourceforge.net/downloads.html
+	http://www.linux-ntfs.org/
 Simply extract the downloaded archive (tar xvjf linux-ldm-0.0.8.tar.bz2), go
 into it (cd linux-ldm-0.0.8) and change to the test directory (cd test).  You
 will find the precompiled (i386) ldminfo utility there.  NOTE: You will not be
diff --git a/MAINTAINERS b/MAINTAINERS
index 915ad48..8c2db8c 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2998,7 +2998,7 @@ P:	Anton Altaparmakov
 M:	aia21@cantab.net
 L:	linux-ntfs-dev@lists.sourceforge.net
 L:	linux-kernel@vger.kernel.org
-W:	http://linux-ntfs.sf.net/
+W:	http://www.linux-ntfs.org/
 T:	git kernel.org:/pub/scm/linux/kernel/git/aia21/ntfs-2.6.git
 S:	Maintained
 
diff --git a/fs/Kconfig b/fs/Kconfig
index cf12c40..2694648 100644
--- a/fs/Kconfig
+++ b/fs/Kconfig
@@ -830,7 +830,7 @@ config NTFS_FS
 	  from the project web site.
 
 	  For more information see <file:Documentation/filesystems/ntfs.txt>
-	  and <http://linux-ntfs.sourceforge.net/>.
+	  and <http://www.linux-ntfs.org/>.
 
 	  To compile this file system support as a module, choose M here: the
 	  module will be called ntfs.
diff --git a/fs/ntfs/usnjrnl.h b/fs/ntfs/usnjrnl.h
index 3a8af75..4087fbd 100644
--- a/fs/ntfs/usnjrnl.h
+++ b/fs/ntfs/usnjrnl.h
@@ -113,7 +113,7 @@ typedef struct {
  * Reason flags (32-bit).  Cumulative flags describing the change(s) to the
  * file since it was last opened.  I think the names speak for themselves but
  * if you disagree check out the descriptions in the Linux NTFS project NTFS
- * documentation: http://linux-ntfs.sourceforge.net/ntfs/files/usnjrnl.html
+ * documentation: http://www.linux-ntfs.org/
  */
 enum {
 	USN_REASON_DATA_OVERWRITE	= const_cpu_to_le32(0x00000001),
@@ -145,7 +145,7 @@ typedef le32 USN_REASON_FLAGS;
  * Source info flags (32-bit).  Information about the source of the change(s)
  * to the file.  For detailed descriptions of what these mean, see the Linux
  * NTFS project NTFS documentation:
- *	http://linux-ntfs.sourceforge.net/ntfs/files/usnjrnl.html
+ *	http://www.linux-ntfs.org/
  */
 enum {
 	USN_SOURCE_DATA_MANAGEMENT	  = const_cpu_to_le32(0x00000001),

