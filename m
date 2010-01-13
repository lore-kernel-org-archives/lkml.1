Return-Path: <linux-kernel-owner+w=401wt.eu-S1756662Ab0AMXgl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756662Ab0AMXgl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 18:36:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756643Ab0AMXgd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 18:36:33 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:35824 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756637Ab0AMXgb convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 18:36:31 -0500
From: Ben Hutchings <ben@decadent.org.uk>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: devel@driverdev.osuosl.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 13 Jan 2010 23:36:27 +0000
Message-ID: <1263425787.3852.120.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
Subject: [PATCH 04/11] sep: include driver name in firmware filenames
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on shadbolt.decadent.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current names "cache.image.bin" and "resident.image.bin" are far
too generic.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/staging/sep/sep_driver.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/sep/sep_driver.c b/drivers/staging/sep/sep_driver.c
index e7bc9ec..6b763b7 100644
--- a/drivers/staging/sep/sep_driver.c
+++ b/drivers/staging/sep/sep_driver.c
@@ -182,8 +182,8 @@ static DECLARE_WAIT_QUEUE_HEAD(sep_event);
 static int sep_load_firmware(struct sep_device *sep)
 {
 	const struct firmware *fw;
-	char *cache_name = "cache.image.bin";
-	char *res_name = "resident.image.bin";
+	char *cache_name = "sep/cache.image.bin";
+	char *res_name = "sep/resident.image.bin";
 	int error;
 
 	edbg("SEP Driver:rar_virtual is %p\n", sep->rar_addr);
-- 
1.6.5.7



