Return-Path: <linux-kernel-owner+w=401wt.eu-S1754769AbYLIQzd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754769AbYLIQzd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 11:55:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753398AbYLIQzZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 11:55:25 -0500
Received: from ey-out-2122.google.com ([74.125.78.26]:64427 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753045AbYLIQzY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 11:55:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=iik5DQtYPr8doaTjCtoGhgQURF/UVzRB5RJmu5WNfVo+RUd6D1M1nXfk6PxPnOOVgW
         8bXh+8i3ZQbLm3qwf5PLQWyhebAJSfS+d5ZsMCEOIsXNvBrXkcNVTj1geTuOBaRb6I0R
         9y89udrULWOzMHz23xgpRw48KNnyMWgRoQBoc=
Message-ID: <493EA2F9.2010408@gmail.com>
Date: Tue, 09 Dec 2008 17:55:21 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081105)
MIME-Version: 1.0
To: Randy Dunlap <rdunlap@xenotime.net>
CC: linux-doc@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/33] Documentation: Make static
References: <493EA286.7080500@gmail.com>
In-Reply-To: <493EA286.7080500@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sparse asked whether these could be static.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
 Documentation/DocBook/procfs_example.c |    2 +-
 Documentation/connector/cn_test.c      |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/DocBook/procfs_example.c b/Documentation/DocBook/procfs_example.c
index 8c6396e..db06753 100644
--- a/Documentation/DocBook/procfs_example.c
+++ b/Documentation/DocBook/procfs_example.c
@@ -54,7 +54,7 @@ static struct proc_dir_entry *example_dir, *foo_file,
 	*bar_file, *jiffies_file, *symlink;
 
 
-struct fb_data_t foo_data, bar_data;
+static struct fb_data_t foo_data, bar_data;
 
 
 static int proc_read_jiffies(char *page, char **start,
diff --git a/Documentation/connector/cn_test.c b/Documentation/connector/cn_test.c
index be7af14..b984b5b 100644
--- a/Documentation/connector/cn_test.c
+++ b/Documentation/connector/cn_test.c
@@ -32,7 +32,7 @@ static char cn_test_name[] = "cn_test";
 static struct sock *nls;
 static struct timer_list cn_test_timer;
 
-void cn_test_callback(void *data)
+static void cn_test_callback(void *data)
 {
 	struct cn_msg *msg = (struct cn_msg *)data;
 
