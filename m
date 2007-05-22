Return-Path: <linux-kernel-owner+w=401wt.eu-S1757732AbXEVE2V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757732AbXEVE2V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 00:28:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755827AbXEVE2N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 00:28:13 -0400
Received: from havoc.gtf.org ([69.61.125.42]:45870 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755576AbXEVE2M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 00:28:12 -0400
Date: Tue, 22 May 2007 00:28:11 -0400
From: Jeff Garzik <jeff@garzik.org>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] partitions/LDM: build fix
Message-ID: <20070522042811.GA3852@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


This from a "tested" patch...

Signed-off-by: Jeff Garzik <jeff@garzik.org>

diff --git a/fs/partitions/ldm.c b/fs/partitions/ldm.c
index c387812..99873a2 100644
--- a/fs/partitions/ldm.c
+++ b/fs/partitions/ldm.c
@@ -158,7 +158,7 @@ static bool ldm_parse_privhead(const u8 *data, struct privhead *ph)
 		/* Warn the user and continue, carefully. */
 		ldm_info("Database is normally %u bytes, it claims to "
 			"be %llu bytes.", LDM_DB_SIZE,
-			udunsigned long long)ph->config_size);
+			(unsigned long long)ph->config_size);
 	}
 	if ((ph->logical_disk_size == 0) || (ph->logical_disk_start +
 			ph->logical_disk_size > ph->config_start)) {
