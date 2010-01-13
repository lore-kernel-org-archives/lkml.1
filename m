Return-Path: <linux-kernel-owner+w=401wt.eu-S1756667Ab0AMXgz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756667Ab0AMXgz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 18:36:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755201Ab0AMXgx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 18:36:53 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:35828 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756587Ab0AMXgu convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 18:36:50 -0500
From: Ben Hutchings <ben@decadent.org.uk>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: devel@driverdev.osuosl.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 13 Jan 2010 23:36:46 +0000
Message-ID: <1263425806.3852.121.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
Subject: [PATCH 05/11] sep: declare MODULE_FIRMWARE
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on shadbolt.decadent.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/staging/sep/sep_driver.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/sep/sep_driver.c b/drivers/staging/sep/sep_driver.c
index 6b763b7..916a9c1 100644
--- a/drivers/staging/sep/sep_driver.c
+++ b/drivers/staging/sep/sep_driver.c
@@ -222,6 +222,9 @@ static int sep_load_firmware(struct sep_device *sep)
 	return 0;
 }
 
+MODULE_FIRMWARE("sep/cache.image.bin");
+MODULE_FIRMWARE("sep/resident.image.bin");
+
 /**
  *	sep_map_and_alloc_shared_area	-	allocate shared block
  *	@sep: security processor
-- 
1.6.5.7



