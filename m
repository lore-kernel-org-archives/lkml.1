Return-Path: <linux-kernel-owner+w=401wt.eu-S1763608AbYESV4t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763608AbYESV4t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 17:56:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762017AbYESV4F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 17:56:05 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:39776 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761189AbYESVzy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 17:55:54 -0400
Date: Tue, 20 May 2008 00:53:48 +0300
From: Adrian Bunk <bunk@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: trivial@kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: [2.6 patch] drivers/char/rio/: remove VCS tags
Message-ID: <20080519215348.GG17716@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes ancient VCS tags (either protected
by #ifdef SCCS_LABELS or commented out).

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 drivers/char/rio/cirrus.h    |    3 ---
 drivers/char/rio/cmdblk.h    |    6 ------
 drivers/char/rio/cmdpkt.h    |    6 ------
 drivers/char/rio/daemon.h    |    6 ------
 drivers/char/rio/errors.h    |    6 ------
 drivers/char/rio/func.h      |    6 ------
 drivers/char/rio/map.h       |    4 ----
 drivers/char/rio/param.h     |    5 -----
 drivers/char/rio/parmmap.h   |    7 -------
 drivers/char/rio/pci.h       |    4 ----
 drivers/char/rio/protsts.h   |    7 -------
 drivers/char/rio/rio_linux.c |    5 -----
 drivers/char/rio/rioboard.h  |    6 ------
 drivers/char/rio/riocmd.c    |    3 ---
 drivers/char/rio/rioctrl.c   |    4 ----
 drivers/char/rio/riodrvr.h   |    4 ----
 drivers/char/rio/rioinfo.h   |    4 ----
 drivers/char/rio/rioinit.c   |    3 ---
 drivers/char/rio/riointr.c   |    4 ----
 drivers/char/rio/rioparam.c  |    4 ----
 drivers/char/rio/rioroute.c  |    3 ---
 drivers/char/rio/riospace.h  |    4 ----
 drivers/char/rio/riotable.c  |    3 ---
 drivers/char/rio/riotty.c    |    4 ----
 drivers/char/rio/route.h     |    6 ------
 drivers/char/rio/unixrup.h   |    4 ----
 26 files changed, 121 deletions(-)

5822dbd54eed38ec7266caa17e34869e1c89306f diff --git a/drivers/char/rio/cirrus.h b/drivers/char/rio/cirrus.h
index a03a538..5ab5167 100644
--- a/drivers/char/rio/cirrus.h
+++ b/drivers/char/rio/cirrus.h
@@ -35,9 +35,6 @@
  ***************************************************************************/
 
 #ifndef _cirrus_h
-#ifndef lint
-/* static char* _cirrus_h_sccs = "@(#)cirrus.h	1.16"; */
-#endif
 #define _cirrus_h 1
 
 /* Bit fields for particular registers shared with driver */
diff --git a/drivers/char/rio/cmdblk.h b/drivers/char/rio/cmdblk.h
index c46b2fd..9ed4f86 100644
--- a/drivers/char/rio/cmdblk.h
+++ b/drivers/char/rio/cmdblk.h
@@ -33,12 +33,6 @@
 #ifndef __rio_cmdblk_h__
 #define __rio_cmdblk_h__
 
-#ifdef SCCS_LABELS
-#ifndef lint
-static char *_cmdblk_h_sccs_ = "@(#)cmdblk.h	1.2";
-#endif
-#endif
-
 /*
 ** the structure of a command block, used to queue commands destined for
 ** a rup.
diff --git a/drivers/char/rio/cmdpkt.h b/drivers/char/rio/cmdpkt.h
index 357ae57..c1e7a27 100644
--- a/drivers/char/rio/cmdpkt.h
+++ b/drivers/char/rio/cmdpkt.h
@@ -32,12 +32,6 @@
 #ifndef __rio_cmdpkt_h__
 #define __rio_cmdpkt_h__
 
-#ifdef SCCS_LABELS
-#ifndef lint
-static char *_cmdpkt_h_sccs_ = "@(#)cmdpkt.h	1.2";
-#endif
-#endif
-
 /*
 ** overlays for the data area of a packet. Used in both directions
 ** (to build a packet to send, and to interpret a packet that arrives)
diff --git a/drivers/char/rio/daemon.h b/drivers/char/rio/daemon.h
index 6e63f8b..4af9032 100644
--- a/drivers/char/rio/daemon.h
+++ b/drivers/char/rio/daemon.h
@@ -33,12 +33,6 @@
 #ifndef	__rio_daemon_h__
 #define	__rio_daemon_h__
 
-#ifdef SCCS_LABELS
-#ifndef lint
-static char *_daemon_h_sccs_ = "@(#)daemon.h	1.3";
-#endif
-#endif
-
 
 /*
 ** structures used on /dev/rio
diff --git a/drivers/char/rio/errors.h b/drivers/char/rio/errors.h
index 1d0d891..bdb0523 100644
--- a/drivers/char/rio/errors.h
+++ b/drivers/char/rio/errors.h
@@ -33,12 +33,6 @@
 #ifndef	__rio_errors_h__
 #define	__rio_errors_h__
 
-#ifdef SCCS_LABELS
-#ifndef lint
-static char *_errors_h_sccs_ = "@(#)errors.h	1.2";
-#endif
-#endif
-
 /*
 ** error codes
 */
diff --git a/drivers/char/rio/func.h b/drivers/char/rio/func.h
index 9e7283b..078d44f 100644
--- a/drivers/char/rio/func.h
+++ b/drivers/char/rio/func.h
@@ -35,12 +35,6 @@
 
 #include <linux/kdev_t.h>
 
-#ifdef SCCS_LABELS
-#ifndef lint
-static char *_func_h_sccs_ = "@(#)func.h	1.3";
-#endif
-#endif
-
 /* rioboot.c */
 int RIOBootCodeRTA(struct rio_info *, struct DownLoad *);
 int RIOBootCodeHOST(struct rio_info *, struct DownLoad *);
diff --git a/drivers/char/rio/map.h b/drivers/char/rio/map.h
index bdbcd09..8366978 100644
--- a/drivers/char/rio/map.h
+++ b/drivers/char/rio/map.h
@@ -33,10 +33,6 @@
 #ifndef __rio_map_h__
 #define __rio_map_h__
 
-#ifdef SCCS_LABELS
-static char *_map_h_sccs_ = "@(#)map.h	1.2";
-#endif
-
 /*
 ** mapping structure passed to and from the config.rio program to
 ** determine the current topology of the world
diff --git a/drivers/char/rio/param.h b/drivers/char/rio/param.h
index 675c200..7e9b628 100644
--- a/drivers/char/rio/param.h
+++ b/drivers/char/rio/param.h
@@ -33,11 +33,6 @@
 #ifndef __rio_param_h__
 #define __rio_param_h__
 
-#ifdef SCCS_LABELS
-static char *_param_h_sccs_ = "@(#)param.h	1.2";
-#endif
-
-
 /*
 ** the param command block, as used in OPEN and PARAM calls.
 */
diff --git a/drivers/char/rio/parmmap.h b/drivers/char/rio/parmmap.h
index 9764ef8..acc8fa4 100644
--- a/drivers/char/rio/parmmap.h
+++ b/drivers/char/rio/parmmap.h
@@ -37,13 +37,6 @@
 #ifndef _parmap_h
 #define _parmap_h
 
-
-#ifdef SCCS_LABELS
-#ifndef lint
-/* static char *_rio_parmmap_h_sccs = "@(#)parmmap.h	1.4"; */
-#endif
-#endif
-
 typedef struct PARM_MAP PARM_MAP;
 
 struct PARM_MAP {
diff --git a/drivers/char/rio/pci.h b/drivers/char/rio/pci.h
index 1eba911..6032f91 100644
--- a/drivers/char/rio/pci.h
+++ b/drivers/char/rio/pci.h
@@ -33,10 +33,6 @@
 #ifndef __rio_pci_h__
 #define	__rio_pci_h__
 
-#ifdef SCCS_LABELS
-static char *_pci_h_sccs_ = "@(#)pci.h	1.2";
-#endif
-
 /*
 ** PCI stuff
 */
diff --git a/drivers/char/rio/protsts.h b/drivers/char/rio/protsts.h
index 69fc4bc..8ab7940 100644
--- a/drivers/char/rio/protsts.h
+++ b/drivers/char/rio/protsts.h
@@ -37,13 +37,6 @@
 #ifndef _protsts_h
 #define _protsts_h 1
 
-
-#ifdef SCCS_LABELS
-#ifndef lint
-/* static char *_rio_protsts_h_sccs = "@(#)protsts.h	1.4"; */
-#endif
-#endif
-
 /*************************************************
  * ACK bit. Last Packet received OK. Set by
  * rxpkt to indicate that the Packet has been
diff --git a/drivers/char/rio/rio_linux.c b/drivers/char/rio/rio_linux.c
index 412777c..e49e6e6 100644
--- a/drivers/char/rio/rio_linux.c
+++ b/drivers/char/rio/rio_linux.c
@@ -25,11 +25,6 @@
  *      Software Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139,
  *      USA.
  *
- * Revision history:
- * $Log: rio.c,v $
- * Revision 1.1  1999/07/11 10:13:54  wolff
- * Initial revision
- *
  * */
 
 #include <linux/module.h>
diff --git a/drivers/char/rio/rioboard.h b/drivers/char/rio/rioboard.h
index 822c071..2522300 100644
--- a/drivers/char/rio/rioboard.h
+++ b/drivers/char/rio/rioboard.h
@@ -29,12 +29,6 @@
 /*									*/
 /************************************************************************/
 
-/* History...
-
-1.0.0	26/04/99 NPV	Creation.
-
-*/
-
 #ifndef	_rioboard_h		/* If RIOBOARD.H not already defined */
 #define	_rioboard_h    1
 
diff --git a/drivers/char/rio/riocmd.c b/drivers/char/rio/riocmd.c
index 7b96e08..391f0b4 100644
--- a/drivers/char/rio/riocmd.c
+++ b/drivers/char/rio/riocmd.c
@@ -30,9 +30,6 @@
 **
 ** -----------------------------------------------------------------------------
 */
-#ifdef SCCS_LABELS
-static char *_riocmd_c_sccs_ = "@(#)riocmd.c	1.2";
-#endif
 
 #include <linux/module.h>
 #include <linux/slab.h>
diff --git a/drivers/char/rio/rioctrl.c b/drivers/char/rio/rioctrl.c
index d65ceb9..eecee0f 100644
--- a/drivers/char/rio/rioctrl.c
+++ b/drivers/char/rio/rioctrl.c
@@ -29,10 +29,6 @@
 **
 ** -----------------------------------------------------------------------------
 */
-#ifdef SCCS_LABELS
-static char *_rioctrl_c_sccs_ = "@(#)rioctrl.c	1.3";
-#endif
-
 
 #include <linux/module.h>
 #include <linux/slab.h>
diff --git a/drivers/char/rio/riodrvr.h b/drivers/char/rio/riodrvr.h
index 3cffe27..0907e71 100644
--- a/drivers/char/rio/riodrvr.h
+++ b/drivers/char/rio/riodrvr.h
@@ -35,10 +35,6 @@
 
 #include <asm/param.h>		/* for HZ */
 
-#ifdef SCCS_LABELS
-static char *_riodrvr_h_sccs_ = "@(#)riodrvr.h	1.3";
-#endif
-
 #define MEMDUMP_SIZE	32
 #define	MOD_DISABLE	(RIO_NOREAD|RIO_NOWRITE|RIO_NOXPRINT)
 
diff --git a/drivers/char/rio/rioinfo.h b/drivers/char/rio/rioinfo.h
index 8de7966..42ff1e7 100644
--- a/drivers/char/rio/rioinfo.h
+++ b/drivers/char/rio/rioinfo.h
@@ -33,10 +33,6 @@
 #ifndef __rioinfo_h
 #define __rioinfo_h
 
-#ifdef SCCS_LABELS
-static char *_rioinfo_h_sccs_ = "@(#)rioinfo.h	1.2";
-#endif
-
 /*
 ** Host card data structure
 */
diff --git a/drivers/char/rio/rioinit.c b/drivers/char/rio/rioinit.c
index add1718..be0ba40 100644
--- a/drivers/char/rio/rioinit.c
+++ b/drivers/char/rio/rioinit.c
@@ -29,9 +29,6 @@
 **
 ** -----------------------------------------------------------------------------
 */
-#ifdef SCCS_LABELS
-static char *_rioinit_c_sccs_ = "@(#)rioinit.c	1.3";
-#endif
 
 #include <linux/module.h>
 #include <linux/slab.h>
diff --git a/drivers/char/rio/riointr.c b/drivers/char/rio/riointr.c
index ea21686..11c7987 100644
--- a/drivers/char/rio/riointr.c
+++ b/drivers/char/rio/riointr.c
@@ -29,10 +29,6 @@
 **
 ** -----------------------------------------------------------------------------
 */
-#ifdef SCCS_LABELS
-static char *_riointr_c_sccs_ = "@(#)riointr.c	1.2";
-#endif
-
 
 #include <linux/module.h>
 #include <linux/slab.h>
diff --git a/drivers/char/rio/rioparam.c b/drivers/char/rio/rioparam.c
index 4810b84..447ca34 100644
--- a/drivers/char/rio/rioparam.c
+++ b/drivers/char/rio/rioparam.c
@@ -30,10 +30,6 @@
 ** -----------------------------------------------------------------------------
 */
 
-#ifdef SCCS_LABELS
-static char *_rioparam_c_sccs_ = "@(#)rioparam.c	1.3";
-#endif
-
 #include <linux/module.h>
 #include <linux/slab.h>
 #include <linux/errno.h>
diff --git a/drivers/char/rio/rioroute.c b/drivers/char/rio/rioroute.c
index 7a9df7d..706c2a2 100644
--- a/drivers/char/rio/rioroute.c
+++ b/drivers/char/rio/rioroute.c
@@ -29,9 +29,6 @@
 **
 ** -----------------------------------------------------------------------------
 */
-#ifdef SCCS_LABELS
-static char *_rioroute_c_sccs_ = "@(#)rioroute.c	1.3";
-#endif
 
 #include <linux/module.h>
 #include <linux/slab.h>
diff --git a/drivers/char/rio/riospace.h b/drivers/char/rio/riospace.h
index 534f1f5..ffb31d4 100644
--- a/drivers/char/rio/riospace.h
+++ b/drivers/char/rio/riospace.h
@@ -33,10 +33,6 @@
 #ifndef __rio_riospace_h__
 #define __rio_riospace_h__
 
-#ifdef SCCS_LABELS
-static char *_riospace_h_sccs_ = "@(#)riospace.h	1.2";
-#endif
-
 #define	RIO_LOCATOR_LEN	16
 #define	MAX_RIO_BOARDS	4
 
diff --git a/drivers/char/rio/riotable.c b/drivers/char/rio/riotable.c
index 2b24488..3d15802 100644
--- a/drivers/char/rio/riotable.c
+++ b/drivers/char/rio/riotable.c
@@ -29,9 +29,6 @@
 **
 ** -----------------------------------------------------------------------------
 */
-#ifdef SCCS_LABELS
-static char *_riotable_c_sccs_ = "@(#)riotable.c	1.2";
-#endif
 
 #include <linux/module.h>
 #include <linux/slab.h>
diff --git a/drivers/char/rio/riotty.c b/drivers/char/rio/riotty.c
index c993548..95a88a4 100644
--- a/drivers/char/rio/riotty.c
+++ b/drivers/char/rio/riotty.c
@@ -29,10 +29,6 @@
 **
 ** -----------------------------------------------------------------------------
 */
-#ifdef SCCS_LABELS
-static char *_riotty_c_sccs_ = "@(#)riotty.c	1.3";
-#endif
-
 
 #define __EXPLICIT_DEF_H__
 
diff --git a/drivers/char/rio/route.h b/drivers/char/rio/route.h
index 769744e..20ed73f 100644
--- a/drivers/char/rio/route.h
+++ b/drivers/char/rio/route.h
@@ -37,12 +37,6 @@
 #ifndef _route_h
 #define _route_h
 
-#ifdef SCCS_LABELS
-#ifndef lint
-/* static char *_rio_route_h_sccs = "@(#)route.h	1.3"; */
-#endif
-#endif
-
 #define MAX_LINKS 4
 #define MAX_NODES 17		/* Maximum nodes in a subnet */
 #define NODE_BYTES ((MAX_NODES / 8) + 1)	/* Number of bytes needed for
diff --git a/drivers/char/rio/unixrup.h b/drivers/char/rio/unixrup.h
index 46bd532..7abf0cb 100644
--- a/drivers/char/rio/unixrup.h
+++ b/drivers/char/rio/unixrup.h
@@ -33,10 +33,6 @@
 #ifndef __rio_unixrup_h__
 #define __rio_unixrup_h__
 
-#ifdef SCCS_LABELS
-static char *_unixrup_h_sccs_ = "@(#)unixrup.h	1.2";
-#endif
-
 /*
 **    UnixRup data structure. This contains pointers to actual RUPs on the
 **    host card, and all the command/boot control stuff.

