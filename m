Return-Path: <linux-kernel-owner+w=401wt.eu-S1754764AbYIDCcu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754764AbYIDCcu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 22:32:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753211AbYIDCcl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 22:32:41 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:43502 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752688AbYIDCck (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 22:32:40 -0400
Date: Wed, 3 Sep 2008 19:32:18 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       jkosina@suse.cz, akpm <akpm@linux-foundation.org>
Subject: [PATCH] hid: fix gyration build error
Message-Id: <20080903193218.d79e0f1a.randy.dunlap@oracle.com>
In-Reply-To: <20080903191619.6b6b230e.sfr@canb.auug.org.au>
References: <20080903191619.6b6b230e.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix config symbol name in ifdef to fix build error:

ERROR: "hid_compat_gyration" [drivers/hid/hid-dummy.ko] undefined!

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
cc: Jiri Kosina <jkosina@suse.cz>
---
 drivers/hid/hid-dummy.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-next-20080903.orig/drivers/hid/hid-dummy.c
+++ linux-next-20080903/drivers/hid/hid-dummy.c
@@ -28,7 +28,7 @@ static int __init hid_dummy_init(void)
 #ifdef CONFIG_HID_EZKEY_MODULE
 	HID_COMPAT_CALL_DRIVER(ezkey);
 #endif
-#ifdef CONFIG_HID_EZKEY_MODULE
+#ifdef CONFIG_HID_GYRATION_MODULE
 	HID_COMPAT_CALL_DRIVER(gyration);
 #endif
 #ifdef CONFIG_HID_LOGITECH_MODULE
