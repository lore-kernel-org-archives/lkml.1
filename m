Return-Path: <linux-kernel-owner+w=401wt.eu-S1751225AbXBUL5u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751225AbXBUL5u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 06:57:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751228AbXBUL5u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 06:57:50 -0500
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:38600 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751225AbXBUL5b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 06:57:31 -0500
Date: Wed, 21 Feb 2007 12:57:30 +0100
From: Adrian Bunk <bunk@stusta.de>
To: Jiri Kosina <jkosina@suse.cz>
Cc: linux-input@atrey.karlin.mff.cuni.cz, linux-kernel@vger.kernel.org
Subject: [2.6 patch] drivers/hid/hid-debug.c should #include <linux/hid-debug.h>
Message-ID: <20070221115730.GG13958@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Every file should include the headers containing the prototypes for
it's global functions.

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---
--- linux-2.6.20-mm2/drivers/hid/hid-debug.c.old	2007-02-20 23:07:32.000000000 +0100
+++ linux-2.6.20-mm2/drivers/hid/hid-debug.c	2007-02-21 00:00:41.000000000 +0100
@@ -29,6 +29,7 @@
  */
 
 #include <linux/hid.h>
+#include <linux/hid-debug.h>
 
 struct hid_usage_entry {
 	unsigned  page;

