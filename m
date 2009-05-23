Return-Path: <linux-kernel-owner+w=401wt.eu-S1755755AbZEWUpM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755755AbZEWUpM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 May 2009 16:45:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752956AbZEWUpA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 May 2009 16:45:00 -0400
Received: from mail-fx0-f168.google.com ([209.85.220.168]:39889 "EHLO
	mail-fx0-f168.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752399AbZEWUpA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 May 2009 16:45:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=gkQtCYobF2QEu7+GkygljxgQWfTd1mS4DuxIE9HhCekRZbL7YOYEVSyymKR2Q7O7Yx
         CZ7mpdidJ5IaVEFctmppQBX5T5A798LyS4VzdaWSUghSR3n2gIbU7rPLZDNVyw2rODbH
         l+atWz2MHJkMhY2mxnYmMnez7HxmQfYs9R5dg=
MIME-Version: 1.0
Date: Sat, 23 May 2009 21:45:00 +0100
Message-ID: <5c43c2d40905231345x4166fd45p807f21783f73c9ce@mail.gmail.com>
Subject: [PATCH] b3dfg: Clean up MODULE_PARM_DESC newline
From: =?ISO-8859-1?Q?Andr=E9_Lopes?= <andre.neo.net@gmail.com>
To: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
       jsbronder@brontes3d.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This trivial patch just clean up MODULE_PARM_DESC newline from
drivers/staging/b3dfg/b3dfg.c .

---
 drivers/staging/b3dfg/b3dfg.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/b3dfg/b3dfg.c b/drivers/staging/b3dfg/b3dfg.c
index 75ebe33..7b18cea 100644
--- a/drivers/staging/b3dfg/b3dfg.c
+++ b/drivers/staging/b3dfg/b3dfg.c
@@ -42,7 +42,7 @@ static unsigned int b3dfg_nbuf = 2;

 module_param_named(buffer_count, b3dfg_nbuf, uint, 0444);

-MODULE_PARM_DESC(buffer_count, "Number of buffers (min 2, default 2)\n");
+MODULE_PARM_DESC(buffer_count, "Number of buffers (min 2, default 2)");

 MODULE_AUTHOR("Daniel Drake <ddrake@brontes3d.com>");
 MODULE_DESCRIPTION("Brontes frame grabber driver");
-- 
1.6.0.6
