Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933190Ab0BFRsQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Feb 2010 12:48:16 -0500
Received: from Cpsmtpm-eml109.kpnxchange.com ([195.121.3.13]:63457 "EHLO
	CPSMTPM-EML109.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932652Ab0BFRrc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Feb 2010 12:47:32 -0500
From: Frans Pop <elendil@planet.nl>
To: linux-kernel@vger.kernel.org
Cc: Frans Pop <elendil@planet.nl>, linux-pm@lists.linux-foundation.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: [PATCH 15/16] PM: remove trailing space in message
Date: Sat,  6 Feb 2010 18:47:22 +0100
Message-Id: <1265478443-31072-15-git-send-email-elendil@planet.nl>
X-Mailer: git-send-email 1.6.6.1
In-Reply-To: <201002061844.45212.elendil@planet.nl>
References: <201002061844.45212.elendil@planet.nl>
X-OriginalArrivalTime: 06 Feb 2010 17:47:26.0899 (UTC) FILETIME=[723A3830:01CAA754]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Frans Pop <elendil@planet.nl>
Cc: linux-pm@lists.linux-foundation.org
Cc: Rafael J. Wysocki <rjw@sisk.pl>
---
 kernel/power/snapshot.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/power/snapshot.c b/kernel/power/snapshot.c
index 36cb168..2eda407 100644
--- a/kernel/power/snapshot.c
+++ b/kernel/power/snapshot.c
@@ -1500,7 +1500,7 @@ asmlinkage int swsusp_save(void)
 {
 	unsigned int nr_pages, nr_highmem;
 
-	printk(KERN_INFO "PM: Creating hibernation image: \n");
+	printk(KERN_INFO "PM: Creating hibernation image:\n");
 
 	drain_local_pages(NULL);
 	nr_pages = count_data_pages();
-- 
1.6.6.1

