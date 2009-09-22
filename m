Return-Path: <linux-kernel-owner+w=401wt.eu-S1751787AbZIVSnA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751787AbZIVSnA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 14:43:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751726AbZIVSmx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 14:42:53 -0400
Received: from mail-bw0-f210.google.com ([209.85.218.210]:41365 "EHLO
	mail-bw0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751682AbZIVSmn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 14:42:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=uOQS9Yq8uTl1Tp1DGQxPTjwglV3obkqtsXfE1iDTsjzYuscnNgDw4Oa28jnqCm2lkS
         aNy9mdWjv5tPUIGswnTiKpeZLX1TFJb/Gv5gXltsuPBBukIY2Hmg3WGBmA9364uUjKPu
         EWrghfIdpD5NSgJ/U1a3JY0HxlwK4QO2jE2JY=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: "Greg Kroah-Hartman" <gregkh@suse.de>
Cc: devel@driverdev.osuosl.org, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org
Date: Tue, 22 Sep 2009 20:44:33 +0200
Message-Id: <20090922184433.7695.54192.sendpatchset@localhost.localdomain>
In-Reply-To: <20090922184321.7695.11150.sendpatchset@localhost.localdomain>
References: <20090922184321.7695.11150.sendpatchset@localhost.localdomain>
Subject: [PATCH 8/8] Staging: remove no longer needed rt3090 driver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] Staging: remove no longer needed rt3090 driver

rt2860 handles now all rt2860/rt3090 chipsets.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
The patch itself can be obtained from:

http://www.kernel.org/pub/linux/kernel/people/bart/ralink/staging-remove-no-longer-needed-rt3090-driver.patch

