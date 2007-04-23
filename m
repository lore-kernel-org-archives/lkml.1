Return-Path: <linux-kernel-owner+w=401wt.eu-S932785AbXDWOOF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932785AbXDWOOF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 10:14:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932564AbXDWOOB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 10:14:01 -0400
Received: from mtagate7.de.ibm.com ([195.212.29.156]:36200 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753968AbXDWON4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 10:13:56 -0400
Date: Mon, 23 Apr 2007 16:14:12 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Cc: akpm@linux-foundation.org, mb@bu3sch.de, linville@tuxdriver.com,
       arnd@arndb.de, maxextreme@gmail.com, gregkh@suse.de
Subject: [PATCH 8/9] Kconfig: silicon backplane dependency.
Message-ID: <20070423141412.GI21174@skybase>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Martin Schwidefsky <schwidefsky@de.ibm.com>

Add HAS_IOMEM dependency to the "Sonics Silicon Backplane" menu.
This hides the menu for s390.
Goes on top of git-wireless.patch.

Cc: Michael Buesch <mb@bu3sch.de>
Cc: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---

 drivers/ssb/Kconfig |    1 +
 1 files changed, 1 insertion(+)

diff -urpN linux-2.6/drivers/ssb/Kconfig linux-2.6-patched/drivers/ssb/Kconfig
--- linux-2.6/drivers/ssb/Kconfig	2007-04-23 15:51:57.000000000 +0200
+++ linux-2.6-patched/drivers/ssb/Kconfig	2007-04-23 15:53:15.000000000 +0200
@@ -1,4 +1,5 @@
 menu "Sonics Silicon Backplane"
+	depends on HAS_IOMEM
 
 config SSB
 	tristate "Sonics Silicon Backplane support"
