Return-Path: <linux-kernel-owner+w=401wt.eu-S1758476AbZABQTV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758476AbZABQTV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 11:19:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757980AbZABQTA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 11:19:00 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:41361 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757902AbZABQS7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 11:18:59 -0500
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 1/2] i8k: Enable i8k on Dell Precision Systems
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Date: Fri, 02 Jan 2009 16:19:13 +0000
Message-ID: <20090102161905.18117.44742.stgit@localhost.localdomain>
In-Reply-To: <20090102161825.18117.98501.stgit@localhost.localdomain>
References: <20090102161825.18117.98501.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andy Spencer <spenceal@rose-hulman.edu>

Patch to enable i8k on Dell Precisions.

Signed-off-by: Andy Spencer <spenceal@rose-hulman.edu>
Signed-off-by: Alan Cox <alan@redhat.com>
---

 drivers/char/i8k.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)


diff --git a/drivers/char/i8k.c b/drivers/char/i8k.c
index b60d425..099fc89 100644
--- a/drivers/char/i8k.c
+++ b/drivers/char/i8k.c
@@ -485,6 +485,13 @@ static struct dmi_system_id __initdata i8k_dmi_table[] = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "MP061"),
 		},
 	},
+	{
+		.ident = "Dell Precision",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Precision"),
+		},
+	},
 	{ }
 };
 

