Return-Path: <linux-kernel-owner+w=401wt.eu-S1754367AbYLBK4o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754367AbYLBK4o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 05:56:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751437AbYLBK4f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 05:56:35 -0500
Received: from 81-174-11-161.static.ngi.it ([81.174.11.161]:51097 "EHLO
	mail.enneenne.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751261AbYLBK4f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 05:56:35 -0500
From: Rodolfo Giometti <giometti@linux.it>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org,
       Rodolfo Giometti <giometti@linux.it>
Date: Tue,  2 Dec 2008 11:56:06 +0100
Message-Id: <1228215367-22479-1-git-send-email-giometti@linux.it>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <20081201103741.f70cb84c.akpm@linux-foundation.org>
References: <20081201103741.f70cb84c.akpm@linux-foundation.org>
X-SA-Exim-Connect-IP: 192.168.32.254
X-SA-Exim-Mail-From: giometti@enneenne.com
Subject: [PATCH] pps sysfs: not needed variables removed.
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on mail.enneenne.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Rodolfo Giometti <giometti@linux.it>
---
 drivers/pps/sysfs.c |    6 ------
 1 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/drivers/pps/sysfs.c b/drivers/pps/sysfs.c
index 99528a8..7c2b0c4 100644
--- a/drivers/pps/sysfs.c
+++ b/drivers/pps/sysfs.c
@@ -41,7 +41,6 @@ static ssize_t pps_show_assert(struct device *dev,
 			(long long) pps->assert_tu.sec, pps->assert_tu.nsec,
 			pps->assert_sequence);
 }
-DEVICE_ATTR(assert, S_IRUGO, pps_show_assert, NULL);
 
 static ssize_t pps_show_clear(struct device *dev,
 				struct device_attribute *attr, char *buf)
@@ -55,7 +54,6 @@ static ssize_t pps_show_clear(struct device *dev,
 			(long long) pps->clear_tu.sec, pps->clear_tu.nsec,
 			pps->clear_sequence);
 }
-DEVICE_ATTR(clear, S_IRUGO, pps_show_clear, NULL);
 
 static ssize_t pps_show_mode(struct device *dev,
 				struct device_attribute *attr, char *buf)
@@ -64,7 +62,6 @@ static ssize_t pps_show_mode(struct device *dev,
 
 	return sprintf(buf, "%4x\n", pps->info.mode);
 }
-DEVICE_ATTR(mode, S_IRUGO, pps_show_mode, NULL);
 
 static ssize_t pps_show_echo(struct device *dev,
 				struct device_attribute *attr, char *buf)
@@ -73,7 +70,6 @@ static ssize_t pps_show_echo(struct device *dev,
 
 	return sprintf(buf, "%d\n", !!pps->info.echo);
 }
-DEVICE_ATTR(echo, S_IRUGO, pps_show_echo, NULL);
 
 static ssize_t pps_show_name(struct device *dev,
 				struct device_attribute *attr, char *buf)
@@ -82,7 +78,6 @@ static ssize_t pps_show_name(struct device *dev,
 
 	return sprintf(buf, "%s\n", pps->info.name);
 }
-DEVICE_ATTR(name, S_IRUGO, pps_show_name, NULL);
 
 static ssize_t pps_show_path(struct device *dev,
 				struct device_attribute *attr, char *buf)
@@ -91,7 +86,6 @@ static ssize_t pps_show_path(struct device *dev,
 
 	return sprintf(buf, "%s\n", pps->info.path);
 }
-DEVICE_ATTR(path, S_IRUGO, pps_show_path, NULL);
 
 struct device_attribute pps_attrs[] = {
 	__ATTR(assert, S_IRUGO, pps_show_assert, NULL),
-- 
1.5.3.8

