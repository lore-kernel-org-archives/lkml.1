Return-Path: <linux-kernel-owner+w=401wt.eu-S1161501AbXBHAdH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161501AbXBHAdH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 19:33:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161498AbXBHAdG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 19:33:06 -0500
Received: from cantor.suse.de ([195.135.220.2]:56448 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965708AbXBHAc6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 19:32:58 -0500
From: Greg KH <greg@kroah.com>
To: linux-kernel@vger.kernel.org
Cc: Dave Jones <davej@redhat.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 27/28] Driver Core: Increase the default timeout value of the firmware subsystem
Date: Wed,  7 Feb 2007 16:30:15 -0800
Message-Id: <11708947091288-git-send-email-greg@kroah.com>
X-Mailer: git-send-email 1.4.4.4
In-Reply-To: <11708947063663-git-send-email-greg@kroah.com>
References: <20070208002908.GA4796@kroah.com> <11708946163722-git-send-email-greg@kroah.com> <1170894620889-git-send-email-greg@kroah.com> <11708946251265-git-send-email-greg@kroah.com> <11708946283719-git-send-email-greg@kroah.com> <11708946362677-git-send-email-greg@kroah.com> <11708946391465-git-send-email-greg@kroah.com> <11708946432920-git-send-email-greg@kroah.com> <11708946472324-git-send-email-greg@kroah.com> <1170894650872-git-send-email-greg@kroah.com> <11708946533931-git-send-email-greg@kroah.com> <11708946561557-git-send-email-greg@kroah.com> <11708946601643-git-send-email-greg@kroah.com> <1170894664547-git-send-email-greg@kroah.com> <11708946672133-git-send-email-greg@kroah.com> <1170894670676-git-send-email-greg@kroah.com> <11708946734097-git-send-email-greg@kroah.com> <11708946762594-git-send-email-greg@kroah.com> <11708946802786-git-send-email-greg@kroah.com> <11708946832214-git-send-email-greg@kroah.com> <11708946871208-git-send-email-greg@kroah.com> <1170894
 6903974-git-send-email-greg@kroah.com> <11708946932742-git-send-email-greg@kroah.com> <11708946963110-git-send-email-greg@kroah.com> <11708946993815-git-send-email-greg@kroah.com> <11708947024054-git-send-email-greg@kroah.com> <11708947063663-git-send-email-greg@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dave Jones <davej@redhat.com>

https://bugzilla.redhat.com/bugzilla/show_bug.cgi?id=174589

The ipw driver sometimes takes a long time to load its firmware.
Whilst the ipw driver should be using the async interface of
the firmware loader to make this a non-issue, this is a minimal fix.

Signed-off-by: Dave Jones <davej@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/firmware_class.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
index 64558f4..c0a979a 100644
--- a/drivers/base/firmware_class.c
+++ b/drivers/base/firmware_class.c
@@ -35,7 +35,7 @@ enum {
 	FW_STATUS_READY_NOHOTPLUG,
 };
 
-static int loading_timeout = 10;	/* In seconds */
+static int loading_timeout = 60;	/* In seconds */
 
 /* fw_lock could be moved to 'struct firmware_priv' but since it is just
  * guarding for corner cases a global lock should be OK */
-- 
1.4.4.4

