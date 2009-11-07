Return-Path: <linux-kernel-owner+w=401wt.eu-S1753189AbZKGVnN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753189AbZKGVnN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Nov 2009 16:43:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752924AbZKGVnL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Nov 2009 16:43:11 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46890 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753132AbZKGVnK convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Nov 2009 16:43:10 -0500
From: Ben Hutchings <ben@decadent.org.uk>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Sat, 07 Nov 2009 21:42:01 +0000
Message-ID: <1257630121.15927.383.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
Subject: [PATCH 04/75] cyclades: declare MODULE_FIRMWARE
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on shadbolt.decadent.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/char/cyclades.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/char/cyclades.c b/drivers/char/cyclades.c
index 4254457..0113574 100644
--- a/drivers/char/cyclades.c
+++ b/drivers/char/cyclades.c
@@ -4208,3 +4208,4 @@ module_exit(cy_cleanup_module);
 MODULE_LICENSE("GPL");
 MODULE_VERSION(CY_VERSION);
 MODULE_ALIAS_CHARDEV_MAJOR(CYCLADES_MAJOR);
+MODULE_FIRMWARE("cyzfirm.bin");
-- 
1.6.5.2



