Return-Path: <linux-kernel-owner+w=401wt.eu-S1752062AbZL2D5n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752062AbZL2D5n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Dec 2009 22:57:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751642AbZL2D5m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Dec 2009 22:57:42 -0500
Received: from mail-pz0-f171.google.com ([209.85.222.171]:61849 "EHLO
	mail-pz0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751547AbZL2D5l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Dec 2009 22:57:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=BOGBhq0Egk/MgEG33o4uiAwTlc8zE/7SvxEtz5ywBlzX2yLfH3i1RQCD0zCyWAl0Ys
         bnwS4wJPzO3tEmWFf/LEoT1XyxR9OxR3MhZ5AStsJaudGSs+GfYVTg6zOdJaH0hhBr88
         Op1qNG3fAoCoyemc+6OleLEqhuoD81ip4Wu9U=
MIME-Version: 1.0
Date: Tue, 29 Dec 2009 09:57:41 +0600
Message-ID: <b9df5fa10912281957n5b0ab34fgc1b2ffb239fb8e87@mail.gmail.com>
Subject: [PATCH] input, misc: Fix CONFIG_PM defination in wistron_btns.c
From: Rakib Mullick <rakib.mullick@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Miloslav Trmac <mitr@volny.cz>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 Fix CONFIG_PM defination.
We were warned by the following warning:

drivers/input/misc/wistron_btns.c:1331:5: warning: "CONFIG_PM" is not defined

Signed-off-by: Rakib Mullick <rakib.mullick@gmail.com>
---

--- linus/drivers/input/misc/wistron_btns.c	2009-12-28 12:37:50.000000000 +0600
+++ rakib/drivers/input/misc/wistron_btns.c	2009-12-28 14:48:43.000000000 +0600
@@ -1328,7 +1328,7 @@ static struct platform_driver wistron_dr
 	.driver		= {
 		.name	= "wistron-bios",
 		.owner	= THIS_MODULE,
-#if CONFIG_PM
+#ifdef CONFIG_PM
 		.pm	= &wistron_pm_ops,
 #endif
 	},
