Return-Path: <linux-kernel-owner+w=401wt.eu-S933639AbZAROFq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933639AbZAROFq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2009 09:05:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759050AbZAROFg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Jan 2009 09:05:36 -0500
Received: from hera.kernel.org ([140.211.167.34]:36061 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758868AbZAROFf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2009 09:05:35 -0500
Subject: [GIT PULL -tip v3] fix 39 'make headers_check' warnings
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Sam Ravnborg <sam@ravnborg.org>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Sun, 18 Jan 2009 19:34:34 +0530
Message-Id: <1232287474.3130.19.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 (2.24.2-3.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 2a927058df624d1c19bd42a90cb91ae148f12651:
  Ingo Molnar (1):
        Merge branch 'core/header-fixes'

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jaswinder/linux-2.6-tiptop.git master

Jaswinder Singh Rajput (14):
      headers_check fix: linux/atmdev.h
      headers_check fix: linux/cm4000_cs.h
      headers_check fix: linux/elf-fdpic.h
      headers_check fix: linux/elfcore.h
      headers_check fix: linux/fb.h
      headers_check fix: linux/flat.h
      headers_check fix: linux/kernel.h
      headers_check fix: linux/kvm.h
      headers_check fix: linux/pkt_cls.h
      headers_check fix: linux/pktcdvd.h
      headers_check fix: linux/raw.h
      headers_check fix: linux/socket.h
      headers_check fix: linux/sound.h
      headers_check fix: linux/videodev2.h

 include/linux/atmdev.h    |    2 ++
 include/linux/cm4000_cs.h |    2 +-
 include/linux/elf-fdpic.h |    2 ++
 include/linux/elfcore.h   |    2 ++
 include/linux/fb.h        |    4 ++--
 include/linux/flat.h      |    8 +++++---
 include/linux/kernel.h    |    3 ++-
 include/linux/kvm.h       |    8 ++++++++
 include/linux/pkt_cls.h   |    4 ++--
 include/linux/pktcdvd.h   |    2 ++
 include/linux/raw.h       |    2 ++
 include/linux/socket.h    |    3 ++-
 include/linux/sound.h     |    2 ++
 include/linux/videodev2.h |    2 +-
 14 files changed, 35 insertions(+), 11 deletions(-)

This patchset fix the following 'make headers_check' warnings:
/home/jaswinder/jaswinder-git/linux-2.6-tip/usr/include/linux/atmdev.h:103: leaks CONFIG_COMPAT to userspace where it is not valid
/home/jaswinder/jaswinder-git/linux-2.6-tip/usr/include/linux/cm4000_cs.h:22: leaks CONFIG_COMPAT to userspace where it is not valid
/home/jaswinder/jaswinder-git/linux-2.6-tip/usr/include/linux/elf-fdpic.h:61: leaks CONFIG_MMU to userspace where it is not valid
/home/jaswinder/jaswinder-git/linux-2.6-tip/usr/include/linux/elf-fdpic.h:62: extern's make no sense in userspace
/home/jaswinder/jaswinder-git/linux-2.6-tip/usr/include/linux/elfcore.h:59: leaks CONFIG_BINFMT to userspace where it is not valid
/home/jaswinder/jaswinder-git/linux-2.6-tip/usr/include/linux/fb.h:4: include of <linux/types.h> is preferred over <asm/types.h>
/home/jaswinder/jaswinder-git/linux-2.6-tip/usr/include/linux/fb.h:152: found __[us]{8,16,32,64} type without #include <linux/types.h>
/home/jaswinder/jaswinder-git/linux-2.6-tip/usr/include/linux/fb.h:381: leaks CONFIG_FB to userspace where it is not valid
/home/jaswinder/jaswinder-git/linux-2.6-tip/usr/include/linux/flat.h:16: leaks CONFIG_BINFMT to userspace where it is not valid
/home/jaswinder/jaswinder-git/linux-2.6-tip/usr/include/linux/kernel.h:39: leaks CONFIG_NUMA to userspace where it is not valid
/home/jaswinder/jaswinder-git/linux-2.6-tip/usr/include/linux/kernel.h:40: leaks CONFIG_NUMA to userspace where it is not valid
/home/jaswinder/jaswinder-git/linux-2.6-tip/usr/include/linux/kernel.h:46: leaks CONFIG_FTRACE to userspace where it is not valid
/home/jaswinder/jaswinder-git/linux-2.6-tip/usr/include/linux/kernel.h:47: leaks CONFIG_FTRACE to userspace where it is not valid
/home/jaswinder/jaswinder-git/linux-2.6-tip/usr/include/linux/kvm.h:10: include of <linux/types.h> is preferred over <asm/types.h>
/home/jaswinder/jaswinder-git/linux-2.6-tip/usr/include/linux/kvm.h:19: found __[us]{8,16,32,64} type without #include <linux/types.h>
/home/jaswinder/jaswinder-git/linux-2.6-tip/usr/include/linux/kvm.h:61: leaks CONFIG_X86 to userspace where it is not valid
/home/jaswinder/jaswinder-git/linux-2.6-tip/usr/include/linux/kvm.h:64: leaks CONFIG_X86 to userspace where it is not valid
/home/jaswinder/jaswinder-git/linux-2.6-tip/usr/include/linux/kvm.h:387: leaks CONFIG_X86 to userspace where it is not valid
/home/jaswinder/jaswinder-git/linux-2.6-tip/usr/include/linux/kvm.h:391: leaks CONFIG_X86 to userspace where it is not valid
/home/jaswinder/jaswinder-git/linux-2.6-tip/usr/include/linux/kvm.h:396: leaks CONFIG_X86 to userspace where it is not valid
/home/jaswinder/jaswinder-git/linux-2.6-tip/usr/include/linux/pkt_cls.h:122: found __[us]{8,16,32,64} type without #include <linux/types.h>
/home/jaswinder/jaswinder-git/linux-2.6-tip/usr/include/linux/pkt_cls.h:306: leaks CONFIG_NET to userspace where it is not valid
/home/jaswinder/jaswinder-git/linux-2.6-tip/usr/include/linux/pkt_cls.h:307: leaks CONFIG_NET to userspace where it is not valid
/home/jaswinder/jaswinder-git/linux-2.6-tip/usr/include/linux/pktcdvd.h:36: leaks CONFIG_CDROM to userspace where it is not valid
/home/jaswinder/jaswinder-git/linux-2.6-tip/usr/include/linux/ppp_defs.h:50: found __[us]{8,16,32,64} type without #include <linux/types.h>
/home/jaswinder/jaswinder-git/linux-2.6-tip/usr/include/linux/raw.h:16: leaks CONFIG_MAX to userspace where it is not valid
/home/jaswinder/jaswinder-git/linux-2.6-tip/usr/include/linux/socket.h:27: leaks CONFIG_PROC to userspace where it is not valid
/home/jaswinder/jaswinder-git/linux-2.6-tip/usr/include/linux/socket.h:29: extern's make no sense in userspace
/home/jaswinder/jaswinder-git/linux-2.6-tip/usr/include/linux/socket.h:262: leaks CONFIG_COMPAT to userspace where it is not valid
/home/jaswinder/jaswinder-git/linux-2.6-tip/usr/include/linux/sound.h:33: extern's make no sense in userspace
/home/jaswinder/jaswinder-git/linux-2.6-tip/usr/include/linux/sound.h:34: extern's make no sense in userspace
/home/jaswinder/jaswinder-git/linux-2.6-tip/usr/include/linux/sound.h:35: extern's make no sense in userspace
/home/jaswinder/jaswinder-git/linux-2.6-tip/usr/include/linux/sound.h:36: extern's make no sense in userspace
/home/jaswinder/jaswinder-git/linux-2.6-tip/usr/include/linux/sound.h:37: extern's make no sense in userspace
/home/jaswinder/jaswinder-git/linux-2.6-tip/usr/include/linux/sound.h:39: extern's make no sense in userspace
/home/jaswinder/jaswinder-git/linux-2.6-tip/usr/include/linux/sound.h:40: extern's make no sense in userspace
/home/jaswinder/jaswinder-git/linux-2.6-tip/usr/include/linux/sound.h:41: extern's make no sense in userspace
/home/jaswinder/jaswinder-git/linux-2.6-tip/usr/include/linux/sound.h:42: extern's make no sense in userspace
/home/jaswinder/jaswinder-git/linux-2.6-tip/usr/include/linux/videodev2.h:1477: leaks CONFIG_VIDEO to userspace where it is not valid

diff --git a/include/linux/atmdev.h b/include/linux/atmdev.h
index 086e5c3..ec81c12 100644
--- a/include/linux/atmdev.h
+++ b/include/linux/atmdev.h
@@ -100,10 +100,12 @@ struct atm_dev_stats {
 					/* use backend to make new if */
 #define ATM_ADDPARTY  	_IOW('a', ATMIOC_SPECIAL+4,struct atm_iobuf)
  					/* add party to p2mp call */
+#ifdef __KERNEL__
 #ifdef CONFIG_COMPAT
 /* It actually takes struct sockaddr_atmsvc, not struct atm_iobuf */
 #define COMPAT_ATM_ADDPARTY  	_IOW('a', ATMIOC_SPECIAL+4,struct compat_atm_iobuf)
 #endif
+#endif /* __KERNEL__ */
 #define ATM_DROPPARTY 	_IOW('a', ATMIOC_SPECIAL+5,int)
 					/* drop party from p2mp call */
 
diff --git a/include/linux/cm4000_cs.h b/include/linux/cm4000_cs.h
index 605ebe2..cc8b2d9 100644
--- a/include/linux/cm4000_cs.h
+++ b/include/linux/cm4000_cs.h
@@ -19,7 +19,7 @@ typedef struct atreq {
 
 
 /* what is particularly stupid in the original driver is the arch-dependant
- * member sizes. This leads to CONFIG_COMPAT breakage, since 32bit userspace
+ * member sizes. This leads to COMPAT breakage, since 32bit userspace
  * will lay out the structure members differently than the 64bit kernel.
  *
  * I've changed "ptsreq.protocol" from "unsigned long" to "u_int32_t".
diff --git a/include/linux/elf-fdpic.h b/include/linux/elf-fdpic.h
index 9f5b745..7cd2e80 100644
--- a/include/linux/elf-fdpic.h
+++ b/include/linux/elf-fdpic.h
@@ -58,11 +58,13 @@ struct elf_fdpic_params {
 #define ELF_FDPIC_FLAG_PRESENT		0x80000000	/* T if this object is present */
 };
 
+#ifdef __KERNEL__
 #ifdef CONFIG_MMU
 extern void elf_fdpic_arch_lay_out_mm(struct elf_fdpic_params *exec_params,
 				      struct elf_fdpic_params *interp_params,
 				      unsigned long *start_stack,
 				      unsigned long *start_brk);
 #endif
+#endif /* __KERNEL__ */
 
 #endif /* _LINUX_ELF_FDPIC_H */
diff --git a/include/linux/elfcore.h b/include/linux/elfcore.h
index 5ca54d7..69f486d 100644
--- a/include/linux/elfcore.h
+++ b/include/linux/elfcore.h
@@ -64,6 +64,7 @@ struct elf_prstatus
 	long	pr_instr;		/* Current instruction */
 #endif
 	elf_gregset_t pr_reg;	/* GP registers */
+#ifdef __KERNEL__
 #ifdef CONFIG_BINFMT_ELF_FDPIC
 	/* When using FDPIC, the loadmap addresses need to be communicated
 	 * to GDB in order for GDB to do the necessary relocations.  The
@@ -74,6 +75,7 @@ struct elf_prstatus
 	unsigned long pr_exec_fdpic_loadmap;
 	unsigned long pr_interp_fdpic_loadmap;
 #endif
+#endif /* __KERNEL__ */
 	int pr_fpvalid;		/* True if math co-processor being used.  */
 };
 
diff --git a/include/linux/fb.h b/include/linux/fb.h
index 818fe21..abab732 100644
--- a/include/linux/fb.h
+++ b/include/linux/fb.h
@@ -382,14 +382,14 @@ struct fb_cursor {
 	struct fb_image	image;	/* Cursor image */
 };
 
+#ifdef __KERNEL__
+
 #ifdef CONFIG_FB_BACKLIGHT
 /* Settings for the generic backlight code */
 #define FB_BACKLIGHT_LEVELS	128
 #define FB_BACKLIGHT_MAX	0xFF
 #endif
 
-#ifdef __KERNEL__
-
 #include <linux/fs.h>
 #include <linux/init.h>
 #include <linux/device.h>
diff --git a/include/linux/flat.h b/include/linux/flat.h
index ec56852..7a1f69b 100644
--- a/include/linux/flat.h
+++ b/include/linux/flat.h
@@ -10,17 +10,19 @@
 #ifndef _LINUX_FLAT_H
 #define _LINUX_FLAT_H
 
+#define	FLAT_VERSION			0x00000004L
+
 #ifdef __KERNEL__
 #include <asm/flat.h>
-#endif
-
-#define	FLAT_VERSION			0x00000004L
 
 #ifdef CONFIG_BINFMT_SHARED_FLAT
 #define	MAX_SHARED_LIBS			(4)
 #else
 #define	MAX_SHARED_LIBS			(1)
 #endif
+#else /* __KERNEL__ */
+#define	MAX_SHARED_LIBS			(1)
+#endif /* __KERNEL__ */
 
 /*
  * To make everything easier to port and manage cross platform
diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index 343df9e..0fb1505 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -528,6 +528,7 @@ struct sysinfo {
 /* Trap pasters of __FUNCTION__ at compile-time */
 #define __FUNCTION__ (__func__)
 
+#ifdef __KERNEL__
 /* This helps us to avoid #ifdef CONFIG_NUMA */
 #ifdef CONFIG_NUMA
 #define NUMA_BUILD 1
@@ -539,5 +540,5 @@ struct sysinfo {
 #ifdef CONFIG_FTRACE_MCOUNT_RECORD
 # define REBUILD_DUE_TO_FTRACE_MCOUNT_RECORD
 #endif
-
+#endif /* __KERNEL__ */
 #endif
diff --git a/include/linux/kvm.h b/include/linux/kvm.h
index 5715f19..5d004bc 100644
--- a/include/linux/kvm.h
+++ b/include/linux/kvm.h
@@ -58,12 +58,14 @@ struct kvm_irqchip {
 	__u32 pad;
         union {
 		char dummy[512];  /* reserving space */
+#ifdef __KERNEL__
 #ifdef CONFIG_X86
 		struct kvm_pic_state pic;
 #endif
 #if defined(CONFIG_X86) || defined(CONFIG_IA64)
 		struct kvm_ioapic_state ioapic;
 #endif
+#endif /* __KERNEL__ */
 	} chip;
 };
 
@@ -384,18 +386,24 @@ struct kvm_trace_rec {
 #define KVM_CAP_MP_STATE 14
 #define KVM_CAP_COALESCED_MMIO 15
 #define KVM_CAP_SYNC_MMU 16  /* Changes to host mmap are reflected in guest */
+#ifdef __KERNEL__
 #if defined(CONFIG_X86)||defined(CONFIG_IA64)
 #define KVM_CAP_DEVICE_ASSIGNMENT 17
 #endif
+#endif /* __KERNEL__ */
 #define KVM_CAP_IOMMU 18
+#ifdef __KERNEL__
 #if defined(CONFIG_X86)
 #define KVM_CAP_DEVICE_MSI 20
 #endif
+#endif /* __KERNEL__ */
 /* Bug in KVM_SET_USER_MEMORY_REGION fixed: */
 #define KVM_CAP_DESTROY_MEMORY_REGION_WORKS 21
+#ifdef __KERNEL__
 #if defined(CONFIG_X86)
 #define KVM_CAP_USER_NMI 22
 #endif
+#endif /* __KERNEL__ */
 
 /*
  * ioctls for VM fds
diff --git a/include/linux/pkt_cls.h b/include/linux/pkt_cls.h
index 3c842ed..7a45e09 100644
--- a/include/linux/pkt_cls.h
+++ b/include/linux/pkt_cls.h
@@ -304,8 +304,8 @@ enum
 	TCA_FW_UNSPEC,
 	TCA_FW_CLASSID,
 	TCA_FW_POLICE,
-	TCA_FW_INDEV, /*  used by CONFIG_NET_CLS_IND */
-	TCA_FW_ACT, /* used by CONFIG_NET_CLS_ACT */
+	TCA_FW_INDEV,	/* used by NET_CLS_IND */
+	TCA_FW_ACT,	/* used by NET_CLS_ACT */
 	TCA_FW_MASK,
 	__TCA_FW_MAX
 };
diff --git a/include/linux/pktcdvd.h b/include/linux/pktcdvd.h
index 04b4d73..7d1dda5 100644
--- a/include/linux/pktcdvd.h
+++ b/include/linux/pktcdvd.h
@@ -33,11 +33,13 @@
  * able to sucessfully recover with this option (drive will return good
  * status as soon as the cdb is validated).
  */
+#ifdef __KERNEL__
 #if defined(CONFIG_CDROM_PKTCDVD_WCACHE)
 #define USE_WCACHING		1
 #else
 #define USE_WCACHING		0
 #endif
+#endif /* __KERNEL__ */
 
 /*
  * No user-servicable parts beyond this point ->
diff --git a/include/linux/raw.h b/include/linux/raw.h
index 62d543e..2987c21 100644
--- a/include/linux/raw.h
+++ b/include/linux/raw.h
@@ -13,6 +13,8 @@ struct raw_config_request
 	__u64	block_minor;
 };
 
+#ifdef __KERNEL__
 #define MAX_RAW_MINORS CONFIG_MAX_RAW_DEVS
+#endif /* __KERNEL__ */
 
 #endif /* __LINUX_RAW_H */
diff --git a/include/linux/socket.h b/include/linux/socket.h
index f5771a2..602f611 100644
--- a/include/linux/socket.h
+++ b/include/linux/socket.h
@@ -256,12 +256,13 @@ struct ucred {
 #define MSG_CMSG_CLOEXEC 0x40000000	/* Set close_on_exit for file
 					   descriptor received through
 					   SCM_RIGHTS */
+#ifdef __KERNEL__
 #if defined(CONFIG_COMPAT)
 #define MSG_CMSG_COMPAT	0x80000000	/* This message needs 32 bit fixups */
 #else
 #define MSG_CMSG_COMPAT	0		/* We never have 32 bit fixups */
 #endif
-
+#endif /* __KERNEL__ */
 
 /* Setsockoptions(2) level. Thanks to BSD these must match IPPROTO_xxx */
 #define SOL_IP		0
diff --git a/include/linux/sound.h b/include/linux/sound.h
index 9e2a94f..44dcf05 100644
--- a/include/linux/sound.h
+++ b/include/linux/sound.h
@@ -25,6 +25,7 @@
 #define SND_DEV_AMIDI		13	/* Like /dev/midi (obsolete) */
 #define SND_DEV_ADMMIDI		14	/* Like /dev/dmmidi (onsolete) */
 
+#ifdef __KERNEL__
 /*
  *	Sound core interface functions
  */
@@ -40,3 +41,4 @@ extern void unregister_sound_special(int unit);
 extern void unregister_sound_mixer(int unit);
 extern void unregister_sound_midi(int unit);
 extern void unregister_sound_dsp(int unit);
+#endif /* __KERNEL__ */
diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
index 5571dbe..81fa255 100644
--- a/include/linux/videodev2.h
+++ b/include/linux/videodev2.h
@@ -1480,7 +1480,7 @@ struct v4l2_chip_ident_old {
 
 #if 1
 /* Experimental, meant for debugging, testing and internal use.
-   Only implemented if CONFIG_VIDEO_ADV_DEBUG is defined.
+   Only implemented if VIDEO_ADV_DEBUG is defined.
    You must be root to use these ioctls. Never use these in applications! */
 #define	VIDIOC_DBG_S_REGISTER 	 _IOW('V', 79, struct v4l2_dbg_register)
 #define	VIDIOC_DBG_G_REGISTER 	_IOWR('V', 80, struct v4l2_dbg_register)


