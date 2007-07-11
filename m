Return-Path: <linux-kernel-owner+w=401wt.eu-S934852AbXGKXga@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934852AbXGKXga (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 19:36:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934876AbXGKXdY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 19:33:24 -0400
Received: from ns1.suse.de ([195.135.220.2]:33593 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934985AbXGKXdX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 19:33:23 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 08/61] PM: Remove saved_state from struct dev_pm_info
Date: Wed, 11 Jul 2007 16:31:27 -0700
Message-Id: <11841967793134-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.2.2
In-Reply-To: <11841967711788-git-send-email-gregkh@suse.de>
References: <20070711233021.GA5253@kroah.com>
 <11841967403365-git-send-email-gregkh@suse.de>
 <11841967493890-git-send-email-gregkh@suse.de>
 <1184196753488-git-send-email-gregkh@suse.de>
 <1184196759393-git-send-email-gregkh@suse.de>
 <11841967633087-git-send-email-gregkh@suse.de>
 <11841967674155-git-send-email-gregkh@suse.de>
 <11841967711788-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

The saved_state member of struct dev_pm_info, defined in include/linux/pm.h, is
not used anywhere, so it can be removed.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 include/linux/pm.h |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/include/linux/pm.h b/include/linux/pm.h
index 3fd65ad..6e7f066 100644
--- a/include/linux/pm.h
+++ b/include/linux/pm.h
@@ -268,7 +268,6 @@ struct dev_pm_info {
 #ifdef	CONFIG_PM
 	unsigned		should_wakeup:1;
 	pm_message_t		prev_state;
-	void			* saved_state;
 	struct list_head	entry;
 #endif
 };
-- 
1.5.2.2

