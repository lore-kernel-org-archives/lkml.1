Return-Path: <linux-kernel-owner+w=401wt.eu-S1756139Ab0AMRBd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756139Ab0AMRBd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 12:01:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756129Ab0AMRBc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 12:01:32 -0500
Received: from mail-ew0-f209.google.com ([209.85.219.209]:57401 "EHLO
	mail-ew0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756105Ab0AMRBa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 12:01:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=Xea4S33OGhkaHPhDRyL/9/FBxhNK+vCzKsDtFK8tmYSSFFN9JI2LUBD/4LAaPE0lBG
         1nxUMXlj/lCUnqffXSMBsxLXwU49GMv8L1SKZcNfDnw1/Ys3sYDBs7AQiTz6Fl6bAo7c
         fc5hsaS0jcSGgcJMXHlpXz2xh0nELOtfyAmKw=
Message-ID: <4B4DFD6B.8000904@gmail.com>
Date: Wed, 13 Jan 2010 18:05:47 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Thunderbird/3.0
MIME-Version: 1.0
To: Corentin Chary <corentincj@iksaif.net>,
       Karol Kozimor <sziwan@users.sourceforge.net>,
       acpi4asus-user@lists.sourceforge.net,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] asus-acpi: duplicate comparison of asus_model strings
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These tests already occur elsewhere

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
Does this remove the right duplicates?

diff --git a/drivers/platform/x86/asus_acpi.c b/drivers/platform/x86/asus_acpi.c
index c1d2aee..1381430 100644
--- a/drivers/platform/x86/asus_acpi.c
+++ b/drivers/platform/x86/asus_acpi.c
@@ -1225,9 +1225,8 @@ static int asus_model_match(char *model)
 	else if (strncmp(model, "M2N", 3) == 0 ||
 		 strncmp(model, "M3N", 3) == 0 ||
 		 strncmp(model, "M5N", 3) == 0 ||
-		 strncmp(model, "M6N", 3) == 0 ||
 		 strncmp(model, "S1N", 3) == 0 ||
-		 strncmp(model, "S5N", 3) == 0 || strncmp(model, "W1N", 3) == 0)
+		 strncmp(model, "S5N", 3) == 0)
 		return xxN;
 	else if (strncmp(model, "M1", 2) == 0)
 		return M1A;
