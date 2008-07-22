Return-Path: <linux-kernel-owner+w=401wt.eu-S1759752AbYGVFhx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759752AbYGVFhx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 01:37:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756759AbYGVFYv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 01:24:51 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43232 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756924AbYGVFYu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 01:24:50 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>
Subject: [PATCH 48/79] class: fix docbook comments for class_private structure
Date: Mon, 21 Jul 2008 22:19:12 -0700
Message-Id: <1216703983-21448-48-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <20080722051805.GA17373@suse.de>
References: <20080722051805.GA17373@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removes a field that has been deleted, and adds a description fo the
class_dirs field which was previously undocumented.

Cc: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/base.h |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/base/base.h b/drivers/base/base.h
index 4435732..c035dc2 100644
--- a/drivers/base/base.h
+++ b/drivers/base/base.h
@@ -41,10 +41,9 @@ struct driver_private {
  * struct class_private - structure to hold the private to the driver core portions of the class structure.
  *
  * @class_subsys - the struct kset that defines this class.  This is the main kobject
- * @children - list of class_devices associated with this class
  * @class_devices - list of devices associated with this class
  * @class_interfaces - list of class_interfaces associated with this class
- * @class_dirs -
+ * @class_dirs - "glue" directory for virtual devices associated with this class
  * @class_sem - semaphore to protect the children, devices, and interfaces lists.
  * @class - pointer back to the struct class that this structure is associated
  * with.
-- 
1.5.6.3

