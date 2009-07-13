Return-Path: <linux-kernel-owner+w=401wt.eu-S1755950AbZGMRyg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755950AbZGMRyg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 13:54:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755862AbZGMRyg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 13:54:36 -0400
Received: from mail-bw0-f228.google.com ([209.85.218.228]:60894 "EHLO
	mail-bw0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755856AbZGMRyf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 13:54:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:subject;
        b=uwhtX/btKbCzi/m4c/ds64Bd7Tsu6Uw2qtbRBVu6VWMwS8Ttsu0sx1VQxEHFtKiRpy
         2n6sf2AxWht8hTd8F2FyT9FdfdfJFOe5Hb5vYBcHO/c2/3dtg0SOSUAkEeifUtPccYCe
         TtbVAskEKh/aOjIbIXslDJ1ReWoRjYjScuc44=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: "Greg Kroah-Hartman" <gregkh@suse.de>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Mon, 13 Jul 2009 20:01:12 +0200
Message-Id: <20090713180112.15985.88819.sendpatchset@localhost.localdomain>
Subject: [PATCH 00/10] Stagging: rtl8187se updates
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


- more ifdefs removals
- switch it to use <linux/ieee80211.h>
- more preparations for LIBRTL

diffstat:
 Makefile                         |    2 
 TODO                             |    6 
 ieee80211/ieee80211.h            |  527 ++++++++++++++-------------------------
 ieee80211/ieee80211_crypt_ccmp.c |   15 -
 ieee80211/ieee80211_crypt_tkip.c |   31 --
 ieee80211/ieee80211_crypt_wep.c  |    5 
 ieee80211/ieee80211_rx.c         |  270 ++-----------------
 ieee80211/ieee80211_softmac.c    |   38 --
 ieee80211/ieee80211_tx.c         |   29 --
 ieee80211/ieee80211_wx.c         |    6 
 r8180_core.c                     |    8 
 r8180_wx.c                       |    6 
 r8185b_init.c                    |    2 
 13 files changed, 275 insertions(+), 670 deletions(-)
