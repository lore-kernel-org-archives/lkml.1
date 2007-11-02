Return-Path: <linux-kernel-owner+w=401wt.eu-S1763321AbXKCAKO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763321AbXKCAKO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2007 20:10:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756457AbXKCACG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Nov 2007 20:02:06 -0400
Received: from ns.suse.de ([195.135.220.2]:41169 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761599AbXKCACF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2007 20:02:05 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>
Subject: [PATCH 30/54] driver core: remove owner field from struct bus_type
Date: Fri,  2 Nov 2007 16:59:08 -0700
Message-Id: <1194047972-9850-30-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.3.4
In-Reply-To: <20071102235758.GA9803@kroah.com>
References: <20071102235758.GA9803@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This isn't used by anything in the driver core, and by no one in the 204
different usages of it in the kernel tree.  Remove this field so no one
gets any idea that it is needed to be used.

Cc: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 include/linux/device.h |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/include/linux/device.h b/include/linux/device.h
index f6eaa33..a8ffb3a 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -51,7 +51,6 @@ extern void bus_remove_file(struct bus_type *, struct bus_attribute *);
 
 struct bus_type {
 	const char		* name;
-	struct module		* owner;
 
 	struct kset		subsys;
 	struct kset		*drivers_kset;
-- 
1.5.3.4

