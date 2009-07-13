Return-Path: <linux-kernel-owner+w=401wt.eu-S1755903AbZGMSGx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755903AbZGMSGx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 14:06:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755769AbZGMSGw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 14:06:52 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:57004 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754962AbZGMSGw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 14:06:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:subject;
        b=pF14+nTO6Qwh2nKmAktoCsEp40rLJuh+AyW1sAFDRi4ahuop3Qp7/0G+VYAeK6MSGz
         XlBGauKUM4iIO8SxOePhC7QwUDl8ebFi2nRF/0AfHEcaF0or1Bf+qwxQPkBDhvangLT0
         OXVSklcpLwpxsv4oBryuoW7eF/uFBzaW7rnhQ=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: "Greg Kroah-Hartman" <gregkh@suse.de>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Mon, 13 Jul 2009 20:13:29 +0200
Message-Id: <20090713181329.16765.68428.sendpatchset@localhost.localdomain>
Subject: [PATCH 00/10] Staging: rtl8192su updates
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


- remove some no longer needed files / code
- make private ieee80211 stack really private
- more ifdefs removals
- more preparations for LIBRTL

diffstat:
 b/drivers/staging/rtl8192su/Makefile                         |   15 
 b/drivers/staging/rtl8192su/TODO                             |    5 
 b/drivers/staging/rtl8192su/ieee80211/dot11d.c               |    9 
 b/drivers/staging/rtl8192su/ieee80211/ieee80211.h            | 1000 --
 b/drivers/staging/rtl8192su/ieee80211/ieee80211_crypt.c      |   17 
 b/drivers/staging/rtl8192su/ieee80211/ieee80211_crypt_ccmp.c |   15 
 b/drivers/staging/rtl8192su/ieee80211/ieee80211_crypt_tkip.c |   26 
 b/drivers/staging/rtl8192su/ieee80211/ieee80211_crypt_wep.c  |   13 
 b/drivers/staging/rtl8192su/ieee80211/ieee80211_module.c     |   11 
 b/drivers/staging/rtl8192su/ieee80211/ieee80211_rx.c         |  127 
 b/drivers/staging/rtl8192su/ieee80211/ieee80211_softmac.c    |   22 
 b/drivers/staging/rtl8192su/ieee80211/ieee80211_softmac_wx.c |   19 
 b/drivers/staging/rtl8192su/ieee80211/ieee80211_tx.c         |    3 
 b/drivers/staging/rtl8192su/ieee80211/ieee80211_wx.c         |   70 
 b/drivers/staging/rtl8192su/ieee80211/rtl819x_HTProc.c       |    2 
 b/drivers/staging/rtl8192su/ieee80211/rtl819x_TSProc.c       |    2 
 b/drivers/staging/rtl8192su/r8192S_firmware.c                |    6 
 b/drivers/staging/rtl8192su/r8192S_phy.c                     |   24 
 b/drivers/staging/rtl8192su/r8192U_core.c                    |   68 
 b/drivers/staging/rtl8192su/r8192U_dm.c                      |    1 
 drivers/staging/rtl8192su/r8190_rtl8256.h                    |   27 
 drivers/staging/rtl8192su/r8192S_FwImgDTM.h                  | 3797 -----------
 drivers/staging/rtl8192su/r819xU_firmware_img.c              | 3447 ---------
 drivers/staging/rtl8192su/r819xU_firmware_img.h              |   35 
 24 files changed, 255 insertions(+), 8506 deletions(-)