[ it is too big for the mailing list ]

 drivers/staging/Kconfig                          |    2 
 drivers/staging/Makefile                         |    1 
 drivers/staging/rt2860/pci_main_dev.c            |    1 
 drivers/staging/rt3090/Kconfig                   |    5 
 drivers/staging/rt3090/Makefile                  |   80 
 drivers/staging/rt3090/action.h                  |   66 
 drivers/staging/rt3090/ap.h                      |  512 -
 drivers/staging/rt3090/ap_apcli.h                |  276 
 drivers/staging/rt3090/ap_autoChSel.h            |   79 
 drivers/staging/rt3090/ap_autoChSel_cmm.h        |   66 
 drivers/staging/rt3090/ap_cfg.h                  |  118 
 drivers/staging/rt3090/ap_ids.h                  |   82 
 drivers/staging/rt3090/ap_mbss.h                 |   72 
 drivers/staging/rt3090/ap_uapsd.h                |  636 --
 drivers/staging/rt3090/ap_wds.h                  |  212 
 drivers/staging/rt3090/chips/rt3090.c            |  123 
 drivers/staging/rt3090/chips/rt30xx.c            |  525 -
 drivers/staging/rt3090/chips/rt3370.c            |  121 
 drivers/staging/rt3090/chips/rt3390.c            |  122 
 drivers/staging/rt3090/chips/rt33xx.c            |  536 -
 drivers/staging/rt3090/chlist.h                  |  130 
 drivers/staging/rt3090/common/action.c           | 1057 ---
 drivers/staging/rt3090/common/ba_action.c        | 1779 -----
 drivers/staging/rt3090/common/cmm_aes.c          | 1560 -----
 drivers/staging/rt3090/common/cmm_asic.c         | 2753 ---------
 drivers/staging/rt3090/common/cmm_cfg.c          |  295 
 drivers/staging/rt3090/common/cmm_data.c         | 2763 ---------
 drivers/staging/rt3090/common/cmm_data_pci.c     | 1576 -----
 drivers/staging/rt3090/common/cmm_info.c         | 3717 ------------
 drivers/staging/rt3090/common/cmm_mac_pci.c      | 1757 -----
 drivers/staging/rt3090/common/cmm_profile.c      | 2321 -------
 drivers/staging/rt3090/common/cmm_sanity.c       | 1718 -----
 drivers/staging/rt3090/common/cmm_sync.c         |  734 --
 drivers/staging/rt3090/common/cmm_tkip.c         |  966 ---
 drivers/staging/rt3090/common/cmm_wep.c          |  500 -
 drivers/staging/rt3090/common/cmm_wpa.c          | 3149 ----------
 drivers/staging/rt3090/common/crypt_aes.c        | 1007 ---
 drivers/staging/rt3090/common/crypt_biginteger.c | 1119 ---
 drivers/staging/rt3090/common/crypt_dh.c         |  234 
 drivers/staging/rt3090/common/crypt_hmac.c       |  279 
 drivers/staging/rt3090/common/crypt_md5.c        |  353 -
 drivers/staging/rt3090/common/crypt_sha2.c       |  536 -
 drivers/staging/rt3090/common/dfs.c              |  481 -
 drivers/staging/rt3090/common/ee_efuse.c         | 1548 -----
 drivers/staging/rt3090/common/ee_prom.c          |  308 -
 drivers/staging/rt3090/common/eeprom.c           |   98 
 drivers/staging/rt3090/common/igmp_snoop.c       | 1365 ----
 drivers/staging/rt3090/common/mlme.c             | 6550 ---------------------
 drivers/staging/rt3090/common/mlme_ex.c          |  215 
 drivers/staging/rt3090/common/netif_block.c      |  147 
 drivers/staging/rt3090/common/rt_channel.c       | 1287 ----
 drivers/staging/rt3090/common/rt_rf.c            |  201 
 drivers/staging/rt3090/common/rtmp_init.c        | 3882 ------------
 drivers/staging/rt3090/common/rtmp_mcu.c         |  560 -
 drivers/staging/rt3090/common/rtmp_timer.c       |  327 -
 drivers/staging/rt3090/common/spectrum.c         | 2221 -------
 drivers/staging/rt3090/config.mk                 |  187 
 drivers/staging/rt3090/crypt_hmac.h              |   81 
 drivers/staging/rt3090/crypt_md5.h               |   78 
 drivers/staging/rt3090/crypt_sha2.h              |  107 
 drivers/staging/rt3090/dfs.h                     |  137 
 drivers/staging/rt3090/eeprom.h                  |   82 
 drivers/staging/rt3090/igmp_snoop.h              |  152 
 drivers/staging/rt3090/ipv6.h                    |  215 
 drivers/staging/rt3090/link_list.h               |  133 
 drivers/staging/rt3090/mac_pci.h                 |  454 -
 drivers/staging/rt3090/mlme.h                    | 1360 ----
 drivers/staging/rt3090/mlme_ex.h                 |   83 
 drivers/staging/rt3090/mlme_ex_def.h             |   53 
 drivers/staging/rt3090/netif_block.h             |   56 
 drivers/staging/rt3090/oid.h                     | 1015 ---
 drivers/staging/rt3090/pci_main_dev.c            | 1195 ---
 drivers/staging/rt3090/rt3090.h                  |   77 
 drivers/staging/rt3090/rt30xx.h                  |   48 
 drivers/staging/rt3090/rt3370.h                  |   64 
 drivers/staging/rt3090/rt3390.h                  |   77 
 drivers/staging/rt3090/rt33xx.h                  |   48 
 drivers/staging/rt3090/rt_ate.c                  | 6089 --------------------
 drivers/staging/rt3090/rt_ate.h                  |  314 -
 drivers/staging/rt3090/rt_config.h               |  126 
 drivers/staging/rt3090/rt_linux.c                | 1623 -----
 drivers/staging/rt3090/rt_linux.h                | 1034 ---
 drivers/staging/rt3090/rt_main_dev.c             |  897 ---
 drivers/staging/rt3090/rt_pci_rbus.c             |  989 ---
 drivers/staging/rt3090/rt_profile.c              |  101 
 drivers/staging/rt3090/rtmp.h                    | 6873 -----------------------
 drivers/staging/rt3090/rtmp_chip.h               |  355 -
 drivers/staging/rt3090/rtmp_def.h                | 1650 -----
 drivers/staging/rt3090/rtmp_dot11.h              |  146 
 drivers/staging/rt3090/rtmp_iface.h              |   81 
 drivers/staging/rt3090/rtmp_mac.h                | 2304 -------
 drivers/staging/rt3090/rtmp_mcu.h                |   55 
 drivers/staging/rt3090/rtmp_os.h                 |   93 
 drivers/staging/rt3090/rtmp_pci.h                |  110 
 drivers/staging/rt3090/rtmp_phy.h                |  631 --
 drivers/staging/rt3090/rtmp_timer.h              |  162 
 drivers/staging/rt3090/rtmp_type.h               |  147 
 drivers/staging/rt3090/spectrum.h                |  234 
 drivers/staging/rt3090/spectrum_def.h            |  257 
 drivers/staging/rt3090/sta/assoc.c               | 1673 -----
 drivers/staging/rt3090/sta/auth.c                |  491 -
 drivers/staging/rt3090/sta/auth_rsp.c            |  151 
 drivers/staging/rt3090/sta/connect.c             | 2759 ---------
 drivers/staging/rt3090/sta/dls.c                 | 2207 -------
 drivers/staging/rt3090/sta/rtmp_ckipmic.c        |  579 -
 drivers/staging/rt3090/sta/rtmp_data.c           | 2661 --------
 drivers/staging/rt3090/sta/sanity.c              |  382 -
 drivers/staging/rt3090/sta/sync.c                | 1840 ------
 drivers/staging/rt3090/sta/wpa.c                 |  396 -
 drivers/staging/rt3090/sta_ioctl.c               | 4477 --------------
 drivers/staging/rt3090/vr_ikans.h                |   71 
 drivers/staging/rt3090/wpa.h                     |  447 -
 112 files changed, 1 insertion(+), 101234 deletions(-)
