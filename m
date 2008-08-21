Return-Path: <linux-kernel-owner+w=401wt.eu-S1758746AbYHUDWx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758746AbYHUDWx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 23:22:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756003AbYHUDQj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 23:16:39 -0400
Received: from 166-70-238-42.ip.xmission.com ([166.70.238.42]:50104 "EHLO
	ns1.wolfmountaingroup.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755498AbYHUDQI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 23:16:08 -0400
Date: Wed, 20 Aug 2008 20:50:36 -0600
From: jmerkey@wolfmountaingroup.com
Message-Id: <200808210250.m7L2oaMo028342@wolfmountaingroup.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 2.6.27-rc4 20/27] mdb: export kmsg_redirect printk for console redirection 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

export kmsg_redirect printk for console redirection 


Signed-off-by: Jeffrey Vernon Merkey (jmerkey@wolfmountaingroup.com)

--- a/drivers/char/vt.c	2008-08-19 14:10:44.000000000 -0600
+++ b/drivers/char/vt.c	2008-08-19 14:09:41.000000000 -0600
@@ -187,6 +187,7 @@
 int last_console;
 int want_console = -1;
 int kmsg_redirect;
+EXPORT_SYMBOL_GPL(kmsg_redirect);
 
 /*
  * For each existing display, we have a pointer to console currently visible
