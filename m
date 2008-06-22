Return-Path: <linux-kernel-owner+w=401wt.eu-S1756367AbYFVWWj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756367AbYFVWWj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2008 18:22:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758064AbYFVWVo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jun 2008 18:21:44 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:37268 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757769AbYFVWVn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2008 18:21:43 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: pm list <linux-pm@lists.linux-foundation.org>
Subject: [PATCH 2/2] PM: Drop unnecessary includes from pm.h
Date: Mon, 23 Jun 2008 00:22:39 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Andrew Morton <akpm@linux-foundation.org>, Pavel Machek <pavel@ucw.cz>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       LKML <linux-kernel@vger.kernel.org>
References: <200806230019.41016.rjw@sisk.pl>
In-Reply-To: <200806230019.41016.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806230022.40284.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Drop unnecessary includes from include/linux/pm.h .

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 include/linux/pm.h |    2 --
 1 file changed, 2 deletions(-)

Index: linux-2.6/include/linux/pm.h
===================================================================
--- linux-2.6.orig/include/linux/pm.h
+++ linux-2.6/include/linux/pm.h
@@ -22,8 +22,6 @@
 #define _LINUX_PM_H
 
 #include <linux/list.h>
-#include <asm/atomic.h>
-#include <asm/errno.h>
 
 /*
  * Callbacks for platform drivers to implement.
