Return-Path: <linux-kernel-owner+w=401wt.eu-S1759821AbZCXOKI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759821AbZCXOKI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 10:10:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758706AbZCXOEI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 10:04:08 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:48964 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758710AbZCXOEE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 10:04:04 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 15/30] applicom: Auto-load applicom module when device opened.
To: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
       torvalds@linux-foundation.org
Date: Tue, 24 Mar 2009 14:04:26 +0000
Message-ID: <20090324140419.12735.25260.stgit@localhost.localdomain>
In-Reply-To: <20090324135930.12735.7827.stgit@localhost.localdomain>
References: <20090324135930.12735.7827.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Scott James Remnant <scott@canonical.com>

The applicom module is missing the char-major-10-157 alias that would
cause it to be auto-loaded when a device of that type is opened.  This
patch adds the alias.

Signed-off-by: Scott James Remnant <scott@canonical.com>
Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
Signed-off-by: Alan Cox <alan@lxorguk.ukuu.org.uk>
---

 drivers/char/applicom.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)


diff --git a/drivers/char/applicom.c b/drivers/char/applicom.c
index 05674fe..73a0765 100644
--- a/drivers/char/applicom.c
+++ b/drivers/char/applicom.c
@@ -75,6 +75,7 @@ MODULE_DEVICE_TABLE(pci, applicom_pci_tbl);
 MODULE_AUTHOR("David Woodhouse & Applicom International");
 MODULE_DESCRIPTION("Driver for Applicom Profibus card");
 MODULE_LICENSE("GPL");
+MODULE_ALIAS_MISCDEV(AC_MINOR);
 
 MODULE_SUPPORTED_DEVICE("ac");
 

