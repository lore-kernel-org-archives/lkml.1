Return-Path: <linux-kernel-owner+w=401wt.eu-S1760961AbYHPEOQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760961AbYHPEOQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Aug 2008 00:14:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755541AbYHPEGQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Aug 2008 00:06:16 -0400
Received: from 166-70-238-42.ip.xmission.com ([166.70.238.42]:33288 "EHLO
	ns1.wolfmountaingroup.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752130AbYHPEFn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Aug 2008 00:05:43 -0400
Date: Fri, 15 Aug 2008 21:41:47 -0600
From: jmerkey@wolfmountaingroup.com
Message-Id: <200808160341.m7G3flWx022570@wolfmountaingroup.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 2.6.27-rc3 20/28] mdb: remove conditional exports
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

remove conditional exporting of console redirection handle, and just
export it.

Signed-off-by: Jeffrey Vernon Merkey (jmerkey@wolfmountaingroup.com)

--- a/drivers/char/vt.c	2008-08-15 21:26:13.000000000 -0600
+++ b/drivers/char/vt.c	2008-08-15 15:41:57.000000000 -0600
@@ -187,6 +187,7 @@
 int last_console;
 int want_console = -1;
 int kmsg_redirect;
+EXPORT_SYMBOL_GPL(kmsg_redirect);
 
 /*
  * For each existing display, we have a pointer to console currently visible
