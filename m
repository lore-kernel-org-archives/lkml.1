Return-Path: <linux-kernel-owner+w=401wt.eu-S2993082AbXDTLe0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993082AbXDTLe0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 07:34:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992993AbXDTLeZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 07:34:25 -0400
Received: from mtagate8.de.ibm.com ([195.212.29.157]:37372 "EHLO
	mtagate8.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2993059AbXDTLeP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 07:34:15 -0400
Date: Fri, 20 Apr 2007 13:34:30 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Cc: akpm@linux-foundation.org, gregkh@suse.de
Subject: [PATCH 6/8] Kconfig: no userspace I/O on s390.
Message-ID: <20070420113430.GG3738@skybase>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Martin Schwidefsky <schwidefsky@de.ibm.com>

Hide the config menu for userspace I/O on s390.
Goes on top of gregkh-driver-uio.patch.

Cc: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---

 drivers/uio/Kconfig |    2 ++
 1 files changed, 2 insertions(+)

diff -urpN linux-2.6/drivers/uio/Kconfig linux-2.6-patched/drivers/uio/Kconfig
--- linux-2.6/drivers/uio/Kconfig	2007-04-19 15:24:40.000000000 +0200
+++ linux-2.6-patched/drivers/uio/Kconfig	2007-04-20 10:51:24.000000000 +0200
@@ -1,4 +1,6 @@
 menu "Userspace I/O"
+	depends on !S390
+
 config UIO
 	tristate "Userspace I/O drivers"
 	default n
