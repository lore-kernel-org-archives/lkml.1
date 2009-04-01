Return-Path: <linux-kernel-owner+w=401wt.eu-S1758127AbZDAOJG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758127AbZDAOJG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 10:09:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765828AbZDAOFq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 10:05:46 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:37766 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1765756AbZDAOFo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 10:05:44 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 10/24] applicom: Auto-load applicom module when device opened.
To: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
Date: Wed, 01 Apr 2009 15:05:54 +0100
Message-ID: <20090401140548.22882.6673.stgit@localhost.localdomain>
In-Reply-To: <20090401140241.22882.93477.stgit@localhost.localdomain>
References: <20090401140241.22882.93477.stgit@localhost.localdomain>
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
 

