Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932733Ab0BENtp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Feb 2010 08:49:45 -0500
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:58809 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755482Ab0BENto (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Feb 2010 08:49:44 -0500
Date: Fri, 5 Feb 2010 14:49:58 +0100
From: Christoph Egger <siccegge@stud.informatik.uni-erlangen.de>
To: linux-kernel@vger.kernel.org
Cc: vamos@i4.informatik.uni-erlangen.de
Subject: [PATCH] obsolete config in kernel source (SA1100_CT6001)
Message-ID: <20100205134958.GD7077@faui49.informatik.uni-erlangen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all!

	As part of the VAMOS[0] research project at the University of
Erlangen we're checking referential integrity between kernel KConfig
options and in-code Conditional blocks.

	This is another small block of Code depending on a COnfig Item
that can't ever be set because it doesn't exist on the kconfig side
(looks removed to me). Please consider getting rid of it.

	Please keep me informed of this patch getting confirmed /
merged so we can keep track of it.

Regards

	Christoph Egger

[0] http://vamos1.informatik.uni-erlangen.de/

----
>From d401b4f449d52dae984788b0995061e9841e1b54 Mon Sep 17 00:00:00 2001
From: Christoph Egger <siccegge@stud.informatik.uni-erlangen.de>
Date: Fri, 5 Feb 2010 14:02:34 +0100
Subject: [PATCH] Remove CONFIG_SA1100_CT6001

The SA1100_CT6001 needed special-casing because of being a 8bit
devince on a 16bit bus. However this piece of hardware is no longer
available in the linux kernel so the special case can go as well

Signed-off-by: Christoph Egger <siccegge@stud.informatik.uni-erlangen.de>
---
 include/linux/com20020.h |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/include/linux/com20020.h b/include/linux/com20020.h
index 5dcfb94..bed9de6 100644
--- a/include/linux/com20020.h
+++ b/include/linux/com20020.h
@@ -35,11 +35,7 @@ extern const struct net_device_ops com20020_netdev_ops;
 #define ARCNET_TOTAL_SIZE 8
 
 /* various register addresses */
-#ifdef CONFIG_SA1100_CT6001
-#define BUS_ALIGN  2  /* 8 bit device on a 16 bit bus - needs padding */
-#else
 #define BUS_ALIGN  1
-#endif
 
 
 #define _INTMASK  (ioaddr+BUS_ALIGN*0)	/* writable */
-- 
1.6.3.3





