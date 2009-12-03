Return-Path: <linux-kernel-owner+w=401wt.eu-S1755234AbZLCXhb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755234AbZLCXhb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 18:37:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753908AbZLCXh1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 18:37:27 -0500
Received: from cobra.newdream.net ([66.33.216.30]:36116 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754461AbZLCXgV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 18:36:21 -0500
From: Sage Weil <sage@newdream.net>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: Sage Weil <sage@newdream.net>
Subject: [PATCH 24/24] ceph: Kconfig, Makefile
Date: Thu,  3 Dec 2009 15:41:31 -0800
Message-Id: <1259883691-1042-25-git-send-email-sage@newdream.net>
X-Mailer: git-send-email 1.6.5
In-Reply-To: <1259883691-1042-24-git-send-email-sage@newdream.net>
References: <1259883691-1042-1-git-send-email-sage@newdream.net>
 <1259883691-1042-2-git-send-email-sage@newdream.net>
 <1259883691-1042-3-git-send-email-sage@newdream.net>
 <1259883691-1042-4-git-send-email-sage@newdream.net>
 <1259883691-1042-5-git-send-email-sage@newdream.net>
 <1259883691-1042-6-git-send-email-sage@newdream.net>
 <1259883691-1042-7-git-send-email-sage@newdream.net>
 <1259883691-1042-8-git-send-email-sage@newdream.net>
 <1259883691-1042-9-git-send-email-sage@newdream.net>
 <1259883691-1042-10-git-send-email-sage@newdream.net>
 <1259883691-1042-11-git-send-email-sage@newdream.net>
 <1259883691-1042-12-git-send-email-sage@newdream.net>
 <1259883691-1042-13-git-send-email-sage@newdream.net>
 <1259883691-1042-14-git-send-email-sage@newdream.net>
 <1259883691-1042-15-git-send-email-sage@newdream.net>
 <1259883691-1042-16-git-send-email-sage@newdream.net>
 <1259883691-1042-17-git-send-email-sage@newdream.net>
 <1259883691-1042-18-git-send-email-sage@newdream.net>
 <1259883691-1042-19-git-send-email-sage@newdream.net>
 <1259883691-1042-20-git-send-email-sage@newdream.net>
 <1259883691-1042-21-git-send-email-sage@newdream.net>
 <1259883691-1042-22-git-send-email-sage@newdream.net>
 <1259883691-1042-23-git-send-email-sage@newdream.net>
 <1259883691-1042-24-git-send-email-sage@newdream.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kconfig options and Makefile.

The README documents files that are synchronized between the user space
and kernel code.

Signed-off-by: Sage Weil <sage@newdream.net>
---
 MAINTAINERS      |    9 +++++++++
 fs/Kconfig       |    1 +
 fs/Makefile      |    1 +
 fs/ceph/Kconfig  |   26 ++++++++++++++++++++++++++
 fs/ceph/Makefile |   37 +++++++++++++++++++++++++++++++++++++
 fs/ceph/README   |   20 ++++++++++++++++++++
 6 files changed, 94 insertions(+), 0 deletions(-)
 create mode 100644 fs/ceph/Kconfig
 create mode 100644 fs/ceph/Makefile
 create mode 100644 fs/ceph/README

diff --git a/MAINTAINERS b/MAINTAINERS
index 4f96ac8..e71c304 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1354,6 +1354,15 @@ F:	arch/powerpc/include/asm/spu*.h
 F:	arch/powerpc/oprofile/*cell*
 F:	arch/powerpc/platforms/cell/
 
+CEPH DISTRIBUTED FILE SYSTEM CLIENT
+M:	Sage Weil <sage@newdream.net>
+L:	ceph-devel@lists.sourceforge.net
+W:	http://ceph.newdream.net/
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/sage/ceph-client.git
+S:	Supported
+F:	Documentation/filesystems/ceph.txt
+F:	fs/ceph
+
 CERTIFIED WIRELESS USB (WUSB) SUBSYSTEM:
 M:	David Vrabel <david.vrabel@csr.com>
 L:	linux-usb@vger.kernel.org
diff --git a/fs/Kconfig b/fs/Kconfig
index 64d44ef..0e0d65d 100644
--- a/fs/Kconfig
+++ b/fs/Kconfig
@@ -234,6 +234,7 @@ config NFS_COMMON
 
 source "net/sunrpc/Kconfig"
 source "fs/smbfs/Kconfig"
+source "fs/ceph/Kconfig"
 source "fs/cifs/Kconfig"
 source "fs/ncpfs/Kconfig"
 source "fs/coda/Kconfig"
diff --git a/fs/Makefile b/fs/Makefile
index af6d047..5ef73a0 100644
--- a/fs/Makefile
+++ b/fs/Makefile
@@ -124,3 +124,4 @@ obj-$(CONFIG_OCFS2_FS)		+= ocfs2/
 obj-$(CONFIG_BTRFS_FS)		+= btrfs/
 obj-$(CONFIG_GFS2_FS)           += gfs2/
 obj-$(CONFIG_EXOFS_FS)          += exofs/
+obj-$(CONFIG_CEPH_FS)		+= ceph/
diff --git a/fs/ceph/Kconfig b/fs/ceph/Kconfig
new file mode 100644
index 0000000..bc1fbd9
--- /dev/null
+++ b/fs/ceph/Kconfig
@@ -0,0 +1,26 @@
+config CEPH_FS
+        tristate "Ceph distributed file system (EXPERIMENTAL)"
+	depends on INET && EXPERIMENTAL
+	select LIBCRC32C
+	help
+	  Choose Y or M here to include support for mounting the
+	  experimental Ceph distributed file system.  Ceph is an extremely
+	  scalable file system designed to provide high performance,
+	  reliable access to petabytes of storage.
+
+	  More information at http://ceph.newdream.net/.
+
+	  If unsure, say N.
+
+config CEPH_FS_PRETTYDEBUG
+	bool "Include file:line in ceph debug output"
+	depends on CEPH_FS
+	default n
+	help
+	  If you say Y here, debug output will include a filename and
+	  line to aid debugging.  This icnreases kernel size and slows
+	  execution slightly when debug call sites are enabled (e.g.,
+	  via CONFIG_DYNAMIC_DEBUG).
+
+	  If unsure, say N.
+
diff --git a/fs/ceph/Makefile b/fs/ceph/Makefile
new file mode 100644
index 0000000..827629c
--- /dev/null
+++ b/fs/ceph/Makefile
@@ -0,0 +1,37 @@
+#
+# Makefile for CEPH filesystem.
+#
+
+ifneq ($(KERNELRELEASE),)
+
+obj-$(CONFIG_CEPH_FS) += ceph.o
+
+ceph-objs := super.o inode.o dir.o file.o addr.o ioctl.o \
+	export.o caps.o snap.o xattr.o \
+	messenger.o msgpool.o buffer.o \
+	mds_client.o mdsmap.o \
+	mon_client.o \
+	osd_client.o osdmap.o crush/crush.o crush/mapper.o crush/hash.o \
+	debugfs.o \
+	auth.o auth_none.o \
+	ceph_fs.o ceph_strings.o ceph_hash.o ceph_frag.o
+
+else
+#Otherwise we were called directly from the command
+# line; invoke the kernel build system.
+
+KERNELDIR ?= /lib/modules/$(shell uname -r)/build
+PWD := $(shell pwd)
+
+default: all
+
+all:
+	$(MAKE) -C $(KERNELDIR) M=$(PWD) CONFIG_CEPH_FS=m modules
+
+modules_install:
+	$(MAKE) -C $(KERNELDIR) M=$(PWD) CONFIG_CEPH_FS=m modules_install
+
+clean:
+	$(MAKE) -C $(KERNELDIR) M=$(PWD) clean
+
+endif
diff --git a/fs/ceph/README b/fs/ceph/README
new file mode 100644
index 0000000..18352fa
--- /dev/null
+++ b/fs/ceph/README
@@ -0,0 +1,20 @@
+#
+# The following files are shared by (and manually synchronized
+# between) the Ceph userland and kernel client.
+#
+# userland                  kernel
+src/include/ceph_fs.h	    fs/ceph/ceph_fs.h
+src/include/ceph_fs.cc	    fs/ceph/ceph_fs.c
+src/include/msgr.h	    fs/ceph/msgr.h
+src/include/rados.h	    fs/ceph/rados.h
+src/include/ceph_strings.cc fs/ceph/ceph_strings.c
+src/include/ceph_frag.h	    fs/ceph/ceph_frag.h
+src/include/ceph_frag.cc    fs/ceph/ceph_frag.c
+src/include/ceph_hash.h	    fs/ceph/ceph_hash.h
+src/include/ceph_hash.cc    fs/ceph/ceph_hash.c
+src/crush/crush.c	    fs/ceph/crush/crush.c
+src/crush/crush.h	    fs/ceph/crush/crush.h
+src/crush/mapper.c	    fs/ceph/crush/mapper.c
+src/crush/mapper.h	    fs/ceph/crush/mapper.h
+src/crush/hash.h	    fs/ceph/crush/hash.h
+src/crush/hash.c	    fs/ceph/crush/hash.c
-- 
1.6.5

