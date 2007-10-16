Return-Path: <linux-kernel-owner+w=401wt.eu-S936031AbXJPXKU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936031AbXJPXKU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 19:10:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752833AbXJPXKI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 19:10:08 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:58493 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754223AbXJPXKG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 19:10:06 -0400
Date: Tue, 16 Oct 2007 16:10:01 -0700
From: "Darrick J. Wong" <djwong@us.ibm.com>
To: Doug Thompson <dougthompson@xmission.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       bluesmoke-devel@lists.sourceforge.net
Subject: [PATCH] i5000_edac: No need to __stringify() KBUILD_BASENAME
Message-ID: <20071016231001.GB6408@tree.beaverton.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The i5000_edac driver's PCI registration structure has the name
""i5000_edac"" (with extra set of double-quotes) which is probably
not intentional.  Get rid of __stringify.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---

 drivers/edac/i5000_edac.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/edac/i5000_edac.c b/drivers/edac/i5000_edac.c
index 96f7e63..a1f24c4 100644
--- a/drivers/edac/i5000_edac.c
+++ b/drivers/edac/i5000_edac.c
@@ -1462,7 +1462,7 @@ MODULE_DEVICE_TABLE(pci, i5000_pci_tbl);
  *
  */
 static struct pci_driver i5000_driver = {
-	.name = __stringify(KBUILD_BASENAME),
+	.name = KBUILD_BASENAME,
 	.probe = i5000_init_one,
 	.remove = __devexit_p(i5000_remove_one),
 	.id_table = i5000_pci_tbl,
