Return-Path: <linux-kernel-owner+w=401wt.eu-S1752640AbZIGMjd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752640AbZIGMjd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Sep 2009 08:39:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751659AbZIGMjc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Sep 2009 08:39:32 -0400
Received: from mail-yx0-f175.google.com ([209.85.210.175]:56882 "EHLO
	mail-yx0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751249AbZIGMjc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Sep 2009 08:39:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:content-type:organization:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=pi9OhWAUJJT6bqSdcy3ksc5uaZaunWnK6GlUbOTweFO9Fpdzvd7fxp9PbTOiUUJXef
         TljTPqeseSHVDH3uCEpLXVDt2ktw1apozMIkmASHEJRuGiWZa9uOSKXY/OYWzqy1/ff9
         zAvFl+lpXs6ObTotg3musxXtjRbVZo87rAQpc=
Subject: [PATCH 5/5] debugfs - Modify default debugfs directory for
	debugging pktcdvd.
From: GeunSik Lim <leemgs1@gmail.com>
Reply-To: leemgs1@gmail.com
To: Greg KH <greg@kroah.com>
Cc: balagi@justmail.de, linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Organization: Private
Date: Mon, 07 Sep 2009 21:39:25 +0900
Message-Id: <1252327165.2153.102.camel@centos51>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-40.el5_1.1) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



>From 1a6a1b8d86da5d3e938754f0f4e71aaf7813ef0f Mon Sep 17 00:00:00 2001
From: GeunSik,Lim <leemgs1@gmail.com>
Date: Mon, 7 Sep 2009 20:57:09 +0900
Subject: [PATCH 5/5] Modify default debugfs directory for debugging pktcdvd.

As we all know, We need change default directory for consistency of
debugfs by Greg.K.H

Signed-off-by: GeunSik Lim <geunsik.lim@samsung.com>
---
 drivers/block/pktcdvd.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/block/pktcdvd.c b/drivers/block/pktcdvd.c
index 99a506f..95f11cd 100644
--- a/drivers/block/pktcdvd.c
+++ b/drivers/block/pktcdvd.c
@@ -92,7 +92,7 @@ static struct mutex ctl_mutex;	/* Serialize open/close/setup/teardown */
 static mempool_t *psd_pool;
 
 static struct class	*class_pktcdvd = NULL;    /* /sys/class/pktcdvd */
-static struct dentry	*pkt_debugfs_root = NULL; /* /debug/pktcdvd */
+static struct dentry	*pkt_debugfs_root = NULL; /* /sys/kernel/debug/pktcdvd */
 
 /* forward declaration */
 static int pkt_setup_dev(dev_t dev, dev_t* pkt_dev);
-- 
1.6.3.1


-----------------------------------------------
To unsubscribe from this list: send the line "unsubscribe linux-***" 
in the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
Please read the FAQ at  http://www.tux.org/lkml/

GeunSik Lim ( Samsung Electronics )
e-Mail  :1) geunsik.lim@samsung.com
         2) leemgs@gmail.com , leemgs1@gmail.com
HomePage: http://blog.naver.com/invain/
-----------------------------------------------

