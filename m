Return-Path: <linux-kernel-owner+w=401wt.eu-S932904AbZDHLqJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932904AbZDHLqJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 07:46:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932246AbZDHL2U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 07:28:20 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:49358 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932188AbZDHL2A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 07:28:00 -0400
X-Sasl-enc: LqMATEFZZMuHvVmmuZqG66qGX7M6YwZzOfHRDm/3FdQY 1239190079
From: Jack Stone <jwjstone@fastmail.fm>
To: linux-kernel@vger.kernel.org
Cc: jeff@garzik.org, kernel-janitors@vger.kernel.org,
       Jack Stone <jwjstone@fastmail.fm>
Subject: [PATCH 55/56] xen: Remove void casts
Date: Wed,  8 Apr 2009 12:22:27 +0100
Message-Id: <1239189748-11703-56-git-send-email-jwjstone@fastmail.fm>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <1239189748-11703-55-git-send-email-jwjstone@fastmail.fm>
References: <>
 <1239189748-11703-1-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-2-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-3-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-4-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-5-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-6-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-7-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-8-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-9-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-10-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-11-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-12-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-13-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-14-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-15-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-16-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-17-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-18-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-19-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-20-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-21-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-22-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-23-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-24-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-25-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-26-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-27-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-28-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-29-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-30-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-31-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-32-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-33-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-34-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-35-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-36-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-37-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-38-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-39-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-40-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-41-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-42-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-43-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-44-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-45-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-46-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-47-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-48-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-49-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-50-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-51-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-52-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-53-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-54-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-55-git-send-email-jwjstone@fastmail.fm>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove uneeded void casts

Signed-Off-By: Jack Stone <jwjstone@fastmail.fm>
---
 drivers/xen/manage.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/xen/manage.c b/drivers/xen/manage.c
index 0d61db1..89310fb 100644
--- a/drivers/xen/manage.c
+++ b/drivers/xen/manage.c
@@ -149,7 +149,7 @@ static void shutdown_handler(struct xenbus_watch *watch,
 	if (err)
 		return;
 
-	str = (char *)xenbus_read(xbt, "control", "shutdown", NULL);
+	str = xenbus_read(xbt, "control", "shutdown", NULL);
 	/* Ignore read errors and empty reads. */
 	if (XENBUS_IS_ERR_READ(str)) {
 		xenbus_transaction_end(xbt, 1);
-- 
1.5.4.3

