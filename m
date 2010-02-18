Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758611Ab0BRP7z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 10:59:55 -0500
Received: from www.linuxtv.org ([130.149.80.248]:42278 "EHLO www.linuxtv.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758565Ab0BRP7a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Feb 2010 10:59:30 -0500
Subject: [git:v4l-dvb/master] V4L/DVB: tm6000: fix mutex lock unbalance
From: Patch from Mauro Carvalho Chehab 
	<linuxtv-commits-bounces@linuxtv.org>
To: linuxtv-commits@linuxtv.org
Data: Fri, 12 Feb 2010 03:52:46 -0300
Cc: Mocean Laboratories <info@mocean-labs.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Mauro Carvalho Chehab <mchehab@redhat.com>,
       linux-kernel@vger.kernel.org, Kang Yong <kangyong@telegent.com>,
       Huang Shijie <shijie8@gmail.com>, Zhang Xiaobing <xbzhang@telegent.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Mauro Carvalho Chehab <mchehab@redhat.com>,
       Richard Rojfors <richard.rojfors@pelagicore.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Samuel Ortiz <sameo@linux.intel.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Mauro Carvalho Chehab <mchehab@redhat.com>,
       Mauro Carvalho Chehab <mchehab@redhat.com>
Mail-followup-to: linux-media@vger.kernel.org
Forward-to: linux-media@vger.kernel.org
Reply-to: linux-media@vger.kernel.org
Message-Id: <E1Ni8UK-000878-66@www.linuxtv.org>
Date: Thu, 18 Feb 2010 16:40:24 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mauro Carvalho Chehab <mchehab@redhat.com>

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

 drivers/staging/tm6000/tm6000-cards.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

---

http://git.linuxtv.org/v4l-dvb.git?a=commit;h=955ac2240299dca3b878a4a19e72cd7463f996b0

diff --git a/drivers/staging/tm6000/tm6000-cards.c b/drivers/staging/tm6000/tm6000-cards.c
index 8297801..c0159a1 100644
--- a/drivers/staging/tm6000/tm6000-cards.c
+++ b/drivers/staging/tm6000/tm6000-cards.c
@@ -496,6 +496,7 @@ static int tm6000_init_dev(struct tm6000_core *dev)
 		}
 #endif
 	}
+	mutex_unlock(&dev->lock);
 	return 0;
 
 err2:
