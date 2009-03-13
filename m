Return-Path: <linux-kernel-owner+w=401wt.eu-S1758928AbZCMIV0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758928AbZCMIV0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 04:21:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757489AbZCMIMg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 04:12:36 -0400
Received: from gw.goop.org ([64.81.55.164]:34832 "EHLO abulafia.goop.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757724AbZCMIMc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 04:12:32 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 24/24] xen/xenbus: export xenbus_dev_changed
Date: Fri, 13 Mar 2009 01:12:00 -0700
Message-Id: <1236931920-6861-25-git-send-email-jeremy@goop.org>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1236931920-6861-1-git-send-email-jeremy@goop.org>
References: <1236931920-6861-1-git-send-email-jeremy@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 drivers/xen/xenbus/xenbus_probe.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/xen/xenbus/xenbus_probe.c b/drivers/xen/xenbus/xenbus_probe.c
index 4649213..d42e25d 100644
--- a/drivers/xen/xenbus/xenbus_probe.c
+++ b/drivers/xen/xenbus/xenbus_probe.c
@@ -660,6 +660,7 @@ void xenbus_dev_changed(const char *node, struct xen_bus_type *bus)
 
 	kfree(root);
 }
+EXPORT_SYMBOL_GPL(xenbus_dev_changed);
 
 static void frontend_changed(struct xenbus_watch *watch,
 			     const char **vec, unsigned int len)
-- 
1.6.0.6

