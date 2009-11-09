Return-Path: <linux-kernel-owner+w=401wt.eu-S1756096AbZKIQcs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756096AbZKIQcs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 11:32:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755732AbZKIQcp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 11:32:45 -0500
Received: from mail-ew0-f207.google.com ([209.85.219.207]:42755 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756083AbZKIQcc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 11:32:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:message-id
         :content-type:content-transfer-encoding;
        b=B9RH4uAzJY6Z+vxndvmClQudPdxiKw4CQCN17dsPesQBSm2Uf+UQWv1uN9zo0jdi5u
         n+/sSpqyr2DNAcxoz8mx4NCKxvSIuICqqlJTLWeQGY1ZGJR7n//y2D8Q8hAQbBsOVSQ3
         UltuR9Q0G0qHZh7/D7Nn8NkFJyKcsUl0lsOQY=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Greg KH <gregkh@suse.de>
Subject: [PATCH] Staging: remove rtl8187se driver because of lack of development activities
Date: Mon, 9 Nov 2009 17:31:36 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31.5-96.fc12.x86_64; KDE/4.3.2; x86_64; ; )
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
       linux-wireless@vger.kernel.org
MIME-Version: 1.0
Message-Id: <200911091731.36861.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] Staging: remove rtl8187se driver because of lack of development activities

This driver hasn't seen any real development activities since early July:

   257bc86   Staging: rtl8187se: remove unused #include <linu
   2035beb   param:remove-useless-writable-charp
   305409a   tree-wide: fix some typos and punctuation in com
   b881c6c   Staging: fix wireless drivers depends
   a010a33   Staging: rtl8187se/rtl8192e/rtl8192su: allow mod
   125b181   staging: Add proper selection of WIRELESS_EXT an
   b3184e1   Staging: rtl8187se: Fix comment-out-typo
   b6ac161   Staging: ARRAY_SIZE changes

so remove it for now.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
patch is too big for a mailing list so it can be obtained from:
http://www.kernel.org/pub/linux/kernel/people/bart/staging-remove-rtl8187se-driver-because-of-lack-of-development-activities.patch

 drivers/staging/Kconfig                                    |    2 
 drivers/staging/rtl8187se/Kconfig                          |    7 
 drivers/staging/rtl8187se/Makefile                         |   39 
 drivers/staging/rtl8187se/TODO                             |   14 
 drivers/staging/rtl8187se/ieee80211/dot11d.c               |  224 
 drivers/staging/rtl8187se/ieee80211/dot11d.h               |  100 
 drivers/staging/rtl8187se/ieee80211/ieee80211.h            | 1496 ----
 drivers/staging/rtl8187se/ieee80211/ieee80211_crypt.c      |  247 
 drivers/staging/rtl8187se/ieee80211/ieee80211_crypt.h      |   86 
 drivers/staging/rtl8187se/ieee80211/ieee80211_crypt_ccmp.c |  469 -
 drivers/staging/rtl8187se/ieee80211/ieee80211_crypt_tkip.c |  753 --
 drivers/staging/rtl8187se/ieee80211/ieee80211_crypt_wep.c  |  295 
 drivers/staging/rtl8187se/ieee80211/ieee80211_module.c     |  210 
 drivers/staging/rtl8187se/ieee80211/ieee80211_rx.c         | 1548 ----
 drivers/staging/rtl8187se/ieee80211/ieee80211_softmac.c    | 3008 --------
 drivers/staging/rtl8187se/ieee80211/ieee80211_softmac_wx.c |  572 -
 drivers/staging/rtl8187se/ieee80211/ieee80211_tx.c         |  583 -
 drivers/staging/rtl8187se/ieee80211/ieee80211_wx.c         |  749 --
 drivers/staging/rtl8187se/r8180.h                          |  739 --
 drivers/staging/rtl8187se/r8180_93cx6.c                    |  146 
 drivers/staging/rtl8187se/r8180_93cx6.h                    |   57 
 drivers/staging/rtl8187se/r8180_core.c                     | 4467 -------------
 drivers/staging/rtl8187se/r8180_dm.c                       | 1667 ----
 drivers/staging/rtl8187se/r8180_dm.h                       |   23 
 drivers/staging/rtl8187se/r8180_hw.h                       |  573 -
 drivers/staging/rtl8187se/r8180_rtl8225.h                  |   34 
 drivers/staging/rtl8187se/r8180_rtl8225z2.c                | 1089 ---
 drivers/staging/rtl8187se/r8180_wx.c                       | 1589 ----
 drivers/staging/rtl8187se/r8180_wx.h                       |   21 
 drivers/staging/rtl8187se/r8185b_init.c                    | 2681 -------
 30 files changed, 23488 deletions(-)
