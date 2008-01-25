Return-Path: <linux-kernel-owner+w=401wt.eu-S1758955AbYAYHST@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758955AbYAYHST (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 02:18:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754020AbYAYHOl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 02:14:41 -0500
Received: from mx1.suse.de ([195.135.220.2]:52454 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757967AbYAYHOk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 02:14:40 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>
Subject: [PATCH 014/196] kobject: remove incorrect comment in kobject_rename
Date: Thu, 24 Jan 2008 23:09:12 -0800
Message-Id: <1201245134-4876-14-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.3.8
In-Reply-To: <20080125071127.GA4860@kroah.com>
References: <20080125071127.GA4860@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As pointed out by Kay.

Cc: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 lib/kobject.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/lib/kobject.c b/lib/kobject.c
index 3590f02..9500339 100644
--- a/lib/kobject.c
+++ b/lib/kobject.c
@@ -334,8 +334,6 @@ int kobject_rename(struct kobject * kobj, const char *new_name)
 	sprintf(devpath_string, "DEVPATH_OLD=%s", devpath);
 	envp[0] = devpath_string;
 	envp[1] = NULL;
-	/* Note : if we want to send the new name alone, not the full path,
-	 * we could probably use kobject_name(kobj); */
 
 	error = sysfs_rename_dir(kobj, new_name);
 
-- 
1.5.3.8

