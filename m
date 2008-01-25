Return-Path: <linux-kernel-owner+w=401wt.eu-S1761822AbYAYHeo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761822AbYAYHeo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 02:34:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758045AbYAYHRq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 02:17:46 -0500
Received: from cantor2.suse.de ([195.135.220.15]:47636 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759262AbYAYHRp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 02:17:45 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>,
       Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Subject: [PATCH 058/196] kset: remove decl_subsys_name
Date: Thu, 24 Jan 2008 23:09:56 -0800
Message-Id: <1201245134-4876-58-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.3.8
In-Reply-To: <20080125071127.GA4860@kroah.com>
References: <20080125071127.GA4860@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
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
index 718b488..390ae14 100644
--- a/include/linux/kobject.h
+++ b/include/linux/kobject.h
@@ -193,11 +193,6 @@ struct kset _name##_subsys = { \
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
1.5.3.8

