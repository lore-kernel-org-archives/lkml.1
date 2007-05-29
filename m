Return-Path: <linux-kernel-owner+w=401wt.eu-S1751157AbXE2WGT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751157AbXE2WGT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 18:06:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750766AbXE2WGD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 18:06:03 -0400
Received: from havoc.gtf.org ([69.61.125.42]:38776 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750750AbXE2WGB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 18:06:01 -0400
Date: Tue, 29 May 2007 18:06:00 -0400
From: Jeff Garzik <jeff@garzik.org>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [git patches] libata fix
Message-ID: <20070529220600.GA32281@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Please pull from 'upstream-linus' branch of
master.kernel.org:/pub/scm/linux/kernel/git/jgarzik/libata-dev.git upstream-linus

to receive the following updates:

 drivers/ata/libata-core.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

Jeff Garzik (1):
      [libata] Add drive to NCQ blacklist

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 3ca9c61..af62514 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -3783,6 +3783,7 @@ static const struct ata_blacklist_entry ata_device_blacklist [] = {
 	{ "FUJITSU MHT2060BH",	NULL,		ATA_HORKAGE_NONCQ },
 	/* NCQ is broken */
 	{ "Maxtor 6L250S0",     "BANC1G10",     ATA_HORKAGE_NONCQ },
+	{ "Maxtor 6B200M0",	"BANC1B10",	ATA_HORKAGE_NONCQ },
 	/* NCQ hard hangs device under heavier load, needs hard power cycle */
 	{ "Maxtor 6B250S0",	"BANC1B70",	ATA_HORKAGE_NONCQ },
 	/* Blacklist entries taken from Silicon Image 3124/3132
