Return-Path: <linux-kernel-owner+w=401wt.eu-S1762426AbXKCAFB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762426AbXKCAFB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2007 20:05:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761881AbXKCABH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Nov 2007 20:01:07 -0400
Received: from ns1.suse.de ([195.135.220.2]:41120 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761597AbXKCABF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2007 20:01:05 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>,
       Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Subject: [PATCH 15/54] kset: remove decl_subsys_name
Date: Fri,  2 Nov 2007 16:58:53 -0700
Message-Id: <1194047972-9850-15-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.3.4
In-Reply-To: <20071102235758.GA9803@kroah.com>
References: <20071102235758.GA9803@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The last user of this macro (pci hotplug core) is now switched over to
using a dynamic kset, so this macro is no longer needed at all.

Cc: Kay Sievers <kay.sievers@vrfy.org>
Cc: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 include/linux/kobject.h |    5 -----
 1 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/include/linux/kobject.h b/include/linux/kobject.h
index 205d186..84525a6 100644
--- a/include/linux/kobject.h
+++ b/include/linux/kobject.h
@@ -187,11 +187,6 @@ struct kset _name##_subsys = { \
 	.kobj = { .k_name = __stringify(_name) }, \
 	.uevent_ops =_uevent_ops, \
 }
-#define decl_subsys_name(_varname,_name,_uevent_ops) \
-struct kset _varname##_subsys = { \
-	.kobj = { .k_name = __stringify(_name) }, \
-	.uevent_ops =_uevent_ops, \
-}
 
 /* The global /sys/kernel/ subsystem for people to chain off of */
 extern struct kset kernel_subsys;
-- 
1.5.3.4

