Return-Path: <linux-kernel-owner+w=401wt.eu-S1758858AbZAMFqq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758858AbZAMFqq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 00:46:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752446AbZAMFqg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 00:46:36 -0500
Received: from casper.infradead.org ([85.118.1.10]:54687 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752401AbZAMFqe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 00:46:34 -0500
Subject: [PATCH] found __[us]{8,16,32,64} type without #include
	<linux/types.h>
From: Jaswinder Singh Rajput <jaswinder@infradead.org>
To: Ingo Molnar <mingo@elte.hu>, sam@ravnborg.org, harvey.harrison@gmail.com,
       gorcunov@gmail.com, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 13 Jan 2009 11:14:11 +0530
Message-Id: <1231825452.3212.5.camel@jaswinder.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: fix 52 make headers_check warnings:

 found __[us]{8,16,32,64} type without #include <linux/types.h>

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 include/linux/aio_abi.h        |    1 +
 include/linux/atalk.h          |    1 +
 include/linux/atmbr2684.h      |    1 +
 include/linux/auto_fs4.h       |    1 +
 include/linux/bfs_fs.h         |    2 ++
 include/linux/blktrace_api.h   |    2 ++
 include/linux/cdrom.h          |    1 +
 include/linux/cgroupstats.h    |    1 +
 include/linux/dlm_plock.h      |    2 ++
 include/linux/dn.h             |    2 ++
 include/linux/edd.h            |    2 ++
 include/linux/efs_fs_sb.h      |    1 +
 include/linux/errqueue.h       |    2 ++
 include/linux/genetlink.h      |    1 +
 include/linux/gfs2_ondisk.h    |    2 ++
 include/linux/hiddev.h         |    2 ++
 include/linux/icmpv6.h         |    1 +
 include/linux/if_addr.h        |    1 +
 include/linux/if_addrlabel.h   |    2 ++
 include/linux/if_fc.h          |    1 +
 include/linux/if_hippi.h       |    1 +
 include/linux/if_link.h        |    1 +
 include/linux/if_ppp.h         |    1 +
 include/linux/if_strip.h       |    2 ++
 include/linux/if_tr.h          |    1 +
 include/linux/igmp.h           |    1 +
 include/linux/inet_diag.h      |    2 ++
 include/linux/ip6_tunnel.h     |    2 ++
 include/linux/ipv6.h           |    1 +
 include/linux/ipv6_route.h     |    2 ++
 include/linux/ipx.h            |    1 +
 include/linux/irda.h           |    2 ++
 include/linux/minix_fs.h       |    1 +
 include/linux/msdos_fs.h       |    1 +
 include/linux/neighbour.h      |    1 +
 include/linux/nfs_idmap.h      |    2 ++
 include/linux/nubus.h          |    2 ++
 include/linux/phonet.h         |    2 ++
 include/linux/pkt_cls.h        |    1 +
 include/linux/pkt_sched.h      |    2 ++
 include/linux/ppp_defs.h       |    2 ++
 include/linux/random.h         |    1 +
 include/linux/rtnetlink.h      |    1 +
 include/linux/signalfd.h       |    1 +
 include/linux/synclink.h       |    2 ++
 include/linux/taskstats.h      |    2 ++
 include/linux/video_decoder.h  |    2 ++
 include/linux/video_encoder.h  |    2 ++
 include/linux/videodev.h       |    1 +
 include/linux/virtio_blk.h     |    1 +
 include/linux/virtio_console.h |    2 ++
 include/linux/virtio_net.h     |    2 ++
 52 files changed, 77 insertions(+), 0 deletions(-)

diff --git a/include/linux/aio_abi.h b/include/linux/aio_abi.h
index 9e01729..2c87316 100644
--- a/include/linux/aio_abi.h
+++ b/include/linux/aio_abi.h
@@ -27,6 +27,7 @@
 #ifndef __LINUX__AIO_ABI_H
 #define __LINUX__AIO_ABI_H
 
+#include <linux/types.h>
 #include <asm/byteorder.h>
 
 typedef unsigned long	aio_context_t;
diff --git a/include/linux/atalk.h b/include/linux/atalk.h
index e9ebac2..d34c187 100644
--- a/include/linux/atalk.h
+++ b/include/linux/atalk.h
@@ -1,6 +1,7 @@
 #ifndef __LINUX_ATALK_H__
 #define __LINUX_ATALK_H__
 
+#include <linux/types.h>
 #include <asm/byteorder.h>
 
 /*
diff --git a/include/linux/atmbr2684.h b/include/linux/atmbr2684.h
index 52bf72a..fdb2629 100644
--- a/include/linux/atmbr2684.h
+++ b/include/linux/atmbr2684.h
@@ -1,6 +1,7 @@
 #ifndef _LINUX_ATMBR2684_H
 #define _LINUX_ATMBR2684_H
 
+#include <linux/types.h>
 #include <linux/atm.h>
 #include <linux/if.h>		/* For IFNAMSIZ */
 
diff --git a/include/linux/auto_fs4.h b/include/linux/auto_fs4.h
index 55fa478..2b60077 100644
--- a/include/linux/auto_fs4.h
+++ b/include/linux/auto_fs4.h
@@ -11,6 +11,7 @@
 #ifndef _LINUX_AUTO_FS4_H
 #define _LINUX_AUTO_FS4_H
 
+#include <linux/types.h>
 /* Include common v3 definitions */
 #include <linux/auto_fs.h>
 
diff --git a/include/linux/bfs_fs.h b/include/linux/bfs_fs.h
index 8ed6dfd..2ca3e8f 100644
--- a/include/linux/bfs_fs.h
+++ b/include/linux/bfs_fs.h
@@ -6,6 +6,8 @@
 #ifndef _LINUX_BFS_FS_H
 #define _LINUX_BFS_FS_H
 
+#include <linux/types.h>
+
 #define BFS_BSIZE_BITS		9
 #define BFS_BSIZE		(1<<BFS_BSIZE_BITS)
 
diff --git a/include/linux/blktrace_api.h b/include/linux/blktrace_api.h
index 1dba349..e9ef923 100644
--- a/include/linux/blktrace_api.h
+++ b/include/linux/blktrace_api.h
@@ -6,6 +6,8 @@
 #include <linux/relay.h>
 #endif
 
+#include <linux/types.h>
+
 /*
  * Trace categories
  */
diff --git a/include/linux/cdrom.h b/include/linux/cdrom.h
index 0b49e08..78e9047 100644
--- a/include/linux/cdrom.h
+++ b/include/linux/cdrom.h
@@ -11,6 +11,7 @@
 #ifndef	_LINUX_CDROM_H
 #define	_LINUX_CDROM_H
 
+#include <linux/types.h>
 #include <asm/byteorder.h>
 
 /*******************************************************
diff --git a/include/linux/cgroupstats.h b/include/linux/cgroupstats.h
index 4f53abf..3753c33 100644
--- a/include/linux/cgroupstats.h
+++ b/include/linux/cgroupstats.h
@@ -15,6 +15,7 @@
 #ifndef _LINUX_CGROUPSTATS_H
 #define _LINUX_CGROUPSTATS_H
 
+#include <linux/types.h>
 #include <linux/taskstats.h>
 
 /*
diff --git a/include/linux/dlm_plock.h b/include/linux/dlm_plock.h
index 18d5fdb..2dd2124 100644
--- a/include/linux/dlm_plock.h
+++ b/include/linux/dlm_plock.h
@@ -9,6 +9,8 @@
 #ifndef __DLM_PLOCK_DOT_H__
 #define __DLM_PLOCK_DOT_H__
 
+#include <linux/types.h>
+
 #define DLM_PLOCK_MISC_NAME		"dlm_plock"
 
 #define DLM_PLOCK_VERSION_MAJOR	1
diff --git a/include/linux/dn.h b/include/linux/dn.h
index 02bba04..fe99908 100644
--- a/include/linux/dn.h
+++ b/include/linux/dn.h
@@ -1,6 +1,8 @@
 #ifndef _LINUX_DN_H
 #define _LINUX_DN_H
 
+#include <linux/types.h>
+
 /*
 
 	DECnet Data Structures and Constants
diff --git a/include/linux/edd.h b/include/linux/edd.h
index 5d747c5..4cbd0fe 100644
--- a/include/linux/edd.h
+++ b/include/linux/edd.h
@@ -30,6 +30,8 @@
 #ifndef _LINUX_EDD_H
 #define _LINUX_EDD_H
 
+#include <linux/types.h>
+
 #define EDDNR 0x1e9		/* addr of number of edd_info structs at EDDBUF
 				   in boot_params - treat this as 1 byte  */
 #define EDDBUF	0xd00		/* addr of edd_info structs in boot_params */
diff --git a/include/linux/efs_fs_sb.h b/include/linux/efs_fs_sb.h
index ff1945e..a01be90 100644
--- a/include/linux/efs_fs_sb.h
+++ b/include/linux/efs_fs_sb.h
@@ -9,6 +9,7 @@
 #ifndef __EFS_FS_SB_H__
 #define __EFS_FS_SB_H__
 
+#include <linux/types.h>
 #include <linux/magic.h>
 
 /* EFS superblock magic numbers */
diff --git a/include/linux/errqueue.h b/include/linux/errqueue.h
index 92f8d4f..ceb1454 100644
--- a/include/linux/errqueue.h
+++ b/include/linux/errqueue.h
@@ -1,6 +1,8 @@
 #ifndef _LINUX_ERRQUEUE_H
 #define _LINUX_ERRQUEUE_H 1
 
+#include <linux/types.h>
+
 struct sock_extended_err
 {
 	__u32	ee_errno;	
diff --git a/include/linux/genetlink.h b/include/linux/genetlink.h
index 7da02c9..b834ef6 100644
--- a/include/linux/genetlink.h
+++ b/include/linux/genetlink.h
@@ -1,6 +1,7 @@
 #ifndef __LINUX_GENERIC_NETLINK_H
 #define __LINUX_GENERIC_NETLINK_H
 
+#include <linux/types.h>
 #include <linux/netlink.h>
 
 #define GENL_NAMSIZ	16	/* length of family name */
diff --git a/include/linux/gfs2_ondisk.h b/include/linux/gfs2_ondisk.h
index 14d0df0..c56b4bc 100644
--- a/include/linux/gfs2_ondisk.h
+++ b/include/linux/gfs2_ondisk.h
@@ -10,6 +10,8 @@
 #ifndef __GFS2_ONDISK_DOT_H__
 #define __GFS2_ONDISK_DOT_H__
 
+#include <linux/types.h>
+
 #define GFS2_MAGIC		0x01161970
 #define GFS2_BASIC_BLOCK	512
 #define GFS2_BASIC_BLOCK_SHIFT	9
diff --git a/include/linux/hiddev.h b/include/linux/hiddev.h
index c760ae0..bb6f58b 100644
--- a/include/linux/hiddev.h
+++ b/include/linux/hiddev.h
@@ -27,6 +27,8 @@
  * Vojtech Pavlik, Ucitelska 1576, Prague 8, 182 00 Czech Republic
  */
 
+#include <linux/types.h>
+
 /*
  * The event structure itself
  */
diff --git a/include/linux/icmpv6.h b/include/linux/icmpv6.h
index a93a8dd..10d701e 100644
--- a/include/linux/icmpv6.h
+++ b/include/linux/icmpv6.h
@@ -1,6 +1,7 @@
 #ifndef _LINUX_ICMPV6_H
 #define _LINUX_ICMPV6_H
 
+#include <linux/types.h>
 #include <asm/byteorder.h>
 
 struct icmp6hdr {
diff --git a/include/linux/if_addr.h b/include/linux/if_addr.h
index 43f3bed..a60c821 100644
--- a/include/linux/if_addr.h
+++ b/include/linux/if_addr.h
@@ -1,6 +1,7 @@
 #ifndef __LINUX_IF_ADDR_H
 #define __LINUX_IF_ADDR_H
 
+#include <linux/types.h>
 #include <linux/netlink.h>
 
 struct ifaddrmsg
diff --git a/include/linux/if_addrlabel.h b/include/linux/if_addrlabel.h
index 9fe79c9..89571f6 100644
--- a/include/linux/if_addrlabel.h
+++ b/include/linux/if_addrlabel.h
@@ -10,6 +10,8 @@
 #ifndef __LINUX_IF_ADDRLABEL_H
 #define __LINUX_IF_ADDRLABEL_H
 
+#include <linux/types.h>
+
 struct ifaddrlblmsg
 {
 	__u8		ifal_family;		/* Address family */
diff --git a/include/linux/if_fc.h b/include/linux/if_fc.h
index 376a34e..6ed7f1b 100644
--- a/include/linux/if_fc.h
+++ b/include/linux/if_fc.h
@@ -20,6 +20,7 @@
 #ifndef _LINUX_IF_FC_H
 #define _LINUX_IF_FC_H
 
+#include <linux/types.h>
 
 #define FC_ALEN	6		/* Octets in one ethernet addr	 */
 #define FC_HLEN   (sizeof(struct fch_hdr)+sizeof(struct fcllc))
diff --git a/include/linux/if_hippi.h b/include/linux/if_hippi.h
index f0f2351..4a7c994 100644
--- a/include/linux/if_hippi.h
+++ b/include/linux/if_hippi.h
@@ -22,6 +22,7 @@
 #ifndef _LINUX_IF_HIPPI_H
 #define _LINUX_IF_HIPPI_H
 
+#include <linux/types.h>
 #include <asm/byteorder.h>
 
 /*
diff --git a/include/linux/if_link.h b/include/linux/if_link.h
index f9032c8..176c518 100644
--- a/include/linux/if_link.h
+++ b/include/linux/if_link.h
@@ -1,6 +1,7 @@
 #ifndef _LINUX_IF_LINK_H
 #define _LINUX_IF_LINK_H
 
+#include <linux/types.h>
 #include <linux/netlink.h>
 
 /* The struct should be in sync with struct net_device_stats */
diff --git a/include/linux/if_ppp.h b/include/linux/if_ppp.h
index c3b1f85..047a01c 100644
--- a/include/linux/if_ppp.h
+++ b/include/linux/if_ppp.h
@@ -34,6 +34,7 @@
 #define _IF_PPP_H_
 
 #include <linux/compiler.h>
+#include <linux/types.h>
 
 /*
  * Packet sizes
diff --git a/include/linux/if_strip.h b/include/linux/if_strip.h
index fb5c5c9..6526a62 100644
--- a/include/linux/if_strip.h
+++ b/include/linux/if_strip.h
@@ -18,6 +18,8 @@
 #ifndef __LINUX_STRIP_H
 #define __LINUX_STRIP_H
 
+#include <linux/types.h>
+
 typedef struct {
     __u8 c[6];
 } MetricomAddress;
diff --git a/include/linux/if_tr.h b/include/linux/if_tr.h
index 5bcec8b..fc23aeb 100644
--- a/include/linux/if_tr.h
+++ b/include/linux/if_tr.h
@@ -19,6 +19,7 @@
 #ifndef _LINUX_IF_TR_H
 #define _LINUX_IF_TR_H
 
+#include <linux/types.h>
 #include <asm/byteorder.h>	/* For __be16 */
 
 /* IEEE 802.5 Token-Ring magic constants.  The frame sizes omit the preamble
diff --git a/include/linux/igmp.h b/include/linux/igmp.h
index f734a0b..92fbd8c 100644
--- a/include/linux/igmp.h
+++ b/include/linux/igmp.h
@@ -16,6 +16,7 @@
 #ifndef _LINUX_IGMP_H
 #define _LINUX_IGMP_H
 
+#include <linux/types.h>
 #include <asm/byteorder.h>
 
 /*
diff --git a/include/linux/inet_diag.h b/include/linux/inet_diag.h
index 6e8bc54..bc8c490 100644
--- a/include/linux/inet_diag.h
+++ b/include/linux/inet_diag.h
@@ -1,6 +1,8 @@
 #ifndef _INET_DIAG_H_
 #define _INET_DIAG_H_ 1
 
+#include <linux/types.h>
+
 /* Just some random number */
 #define TCPDIAG_GETSOCK 18
 #define DCCPDIAG_GETSOCK 19
diff --git a/include/linux/ip6_tunnel.h b/include/linux/ip6_tunnel.h
index 1e7cc4a..acb9ad6 100644
--- a/include/linux/ip6_tunnel.h
+++ b/include/linux/ip6_tunnel.h
@@ -1,6 +1,8 @@
 #ifndef _IP6_TUNNEL_H
 #define _IP6_TUNNEL_H
 
+#include <linux/types.h>
+
 #define IPV6_TLV_TNL_ENCAP_LIMIT 4
 #define IPV6_DEFAULT_TNL_ENCAP_LIMIT 4
 
diff --git a/include/linux/ipv6.h b/include/linux/ipv6.h
index 0b816ca..476d946 100644
--- a/include/linux/ipv6.h
+++ b/include/linux/ipv6.h
@@ -1,6 +1,7 @@
 #ifndef _IPV6_H
 #define _IPV6_H
 
+#include <linux/types.h>
 #include <linux/in6.h>
 #include <asm/byteorder.h>
 
diff --git a/include/linux/ipv6_route.h b/include/linux/ipv6_route.h
index b323ff5..1e7d8af 100644
--- a/include/linux/ipv6_route.h
+++ b/include/linux/ipv6_route.h
@@ -13,6 +13,8 @@
 #ifndef _LINUX_IPV6_ROUTE_H
 #define _LINUX_IPV6_ROUTE_H
 
+#include <linux/types.h>
+
 #define RTF_DEFAULT	0x00010000	/* default - learned via ND	*/
 #define RTF_ALLONLINK	0x00020000	/* (deprecated and will be removed)
 					   fallback, no routers on link */
diff --git a/include/linux/ipx.h b/include/linux/ipx.h
index eb19b4e..aabb1d2 100644
--- a/include/linux/ipx.h
+++ b/include/linux/ipx.h
@@ -1,5 +1,6 @@
 #ifndef _IPX_H_
 #define _IPX_H_
+#include <linux/types.h>
 #include <linux/sockios.h>
 #include <linux/socket.h>
 #define IPX_NODE_LEN	6
diff --git a/include/linux/irda.h b/include/linux/irda.h
index 28f88ec..00bdad0 100644
--- a/include/linux/irda.h
+++ b/include/linux/irda.h
@@ -25,6 +25,8 @@
 #ifndef KERNEL_IRDA_H
 #define KERNEL_IRDA_H
 
+#include <linux/types.h>
+
 /* Please do *not* add any #include in this file, this file is
  * included as-is in user space.
  * Please fix the calling file to properly included needed files before
diff --git a/include/linux/minix_fs.h b/include/linux/minix_fs.h
index 0e39745..13fe09e 100644
--- a/include/linux/minix_fs.h
+++ b/include/linux/minix_fs.h
@@ -1,6 +1,7 @@
 #ifndef _LINUX_MINIX_FS_H
 #define _LINUX_MINIX_FS_H
 
+#include <linux/types.h>
 #include <linux/magic.h>
 
 /*
diff --git a/include/linux/msdos_fs.h b/include/linux/msdos_fs.h
index e0a9b20..ce38f1c 100644
--- a/include/linux/msdos_fs.h
+++ b/include/linux/msdos_fs.h
@@ -1,6 +1,7 @@
 #ifndef _LINUX_MSDOS_FS_H
 #define _LINUX_MSDOS_FS_H
 
+#include <linux/types.h>
 #include <linux/magic.h>
 #include <asm/byteorder.h>
 
diff --git a/include/linux/neighbour.h b/include/linux/neighbour.h
index bd3bbf6..8730d5d 100644
--- a/include/linux/neighbour.h
+++ b/include/linux/neighbour.h
@@ -1,6 +1,7 @@
 #ifndef __LINUX_NEIGHBOUR_H
 #define __LINUX_NEIGHBOUR_H
 
+#include <linux/types.h>
 #include <linux/netlink.h>
 
 struct ndmsg
diff --git a/include/linux/nfs_idmap.h b/include/linux/nfs_idmap.h
index 15a9f3b..91a1c24 100644
--- a/include/linux/nfs_idmap.h
+++ b/include/linux/nfs_idmap.h
@@ -37,6 +37,8 @@
 #ifndef NFS_IDMAP_H
 #define NFS_IDMAP_H
 
+#include <linux/types.h>
+
 /* XXX from bits/utmp.h  */
 #define IDMAP_NAMESZ  128
 
diff --git a/include/linux/nubus.h b/include/linux/nubus.h
index c435507..bd31554 100644
--- a/include/linux/nubus.h
+++ b/include/linux/nubus.h
@@ -12,6 +12,8 @@
 #ifndef LINUX_NUBUS_H
 #define LINUX_NUBUS_H
 
+#include <linux/types.h>
+
 #ifdef __KERNEL__
 #include <asm/nubus.h>
 #endif
diff --git a/include/linux/phonet.h b/include/linux/phonet.h
index 4157faa..ee5e3c9 100644
--- a/include/linux/phonet.h
+++ b/include/linux/phonet.h
@@ -23,6 +23,8 @@
 #ifndef LINUX_PHONET_H
 #define LINUX_PHONET_H
 
+#include <linux/types.h>
+
 /* Automatic protocol selection */
 #define PN_PROTO_TRANSPORT	0
 /* Phonet datagram socket */
diff --git a/include/linux/pkt_cls.h b/include/linux/pkt_cls.h
index e6aa848..3c842ed 100644
--- a/include/linux/pkt_cls.h
+++ b/include/linux/pkt_cls.h
@@ -1,6 +1,7 @@
 #ifndef __LINUX_PKT_CLS_H
 #define __LINUX_PKT_CLS_H
 
+#include <linux/types.h>
 #include <linux/pkt_sched.h>
 
 /* I think i could have done better macros ; for now this is stolen from
diff --git a/include/linux/pkt_sched.h b/include/linux/pkt_sched.h
index e3f133a..b2648e8 100644
--- a/include/linux/pkt_sched.h
+++ b/include/linux/pkt_sched.h
@@ -1,6 +1,8 @@
 #ifndef __LINUX_PKT_SCHED_H
 #define __LINUX_PKT_SCHED_H
 
+#include <linux/types.h>
+
 /* Logical priority bands not depending on specific packet scheduler.
    Every scheduler will map them to real traffic classes, if it has
    no more precise mechanism to classify packets.
diff --git a/include/linux/ppp_defs.h b/include/linux/ppp_defs.h
index 6e8adc7..428017e 100644
--- a/include/linux/ppp_defs.h
+++ b/include/linux/ppp_defs.h
@@ -40,6 +40,8 @@
 #ifndef _PPP_DEFS_H_
 #define _PPP_DEFS_H_
 
+#include <linux/types.h>
+
 /*
  * The basic PPP frame.
  */
diff --git a/include/linux/random.h b/include/linux/random.h
index 407ea36..25d02fe 100644
--- a/include/linux/random.h
+++ b/include/linux/random.h
@@ -7,6 +7,7 @@
 #ifndef _LINUX_RANDOM_H
 #define _LINUX_RANDOM_H
 
+#include <linux/types.h>
 #include <linux/ioctl.h>
 #include <linux/irqnr.h>
 
diff --git a/include/linux/rtnetlink.h b/include/linux/rtnetlink.h
index e88f705..1e5f673 100644
--- a/include/linux/rtnetlink.h
+++ b/include/linux/rtnetlink.h
@@ -1,6 +1,7 @@
 #ifndef __LINUX_RTNETLINK_H
 #define __LINUX_RTNETLINK_H
 
+#include <linux/types.h>
 #include <linux/netlink.h>
 #include <linux/if_link.h>
 #include <linux/if_addr.h>
diff --git a/include/linux/signalfd.h b/include/linux/signalfd.h
index bef0c46..b363b91 100644
--- a/include/linux/signalfd.h
+++ b/include/linux/signalfd.h
@@ -8,6 +8,7 @@
 #ifndef _LINUX_SIGNALFD_H
 #define _LINUX_SIGNALFD_H
 
+#include <linux/types.h>
 /* For O_CLOEXEC and O_NONBLOCK */
 #include <linux/fcntl.h>
 
diff --git a/include/linux/synclink.h b/include/linux/synclink.h
index c844a22..99b8bdb 100644
--- a/include/linux/synclink.h
+++ b/include/linux/synclink.h
@@ -13,6 +13,8 @@
 #define _SYNCLINK_H_
 #define SYNCLINK_H_VERSION 3.6
 
+#include <linux/types.h>
+
 #define BIT0	0x0001
 #define BIT1	0x0002
 #define BIT2	0x0004
diff --git a/include/linux/taskstats.h b/include/linux/taskstats.h
index 18269e9..341dddb 100644
--- a/include/linux/taskstats.h
+++ b/include/linux/taskstats.h
@@ -16,6 +16,8 @@
 #ifndef _LINUX_TASKSTATS_H
 #define _LINUX_TASKSTATS_H
 
+#include <linux/types.h>
+
 /* Format for per-task data returned to userland when
  *	- a task exits
  *	- listener requests stats for a task
diff --git a/include/linux/video_decoder.h b/include/linux/video_decoder.h
index 121e26d..e26c0c8 100644
--- a/include/linux/video_decoder.h
+++ b/include/linux/video_decoder.h
@@ -1,6 +1,8 @@
 #ifndef _LINUX_VIDEO_DECODER_H
 #define _LINUX_VIDEO_DECODER_H
 
+#include <linux/types.h>
+
 #define HAVE_VIDEO_DECODER 1
 
 struct video_decoder_capability { /* this name is too long */
diff --git a/include/linux/video_encoder.h b/include/linux/video_encoder.h
index 4b0e690..b7b6423 100644
--- a/include/linux/video_encoder.h
+++ b/include/linux/video_encoder.h
@@ -1,6 +1,8 @@
 #ifndef _LINUX_VIDEO_ENCODER_H
 #define _LINUX_VIDEO_ENCODER_H
 
+#include <linux/types.h>
+
 struct video_encoder_capability { /* this name is too long */
 	__u32	flags;
 #define	VIDEO_ENCODER_PAL	1	/* can encode PAL signal */
diff --git a/include/linux/videodev.h b/include/linux/videodev.h
index 15a653d..837f392 100644
--- a/include/linux/videodev.h
+++ b/include/linux/videodev.h
@@ -12,6 +12,7 @@
 #ifndef __LINUX_VIDEODEV_H
 #define __LINUX_VIDEODEV_H
 
+#include <linux/types.h>
 #include <linux/ioctl.h>
 #include <linux/videodev2.h>
 
diff --git a/include/linux/virtio_blk.h b/include/linux/virtio_blk.h
index c1aef85..596df80 100644
--- a/include/linux/virtio_blk.h
+++ b/include/linux/virtio_blk.h
@@ -3,6 +3,7 @@
 /* This header is BSD licensed so anyone can use the definitions to implement
  * compatible drivers/servers. */
 #include <linux/virtio_config.h>
+#include <linux/types.h>
 
 /* The ID for virtio_block */
 #define VIRTIO_ID_BLOCK	2
diff --git a/include/linux/virtio_console.h b/include/linux/virtio_console.h
index 7615ffc..061c167 100644
--- a/include/linux/virtio_console.h
+++ b/include/linux/virtio_console.h
@@ -4,6 +4,8 @@
 /* This header, excluding the #ifdef __KERNEL__ part, is BSD licensed so
  * anyone can use the definitions to implement compatible drivers/servers. */
 
+#include <linux/types.h>
+
 /* The ID for virtio console */
 #define VIRTIO_ID_CONSOLE	3
 
diff --git a/include/linux/virtio_net.h b/include/linux/virtio_net.h
index 5cdd0aa..cf335fe 100644
--- a/include/linux/virtio_net.h
+++ b/include/linux/virtio_net.h
@@ -4,6 +4,8 @@
  * compatible drivers/servers. */
 #include <linux/virtio_config.h>
 
+#include <linux/types.h>
+
 /* The ID for virtio_net */
 #define VIRTIO_ID_NET	1
 
-- 
1.5.6.6



