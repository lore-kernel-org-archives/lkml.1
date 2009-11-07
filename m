Return-Path: <linux-kernel-owner+w=401wt.eu-S1753664AbZKGWF4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753664AbZKGWF4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Nov 2009 17:05:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753621AbZKGWFx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Nov 2009 17:05:53 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:47319 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753603AbZKGWFw convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Nov 2009 17:05:52 -0500
From: Ben Hutchings <ben@decadent.org.uk>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Sat, 07 Nov 2009 22:05:55 +0000
Message-ID: <1257631555.15927.485.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
Subject: [PATCH 61/75] icom: declare MODULE_FIRMWARE
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on shadbolt.decadent.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/serial/icom.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/serial/icom.c b/drivers/serial/icom.c
index 0028b6f..6e715b7 100644
--- a/drivers/serial/icom.c
+++ b/drivers/serial/icom.c
@@ -1654,4 +1654,6 @@ MODULE_DESCRIPTION("IBM iSeries Serial IOA driver");
 MODULE_SUPPORTED_DEVICE
     ("IBM iSeries 2745, 2771, 2772, 2742, 2793 and 2805 Communications adapters");
 MODULE_LICENSE("GPL");
-
+MODULE_FIRMWARE("icom_call_setup.bin");
+MODULE_FIRMWARE("icom_res_dce.bin");
+MODULE_FIRMWARE("icom_asc.bin");
-- 
1.6.5.2



