Return-Path: <linux-kernel-owner+w=401wt.eu-S934424AbXEHUtv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934424AbXEHUtv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 16:49:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934370AbXEHUtv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 16:49:51 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:44905 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934364AbXEHUtu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 16:49:50 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] swsusp: Fix comment it register_nosave_region
Date: Tue, 8 May 2007 22:54:43 +0200
User-Agent: KMail/1.9.5
Cc: LKML <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705082254.44346.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Fix a typo in the comment before register_nosave_region().

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 kernel/power/snapshot.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6.21/kernel/power/snapshot.c
===================================================================
--- linux-2.6.21.orig/kernel/power/snapshot.c	2007-05-05 12:38:12.000000000 +0200
+++ linux-2.6.21/kernel/power/snapshot.c	2007-05-08 22:54:04.000000000 +0200
@@ -604,7 +604,7 @@ static LIST_HEAD(nosave_regions);
 /**
  *	register_nosave_region - register a range of page frames the contents
  *	of which should not be saved during the suspend (to be used in the early
- *	initializatoion code)
+ *	initialization code)
  */
 
 void __init
