Return-Path: <linux-kernel-owner+w=401wt.eu-S1754234AbXFKPBI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754234AbXFKPBI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 11:01:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752654AbXFKPAg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 11:00:36 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:38815 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751552AbXFKPAb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 11:00:31 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: pm list <linux-pm@lists.linux-foundation.org>
Subject: [RFC][PATCH -mm 2/7] PM: Remove saved_state from struct dev_pm_info
Date: Mon, 11 Jun 2007 16:58:27 +0200
User-Agent: KMail/1.9.5
Cc: Alan Stern <stern@rowland.harvard.edu>,
       David Brownell <david-b@pacbell.net>, Greg KH <greg@kroah.com>,
       LKML <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>,
       USB development list <linux-usb-devel@lists.sourceforge.net>
References: <200706111655.50022.rjw@sisk.pl>
In-Reply-To: <200706111655.50022.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706111658.28675.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

The saved_state member of struct dev_pm_info, defined in include/linux/pm.h, is
not used anywhere, so it can be removed.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 include/linux/pm.h |    1 -
 1 file changed, 1 deletion(-)

Index: linux-2.6.22-rc4/include/linux/pm.h
===================================================================
--- linux-2.6.22-rc4.orig/include/linux/pm.h	2007-06-09 21:12:45.000000000 +0200
+++ linux-2.6.22-rc4/include/linux/pm.h	2007-06-09 22:26:13.000000000 +0200
@@ -236,7 +236,6 @@ struct dev_pm_info {
 #ifdef	CONFIG_PM
 	unsigned		should_wakeup:1;
 	pm_message_t		prev_state;
-	void			* saved_state;
 	struct list_head	entry;
 #endif
 };

