Return-Path: <linux-kernel-owner+w=401wt.eu-S1758241AbZCRQ2B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758241AbZCRQ2B (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 12:28:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753827AbZCRQ1v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 12:27:51 -0400
Received: from kroah.org ([198.145.64.141]:42527 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753425AbZCRQ1v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 12:27:51 -0400
Date: Wed, 18 Mar 2009 09:25:29 -0700
From: Greg KH <greg@kroah.com>
To: Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PATCH] STAGING patch for 2.6-git
Message-ID: <20090318162529.GA9560@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here is one staging patch.  Now that the benet network driver is in the
main drivers/net/ directory, the staging version of the driver should be
removed from the tree.  This patch does that, and was acked by the benet
driver author.

Please pull from:
	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/staging-2.6.git/

thanks,

greg k-h

--------------

 drivers/staging/Kconfig                   |    2 -
 drivers/staging/Makefile                  |    1 -
 drivers/staging/benet/Kconfig             |    7 -
 drivers/staging/benet/MAINTAINERS         |    6 -
 drivers/staging/benet/Makefile            |   14 -
 drivers/staging/benet/TODO                |    6 -
 drivers/staging/benet/asyncmesg.h         |   82 --
 drivers/staging/benet/be_cm.h             |  134 ---
 drivers/staging/benet/be_common.h         |   53 --
 drivers/staging/benet/be_ethtool.c        |  348 --------
 drivers/staging/benet/be_init.c           | 1382 -----------------------------
 drivers/staging/benet/be_int.c            |  863 ------------------
 drivers/staging/benet/be_netif.c          |  705 ---------------
 drivers/staging/benet/benet.h             |  429 ---------
 drivers/staging/benet/bestatus.h          |  103 ---
 drivers/staging/benet/cev.h               |  243 -----
 drivers/staging/benet/cq.c                |  211 -----
 drivers/staging/benet/descriptors.h       |   71 --
 drivers/staging/benet/doorbells.h         |  179 ----
 drivers/staging/benet/ep.h                |   66 --
 drivers/staging/benet/eq.c                |  299 -------
 drivers/staging/benet/eth.c               | 1273 --------------------------
 drivers/staging/benet/etx_context.h       |   55 --
 drivers/staging/benet/funcobj.c           |  565 ------------
 drivers/staging/benet/fwcmd_common.h      |  222 -----
 drivers/staging/benet/fwcmd_common_bmap.h |  717 ---------------
 drivers/staging/benet/fwcmd_eth_bmap.h    |  280 ------
 drivers/staging/benet/fwcmd_hdr_bmap.h    |   54 --
 drivers/staging/benet/fwcmd_mcc.h         |   94 --
 drivers/staging/benet/fwcmd_opcodes.h     |  244 -----
 drivers/staging/benet/fwcmd_types_bmap.h  |   29 -
 drivers/staging/benet/host_struct.h       |  182 ----
 drivers/staging/benet/hwlib.h             |  830 -----------------
 drivers/staging/benet/mpu.c               | 1364 ----------------------------
 drivers/staging/benet/mpu.h               |   74 --
 drivers/staging/benet/mpu_context.h       |   46 -
 drivers/staging/benet/pcicfg.h            |  825 -----------------
 drivers/staging/benet/post_codes.h        |  111 ---
 drivers/staging/benet/regmap.h            |   68 --
 39 files changed, 0 insertions(+), 12237 deletions(-)
 delete mode 100644 drivers/staging/benet/Kconfig
 delete mode 100644 drivers/staging/benet/MAINTAINERS
 delete mode 100644 drivers/staging/benet/Makefile
 delete mode 100644 drivers/staging/benet/TODO
 delete mode 100644 drivers/staging/benet/asyncmesg.h
 delete mode 100644 drivers/staging/benet/be_cm.h
 delete mode 100644 drivers/staging/benet/be_common.h
 delete mode 100644 drivers/staging/benet/be_ethtool.c
 delete mode 100644 drivers/staging/benet/be_init.c
 delete mode 100644 drivers/staging/benet/be_int.c
 delete mode 100644 drivers/staging/benet/be_netif.c
 delete mode 100644 drivers/staging/benet/benet.h
 delete mode 100644 drivers/staging/benet/bestatus.h
 delete mode 100644 drivers/staging/benet/cev.h
 delete mode 100644 drivers/staging/benet/cq.c
 delete mode 100644 drivers/staging/benet/descriptors.h
 delete mode 100644 drivers/staging/benet/doorbells.h
 delete mode 100644 drivers/staging/benet/ep.h
 delete mode 100644 drivers/staging/benet/eq.c
 delete mode 100644 drivers/staging/benet/eth.c
 delete mode 100644 drivers/staging/benet/etx_context.h
 delete mode 100644 drivers/staging/benet/funcobj.c
 delete mode 100644 drivers/staging/benet/fwcmd_common.h
 delete mode 100644 drivers/staging/benet/fwcmd_common_bmap.h
 delete mode 100644 drivers/staging/benet/fwcmd_eth_bmap.h
 delete mode 100644 drivers/staging/benet/fwcmd_hdr_bmap.h
 delete mode 100644 drivers/staging/benet/fwcmd_mcc.h
 delete mode 100644 drivers/staging/benet/fwcmd_opcodes.h
 delete mode 100644 drivers/staging/benet/fwcmd_types_bmap.h
 delete mode 100644 drivers/staging/benet/host_struct.h
 delete mode 100644 drivers/staging/benet/hwlib.h
 delete mode 100644 drivers/staging/benet/mpu.c
 delete mode 100644 drivers/staging/benet/mpu.h
 delete mode 100644 drivers/staging/benet/mpu_context.h
 delete mode 100644 drivers/staging/benet/pcicfg.h
 delete mode 100644 drivers/staging/benet/post_codes.h
 delete mode 100644 drivers/staging/benet/regmap.h

---------------

Greg Kroah-Hartman (1):
      Staging: benet: remove driver now that it is merged in drivers/net/

