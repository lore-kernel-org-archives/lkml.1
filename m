Return-Path: <linux-kernel-owner+w=401wt.eu-S1755924AbYAYIP2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755924AbYAYIP2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 03:15:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756838AbYAYIAi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 03:00:38 -0500
Received: from mail.suse.de ([195.135.220.2]:59428 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756021AbYAYH7r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 02:59:47 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>
Subject: [PATCH 137/196] driver core: remove owner field from struct bus_type
Date: Thu, 24 Jan 2008 23:32:46 -0800
Message-Id: <1201246425-5058-58-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.3.8
In-Reply-To: <20080125071127.GA4860@kroah.com>
References: <20080125071127.GA4860@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
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
index a3b3ff1..313e0b3 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -51,7 +51,6 @@ extern void bus_remove_file(struct bus_type *, struct bus_attribute *);
 
 struct bus_type {
 	const char		* name;
-	struct module		* owner;
 
 	struct kset		subsys;
 	struct kset		*drivers_kset;
-- 
1.5.3.8

