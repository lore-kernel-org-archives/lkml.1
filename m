Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932281Ab0BOVoQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Feb 2010 16:44:16 -0500
Received: from mail-ew0-f228.google.com ([209.85.219.228]:54849 "EHLO
	mail-ew0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932182Ab0BOVoJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Feb 2010 16:44:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=fs5ybd+QIJfgsS/afchEGfaU8DXal8PAIAaX6T419//YKj3Ns2d8mm+Jd2wfkQEvoG
         suoBLtk3PKied090A77CW24M8TfjH45CBHw2QmVFjEHGhX1zIeyBwiQKrFA23pb6yumF
         Nog3SWg8q+PKjMiKtL/LZCGYTAPuHJbPZOjLA=
Message-ID: <4B79C1E2.9090900@gmail.com>
Date: Mon, 15 Feb 2010 22:51:30 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Thunderbird/3.0.1
MIME-Version: 1.0
To: Karsten Keil <isdn@linux-pingi.de>, isdn4linux@listserv.isdn4linux.de,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] isdn: misplaced parenthesis in pof_handle_data()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The parenthesis was misplaced

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
diff --git a/drivers/isdn/hysdn/hysdn_boot.c b/drivers/isdn/hysdn/hysdn_boot.c
index be787e1..4f541ef 100644
--- a/drivers/isdn/hysdn/hysdn_boot.c
+++ b/drivers/isdn/hysdn/hysdn_boot.c
@@ -143,7 +143,7 @@ pof_handle_data(hysdn_card * card, int datlen)
 					     (boot->pof_recid == TAG_CABSDATA) ? "CABSDATA" : "ABSDATA",
 					     datlen, boot->pof_recoffset);
 
-			if ((boot->last_error = card->writebootseq(card, boot->buf.BootBuf, datlen) < 0))
+			if ((boot->last_error = card->writebootseq(card, boot->buf.BootBuf, datlen)) < 0)
 				return (boot->last_error);	/* error writing data */
 
 			if (boot->pof_recoffset + datlen >= boot->pof_reclen)
