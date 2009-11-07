Return-Path: <linux-kernel-owner+w=401wt.eu-S1753248AbZKGVoB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753248AbZKGVoB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Nov 2009 16:44:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753059AbZKGVoA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Nov 2009 16:44:00 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46912 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752078AbZKGVn7 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Nov 2009 16:43:59 -0500
From: Ben Hutchings <ben@decadent.org.uk>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Jiri Slaby <jirislaby@gmail.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Sat, 07 Nov 2009 21:43:59 +0000
Message-ID: <1257630239.15927.389.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
Subject: [PATCH 06/75] isicom: declare MODULE_FIRMWARE
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on shadbolt.decadent.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/char/isicom.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/char/isicom.c b/drivers/char/isicom.c
index 426bfdd..1da1372 100644
--- a/drivers/char/isicom.c
+++ b/drivers/char/isicom.c
@@ -1782,3 +1782,8 @@ module_exit(isicom_exit);
 MODULE_AUTHOR("MultiTech");
 MODULE_DESCRIPTION("Driver for the ISI series of cards by MultiTech");
 MODULE_LICENSE("GPL");
+MODULE_FIRMWARE("isi608.bin");
+MODULE_FIRMWARE("isi608em.bin");
+MODULE_FIRMWARE("isi616em.bin");
+MODULE_FIRMWARE("isi4608.bin");
+MODULE_FIRMWARE("isi4616.bin");
-- 
1.6.5.2



