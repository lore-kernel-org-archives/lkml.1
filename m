Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030400Ab0B0Q4I (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Feb 2010 11:56:08 -0500
Received: from mail-bw0-f209.google.com ([209.85.218.209]:46242 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030431Ab0B0Qz5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Feb 2010 11:55:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=Gg/4IrtM4tNg65OGhN0gvxTH8i3gMrinZ8aT/qcCMpM2SPxdWPGDRO3mWoOz12VHRG
         VWdlLUXMvtwLrY5j/ATFatIbknXTKr3lYgbfO23obSgb7Lv7GvULYPloT25wbF77GkMI
         aThM5uBgPw7gFAw09BpovtafOVdv6J6FE+wwY=
From: Andrea Gelmini <andrea.gelmini@gelma.net>
To: linux-kernel@vger.kernel.org
Cc: Andrea Gelmini <andrea.gelmini@gelma.net>, Neil Brown <neilb@suse.de>,
       Sandeep K Sinha <sandeepksinha@gmail.com>,
       Christoph Hellwig <hch@lst.de>, linux-raid@vger.kernel.org
Subject: [PATCH 41/66] drivers/md/linear.h: Checkpatch cleanup
Date: Sat, 27 Feb 2010 17:51:22 +0100
Message-Id: <1267289508-31031-42-git-send-email-andrea.gelmini@gelma.net>
X-Mailer: git-send-email 1.7.0.90.g251a4
In-Reply-To: <1267289508-31031-1-git-send-email-andrea.gelmini@gelma.net>
References: <1267289508-31031-1-git-send-email-andrea.gelmini@gelma.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/md/linear.h:12: ERROR: open brace '{' following struct go on the same line

Signed-off-by: Andrea Gelmini <andrea.gelmini@gelma.net>
---
 drivers/md/linear.h |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/md/linear.h b/drivers/md/linear.h
index 0ce29b6..3860fd8 100644
--- a/drivers/md/linear.h
+++ b/drivers/md/linear.h
@@ -8,8 +8,7 @@ struct dev_info {
 
 typedef struct dev_info dev_info_t;
 
-struct linear_private_data
-{
+struct linear_private_data {
 	sector_t		array_sectors;
 	dev_info_t		disks[0];
 	struct rcu_head		rcu;
-- 
1.7.0.90.g251a4

