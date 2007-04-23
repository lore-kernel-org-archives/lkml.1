Return-Path: <linux-kernel-owner+w=401wt.eu-S964784AbXDWOOF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964784AbXDWOOF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 10:14:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932760AbXDWOOE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 10:14:04 -0400
Received: from mtagate7.de.ibm.com ([195.212.29.156]:36187 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932664AbXDWONl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 10:13:41 -0400
Date: Mon, 23 Apr 2007 16:13:57 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Cc: akpm@linux-foundation.org, mb@bu3sch.de, linville@tuxdriver.com,
       arnd@arndb.de, maxextreme@gmail.com, gregkh@suse.de
Subject: [PATCH 7/9] Kconfig: no userspace I/O on s390.
Message-ID: <20070423141357.GH21174@skybase>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH 7/9] Kconfig: no userspace I/O on s390.

From: Martin Schwidefsky <schwidefsky@de.ibm.com>

Hide the config menu for userspace I/O on s390.
Goes on top of gregkh-driver-uio.patch.

Cc: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---

 drivers/uio/Kconfig |    2 ++
 1 files changed, 2 insertions(+)

diff -urpN linux-2.6/drivers/uio/Kconfig linux-2.6-patched/drivers/uio/Kconfig
--- linux-2.6/drivers/uio/Kconfig	2007-04-23 15:51:59.000000000 +0200
+++ linux-2.6-patched/drivers/uio/Kconfig	2007-04-23 15:53:14.000000000 +0200
@@ -1,4 +1,6 @@
 menu "Userspace I/O"
+	depends on !S390
+
 config UIO
 	tristate "Userspace I/O drivers"
 	default n
