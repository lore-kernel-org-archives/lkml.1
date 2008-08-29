Return-Path: <linux-kernel-owner+w=401wt.eu-S1754595AbYH2GWy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754595AbYH2GWy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 02:22:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752484AbYH2GQA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 02:16:00 -0400
Received: from 166-70-238-42.ip.xmission.com ([166.70.238.42]:59514 "EHLO
	ns1.wolfmountaingroup.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751883AbYH2GPa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 02:15:30 -0400
Date: Thu, 28 Aug 2008 23:47:42 -0600
From: jmerkey@wolfmountaingroup.com
Message-Id: <200808290547.m7T5lgcE016137@wolfmountaingroup.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 2.6.27-rc5 22/29] mdb: export kmsg_redirect printk for console redirection 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

export kmsg_redirect printk for console redirection 


Signed-off-by: Jeffrey Vernon Merkey (jmerkey@wolfmountaingroup.com)

--- a/drivers/char/vt.c	2008-08-28 14:19:20.000000000 -0600
+++ b/drivers/char/vt.c	2008-08-28 14:20:04.000000000 -0600
@@ -187,6 +187,7 @@
 int last_console;
 int want_console = -1;
 int kmsg_redirect;
+EXPORT_SYMBOL_GPL(kmsg_redirect);
 
 /*
  * For each existing display, we have a pointer to console currently visible
