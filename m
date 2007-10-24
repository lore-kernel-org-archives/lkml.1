Return-Path: <linux-kernel-owner+w=401wt.eu-S1756785AbXJXQWx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756785AbXJXQWx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 12:22:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753537AbXJXQWj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 12:22:39 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:33279 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752705AbXJXQWi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 12:22:38 -0400
Date: Wed, 24 Oct 2007 18:23:06 +0200
From: Adrian Bunk <bunk@kernel.org>
To: jgarzik@pobox.com
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [2.6 patch] libata-core.c: make 2 functions static
Message-ID: <20071024162306.GF30533@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

strn_pattern_cmp() and ata_port_detach() can become static.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 drivers/ata/libata-core.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

bd2a708230f4e6d2c706b1e781f6a3a33ca52c3e 
diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 629eadb..ab2ac21 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -4004,7 +4004,7 @@ static const struct ata_blacklist_entry ata_device_blacklist [] = {
 	{ }
 };
 
-int strn_pattern_cmp(const char *patt, const char *name, int wildchar)
+static int strn_pattern_cmp(const char *patt, const char *name, int wildchar)
 {
 	const char *p;
 	int len;
@@ -6918,7 +6918,7 @@ int ata_host_activate(struct ata_host *host, int irq,
  *	LOCKING:
  *	Kernel thread context (may sleep).
  */
-void ata_port_detach(struct ata_port *ap)
+static void ata_port_detach(struct ata_port *ap)
 {
 	unsigned long flags;
 	struct ata_link *link;

