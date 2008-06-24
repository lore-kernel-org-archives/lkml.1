Return-Path: <linux-kernel-owner+w=401wt.eu-S1758134AbYFXGB7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758134AbYFXGB7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 02:01:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751810AbYFXGBu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 02:01:50 -0400
Received: from mx1.redhat.com ([66.187.233.31]:34329 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751495AbYFXGBu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 02:01:50 -0400
Date: Tue, 24 Jun 2008 02:01:47 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
To: linux-kernel@vger.kernel.org, sparclinux@vger.kernel.org
cc: davem@davemloft.net, Alasdair G Kergon <agk@redhat.com>
Subject: [9/10 PATCH] inline dm-kcopyd-inline-wake.patch
In-Reply-To: <Pine.LNX.4.64.0806240154140.27784@engineering.redhat.com>
Message-ID: <Pine.LNX.4.64.0806240201110.27784@engineering.redhat.com>
References: <Pine.LNX.4.64.0806240136200.27784@engineering.redhat.com>
 <Pine.LNX.4.64.0806240154140.27784@engineering.redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Inline wake. Just passes arguments around.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

Index: linux-2.6.26-rc7-devel/drivers/md/dm-kcopyd.c
===================================================================
--- linux-2.6.26-rc7-devel.orig/drivers/md/dm-kcopyd.c	2008-06-24 07:28:06.000000000 +0200
+++ linux-2.6.26-rc7-devel/drivers/md/dm-kcopyd.c	2008-06-24 07:37:54.000000000 +0200
@@ -61,7 +61,7 @@
  	struct list_head pages_jobs;
  };

-static void wake(struct dm_kcopyd_client *kc)
+static __always_inline void wake(struct dm_kcopyd_client *kc)
  {
  	queue_work(kc->kcopyd_wq, &kc->kcopyd_work);
  }
