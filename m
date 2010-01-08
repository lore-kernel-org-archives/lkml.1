Return-Path: <linux-kernel-owner+w=401wt.eu-S1753239Ab0AHIBz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753239Ab0AHIBz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jan 2010 03:01:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753133Ab0AHIBh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jan 2010 03:01:37 -0500
Received: from kirsty.vergenet.net ([202.4.237.240]:54992 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753007Ab0AHIBf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jan 2010 03:01:35 -0500
Message-Id: <20100108075921.504899210@vergenet.net>
User-Agent: quilt/0.48-1
Date: Fri, 08 Jan 2010 18:57:54 +1100
From: horms@vergenet.net
Subject: [patch 6/6] otus: zfRateCtrlRateDiff(): remove duplicate comparison
To: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Peter Huewe <PeterHuewe@gmx.de>
References: <20100108075748.059645106@vergenet.net>
Content-Disposition: inline; filename=otus-no-duplicate-compre.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I think this is correct.

$ gcc (Debian 4.4.2-8) 4.4.2
Copyright (C) 2009 Free Software Foundation, Inc.
This is free software; see the source for copying conditions.  There is NO
warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

$ make
...
drivers/staging/otus/80211core/ratectrl.c: In function
'zfRateCtrlRateDiff':
drivers/staging/otus/80211core/ratectrl.c:433: warning: suggest parentheses
around comparison in operand of '=='
...

Signed-off-by: Simon Horman <horms@verge.net.au>

Index: linux-2.6/drivers/staging/otus/80211core/ratectrl.c
===================================================================
--- linux-2.6.orig/drivers/staging/otus/80211core/ratectrl.c	2010-01-08 17:13:44.000000000 +1100
+++ linux-2.6/drivers/staging/otus/80211core/ratectrl.c	2010-01-08 17:14:02.000000000 +1100
@@ -430,7 +430,7 @@ u8_t zfRateCtrlRateDiff(struct zsRcCell*
             {
                 return ((rcCell->currentRateIndex - i)+1)>>1;
             }
-            else if (i == rcCell->currentRateIndex == 0)
+            else if (i == rcCell->currentRateIndex)
             {
                 return 1;
             }

