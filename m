Return-Path: <linux-kernel-owner+w=401wt.eu-S1759939AbZBFQbz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759939AbZBFQbz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 11:31:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753048AbZBFQbq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 11:31:46 -0500
Received: from fg-out-1718.google.com ([72.14.220.152]:65363 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752776AbZBFQbp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 11:31:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=Q64bPK9+2BCtgZzStUF16T7ZWEfyUqpQMdjJozUW9uk67gh3cQHlHVhaxyYRHzeEWr
         rgUKHX8sCNhSggjg/vSUqdwfRPezhS4mJG4oHQsTfO+IwfN/rVceHnCVhTowctR8yFQn
         V4q+6Ekysr9Zlk0ucGy/1KPh6Hvjq1YYV9s/E=
From: Philipp Zabel <philipp.zabel@gmail.com>
To: Samuel Ortiz <sameo@openedhand.com>
Cc: linux-kernel@vger.kernel.org, Philipp Zabel <philipp.zabel@gmail.com>
Subject: [PATCH] mfd: DS1WM: remove warning about unused label err2
Date: Fri,  6 Feb 2009 17:31:40 +0100
Message-Id: <1233937900-18710-1-git-send-email-philipp.zabel@gmail.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1233852820-28549-6-git-send-email-philipp.zabel@gmail.com>
References: <1233852820-28549-6-git-send-email-philipp.zabel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Samuel,

thanks for queuing the patchset. Could you please fold this into the DS1WM clock removal patch? 

Signed-off-by: Philipp Zabel <philipp.zabel@gmail.com>
---
 drivers/w1/masters/ds1wm.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/w1/masters/ds1wm.c b/drivers/w1/masters/ds1wm.c
index b982aa6..37f08c8 100644
--- a/drivers/w1/masters/ds1wm.c
+++ b/drivers/w1/masters/ds1wm.c
@@ -387,13 +387,12 @@ static int ds1wm_probe(struct platform_device *pdev)
 
 	ret = w1_add_master_device(&ds1wm_master);
 	if (ret)
-		goto err3;
+		goto err2;
 
 	return 0;
 
-err3:
-	ds1wm_down(ds1wm_data);
 err2:
+	ds1wm_down(ds1wm_data);
 	free_irq(ds1wm_data->irq, ds1wm_data);
 err1:
 	iounmap(ds1wm_data->map);
-- 
1.5.6.5

