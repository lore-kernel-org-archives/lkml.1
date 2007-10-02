Return-Path: <linux-kernel-owner+w=401wt.eu-S1755071AbXJBRRu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755071AbXJBRRu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 13:17:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753050AbXJBRRk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 13:17:40 -0400
Received: from havoc.gtf.org ([69.61.125.42]:59630 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752852AbXJBRRj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 13:17:39 -0400
Date: Tue, 2 Oct 2007 13:17:38 -0400
From: Jeff Garzik <jeff@garzik.org>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [git patch] libata fix
Message-ID: <20071002171738.GA28493@havoc.gtf.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Make another laptop's suspend work.


Please pull from 'upstream-linus' branch of
master.kernel.org:/pub/scm/linux/kernel/git/jgarzik/libata-dev.git upstream-linus

to receive the following updates:

 drivers/ata/ata_piix.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

Tejun Heo (1):
      ata_piix: add another TECRA M3 entry to broken suspend list

diff --git a/drivers/ata/ata_piix.c b/drivers/ata/ata_piix.c
index 3b8bf18..6996eb5 100644
--- a/drivers/ata/ata_piix.c
+++ b/drivers/ata/ata_piix.c
@@ -921,6 +921,13 @@ static int piix_broken_suspend(void)
 {
 	static struct dmi_system_id sysids[] = {
 		{
+			.ident = "TECRA M3",
+			.matches = {
+				DMI_MATCH(DMI_SYS_VENDOR, "TOSHIBA"),
+				DMI_MATCH(DMI_PRODUCT_NAME, "TECRA M3"),
+			},
+		},
+		{
 			.ident = "TECRA M5",
 			.matches = {
 				DMI_MATCH(DMI_SYS_VENDOR, "TOSHIBA"),
