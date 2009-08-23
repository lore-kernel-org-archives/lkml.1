Return-Path: <linux-kernel-owner+w=401wt.eu-S933954AbZHWN3r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933954AbZHWN3r (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Aug 2009 09:29:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933937AbZHWN3p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Aug 2009 09:29:45 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:49132 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933881AbZHWN3l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Aug 2009 09:29:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=LQDSzDcrfyTxqLgDweThM6sRZH2oudfkLdTJXPMZgJz6GaVfBtAJmxsdmkwVz18A0K
         HzmDeQYrcNQ1gcNIwL+alWFpGgWZ6lvNHqaAB5jxESWjpR9mvHEPAvtePCKuLvorGMlJ
         K7+79JC+5ACOhXOwEiPX3umx3azuAPkFmzCUE=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: "Greg Kroah-Hartman" <gregkh@suse.de>
Cc: devel@driverdev.osuosl.org, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Marcin Slusarz <marcin.slusarz@gmail.com>,
       Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org
Date: Sun, 23 Aug 2009 15:30:11 +0200
Message-Id: <20090823133011.17784.65671.sendpatchset@localhost.localdomain>
In-Reply-To: <20090823132846.17784.13359.sendpatchset@localhost.localdomain>
References: <20090823132846.17784.13359.sendpatchset@localhost.localdomain>
Subject: [PATCH 13/33] Staging: rt28x0: add SIOCGIWNAME support to rt_ioctl_giwscan()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] Staging: rt28x0: add SIOCGIWNAME support to rt_ioctl_giwscan()

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/staging/rt2860/sta_ioctl.c |    2 --
 1 file changed, 2 deletions(-)

Index: b/drivers/staging/rt2860/sta_ioctl.c
===================================================================
--- a/drivers/staging/rt2860/sta_ioctl.c
+++ b/drivers/staging/rt2860/sta_ioctl.c
@@ -979,7 +979,6 @@ int rt_ioctl_giwscan(struct net_device *
 
         previous_ev = current_ev;
 		current_ev = iwe_stream_add_event(info, current_ev,end_buf, &iwe, IW_EV_ADDR_LEN);
-#ifdef RT30xx
         if (current_ev == previous_ev)
 		return -E2BIG;
 
@@ -1055,7 +1054,6 @@ int rt_ioctl_giwscan(struct net_device *
 
 		previous_ev = current_ev;
 		current_ev	 = iwe_stream_add_event(info, current_ev, end_buf, &iwe, IW_EV_ADDR_LEN);
-#endif /* RT30xx */
         if (current_ev == previous_ev)
 		return -E2BIG;
 
