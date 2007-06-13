Return-Path: <linux-kernel-owner+w=401wt.eu-S1754600AbXFMV36@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754600AbXFMV36 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 17:29:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753514AbXFMV3i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 17:29:38 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:48328 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752386AbXFMV3h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 17:29:37 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH -mm 2/7] PM: Remove saved_state from struct dev_pm_info
Date: Wed, 13 Jun 2007 15:55:34 +0200
User-Agent: KMail/1.9.5
Cc: Alan Stern <stern@rowland.harvard.edu>,
       David Brownell <david-b@pacbell.net>, Greg KH <greg@kroah.com>,
       LKML <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>
References: <200706131551.51336.rjw@sisk.pl>
In-Reply-To: <200706131551.51336.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706131555.37277.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

The saved_state member of struct dev_pm_info, defined in include/linux/pm.h, is
not used anywhere, so it can be removed.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 include/linux/pm.h |    1 -
 1 file changed, 1 deletion(-)

Index: linux-2.6.22-rc4-mm2/include/linux/pm.h
===================================================================
--- linux-2.6.22-rc4-mm2.orig/include/linux/pm.h
+++ linux-2.6.22-rc4-mm2/include/linux/pm.h
@@ -236,7 +236,6 @@ struct dev_pm_info {
 #ifdef	CONFIG_PM
 	unsigned		should_wakeup:1;
 	pm_message_t		prev_state;
-	void			* saved_state;
 	struct list_head	entry;
 #endif
 };

