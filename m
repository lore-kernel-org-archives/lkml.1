Return-Path: <linux-kernel-owner+w=401wt.eu-S1755413AbXKST4R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755413AbXKST4R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 14:56:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751118AbXKST4B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 14:56:01 -0500
Received: from astoria.ccjclearline.com ([64.235.106.9]:43125 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751320AbXKST4A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 14:56:00 -0500
Date: Mon, 19 Nov 2007 14:54:09 -0500 (EST)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost.localdomain
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: Andrew Morton <akpm@osdl.org>
Subject: [PATCH] A few corrections to include/linux/Kbuild.
Message-ID: <alpine.LFD.0.9999.0711191451540.29569@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - astoria.ccjclearline.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - crashcourse.ca
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Adjustments:

  auxvec.h, i2c-dev.h and vt.h *should* be unifdef'ed
  i2o-dev.h does not need unifdef'ing

Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>

---

diff --git a/include/linux/Kbuild b/include/linux/Kbuild
index 37bfa19..6a7a525 100644
--- a/include/linux/Kbuild
+++ b/include/linux/Kbuild
@@ -34,7 +34,6 @@ header-y += atmsap.h
 header-y += atmsvc.h
 header-y += atm_zatm.h
 header-y += auto_fs4.h
-header-y += auxvec.h
 header-y += ax25.h
 header-y += b1lli.h
 header-y += baycom.h
@@ -72,7 +71,7 @@ header-y += gen_stats.h
 header-y += gigaset_dev.h
 header-y += hdsmart.h
 header-y += hysdn_if.h
-header-y += i2c-dev.h
+header-y += i2o-dev.h
 header-y += i8k.h
 header-y += if_arcnet.h
 header-y += if_bonding.h
@@ -157,7 +156,6 @@ header-y += utime.h
 header-y += video_decoder.h
 header-y += video_encoder.h
 header-y += videotext.h
-header-y += vt.h
 header-y += x25.h

 unifdef-y += acct.h
@@ -172,6 +170,7 @@ unifdef-y += atm.h
 unifdef-y += atm_tcp.h
 unifdef-y += audit.h
 unifdef-y += auto_fs.h
+unifdef-y += auxvec.h
 unifdef-y += binfmts.h
 unifdef-y += capability.h
 unifdef-y += capi.h
@@ -213,7 +212,7 @@ unifdef-y += hdreg.h
 unifdef-y += hiddev.h
 unifdef-y += hpet.h
 unifdef-y += i2c.h
-unifdef-y += i2o-dev.h
+unifdef-y += i2c-dev.h
 unifdef-y += icmp.h
 unifdef-y += icmpv6.h
 unifdef-y += if_addr.h
@@ -348,6 +347,7 @@ unifdef-y += videodev.h
 unifdef-y += virtio_config.h
 unifdef-y += virtio_blk.h
 unifdef-y += virtio_net.h
+unifdef-y += vt.h
 unifdef-y += wait.h
 unifdef-y += wanrouter.h
 unifdef-y += watchdog.h
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://crashcourse.ca
========================================================================
