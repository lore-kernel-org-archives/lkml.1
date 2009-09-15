Return-Path: <linux-kernel-owner+w=401wt.eu-S1758617AbZIOTQs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758617AbZIOTQs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 15:16:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758584AbZIOTQq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 15:16:46 -0400
Received: from kroah.org ([198.145.64.141]:33079 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758550AbZIOTPL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 15:15:11 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: GeunSik Lim <leemgs1@gmail.com>, GeunSik Lim <geunsik.lim@samsung.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 19/20] debugfs: Modify default debugfs directory for debugging pktcdvd.
Date: Tue, 15 Sep 2009 12:12:55 -0700
Message-Id: <1253041976-1111-19-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <20090915181247.GA32167@kroah.com>
References: <20090915181247.GA32167@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: GeunSik Lim <leemgs1@gmail.com>

As we all know, We need change default directory for consistency of
debugfs by Greg K-H

Signed-off-by: GeunSik Lim <geunsik.lim@samsung.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
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
1.6.4.2

