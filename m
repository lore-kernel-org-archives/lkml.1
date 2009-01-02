Return-Path: <linux-kernel-owner+w=401wt.eu-S1758583AbZABQTt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758583AbZABQTt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 11:19:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756755AbZABQTi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 11:19:38 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:41364 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753411AbZABQTi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 11:19:38 -0500
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 2/2] i8k: Add Dell Vostro systems
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Date: Fri, 02 Jan 2009 16:19:23 +0000
Message-ID: <20090102161919.18117.51612.stgit@localhost.localdomain>
In-Reply-To: <20090102161825.18117.98501.stgit@localhost.localdomain>
References: <20090102161825.18117.98501.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Federico Heinz <fheinz@vialibre.org.ar>

This trivial patch adds support for i8k on the new Dell Vostro models.
I tested it on my Vostro 1400, and it works. It does print a warning
when loading the module:

	i8k: unable to get SMM BIOS version

But I couldn't figure out how to fix that. The module seems to work fine,
anyway...

Signed-off-by: Federico Heinz <fheinz@vialibre.org.ar>
Signed-off-by: Alan Cox <alan@redhat.com>
---

 drivers/char/i8k.c |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)


diff --git a/drivers/char/i8k.c b/drivers/char/i8k.c
index 099fc89..fc8cf7a 100644
--- a/drivers/char/i8k.c
+++ b/drivers/char/i8k.c
@@ -492,7 +492,14 @@ static struct dmi_system_id __initdata i8k_dmi_table[] = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "Precision"),
 		},
 	},
-	{ }
+	{
+		.ident = "Dell Vostro",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Vostro"),
+		},
+	},
+        { }
 };
 
 /*

