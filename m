Return-Path: <linux-kernel-owner+w=401wt.eu-S1753154Ab0AYQMq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753154Ab0AYQMq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jan 2010 11:12:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751981Ab0AYQMp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jan 2010 11:12:45 -0500
Received: from mail-yx0-f119.google.com ([209.85.210.119]:60759 "EHLO
	mail-yx0-f119.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751770Ab0AYQMp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jan 2010 11:12:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=knrRN8LY1o3Itw2dksbDTc/y3MwH4RVECfy/X+eRPXOd34eHGigYDcQievnih9t7R4
         hS082xWY917k6YTSjbBr/cGsDQ2ij3DSSN3bNMcJ8ZyhUeVE3SBRqs9v3mRnI9pGfI6L
         eocqvaoX4OIAhvmP8QXPdS0Qg+aFI4MdC8Xvc=
MIME-Version: 1.0
Date: Mon, 25 Jan 2010 16:12:43 +0000
Message-ID: <a05e21071001250812x4461e4a0re7f46f7cd28c4162@mail.gmail.com>
Subject: [PATCH] Generic PS/2 mouse detected on Fujitsu Lifebook B-Series 
	model laptop instead of LBPS/2 Fujitsu Lifebook TouchScreen
From: jon - <crayzeejon@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jon Dodgson <crayzeejon@gmail.com>

Fix Detection of Lifebook B-Series Laptop touch screen with DMI
product Name string 'Lifebook B Series'

Signed-off-by: Jon Dodgson <crayzeejon@gmail.com>

---
diff -Nurb linux-2.6.26.2/drivers/input/mouse/lifebook.c
linux-2.6.26.2_patched/drivers/input/mouse/lifebook.c
--- linux-2.6.26.2/drivers/input/mouse/lifebook.c    2008-08-06
17:19:01.000000000 +0100
+++ linux-2.6.26.2_patched/drivers/input/mouse/lifebook.c    2010-01-25
02:56:41.000000000 +0000
@@ -51,6 +51,12 @@
    {
        .ident = "LifeBook B",
        .matches = {
+            DMI_MATCH(DMI_PRODUCT_NAME, "Lifebook B Series"),
+        },
+    },
+    {
+        .ident = "LifeBook B",
+        .matches = {
            DMI_MATCH(DMI_PRODUCT_NAME, "LifeBook B Series"),
        },
    },
