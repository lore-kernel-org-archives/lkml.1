Return-Path: <linux-kernel-owner+w=401wt.eu-S1759384AbYDKIIH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759384AbYDKIIH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 04:08:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757799AbYDKIHy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 04:07:54 -0400
Received: from yoi5.greathalifaxhome.com ([66.180.172.116]:36337 "HELO
	vps1.tull.net" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with SMTP
	id S1757561AbYDKIHx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 04:07:53 -0400
X-Spam-Check-By: mail.local.tull.net
From: Nick Andrew <nick@nick-andrew.net>
Subject: [PATCH 2/2] RAID: remove trailing space from printk line
To: mingo@elte.hu, trivial@kernel.org, neilb@suse.de
Cc: <linux-kernel@vger.kernel.org>, akpm@linux-foundation.org
Date: Fri, 11 Apr 2008 18:07:43 +1000
Message-ID: <20080411080743.12362.56864.stgit@marcab.local.tull.net>
In-Reply-To: <20080411080637.12362.47954.stgit@marcab.local.tull.net>
References: <20080411080637.12362.47954.stgit@marcab.local.tull.net>
User-Agent: StGIT/0.14.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-SMTPD: qpsmtpd/0.26, http://develooper.com/code/qpsmtpd/
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

RAID: remove trailing space from printk line

drivers/md/*.[ch] contains only one more printk line with a trailing space.
Remove it.

Signed-off-by: Nick Andrew <nick@nick-andrew.net>
---

 drivers/md/md.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)


diff --git a/drivers/md/md.c b/drivers/md/md.c
index 61ccbd2..5ebfb4d 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -4152,7 +4152,7 @@ static int hot_remove_disk(mddev_t * mddev, dev_t dev)
 
 	return 0;
 busy:
-	printk(KERN_WARNING "md: cannot remove active disk %s from %s ... \n",
+	printk(KERN_WARNING "md: cannot remove active disk %s from %s ...\n",
 		bdevname(rdev->bdev,b), mdname(mddev));
 	return -EBUSY;
 }

