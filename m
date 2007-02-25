Return-Path: <linux-kernel-owner+w=401wt.eu-S965224AbXBYXSm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965224AbXBYXSm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Feb 2007 18:18:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965232AbXBYXSm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Feb 2007 18:18:42 -0500
Received: from mailout.stusta.mhn.de ([141.84.69.5]:44220 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S965224AbXBYXSl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Feb 2007 18:18:41 -0500
Date: Mon, 26 Feb 2007 00:18:42 +0100
From: Adrian Bunk <bunk@stusta.de>
To: pcaulfie@redhat.com, teigland@redhat.com
Cc: cluster-devel@redhat.com, linux-kernel@vger.kernel.org
Subject: [2.6 patch] fs/dlm/user.c should #include "user.h"
Message-ID: <20070225231842.GD29575@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Every file should include the headers containing the prototypes for
it's global functions.

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---
--- linux-2.6.20-mm2/fs/dlm/user.c.old	2007-02-25 19:40:16.000000000 +0100
+++ linux-2.6.20-mm2/fs/dlm/user.c	2007-02-25 19:40:29.000000000 +0100
@@ -22,6 +22,7 @@
 #include "lockspace.h"
 #include "lock.h"
 #include "lvb_table.h"
+#include "user.h"
 
 static const char *name_prefix="dlm";
 static struct miscdevice ctl_device;

