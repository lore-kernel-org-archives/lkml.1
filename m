Return-Path: <linux-kernel-owner+w=401wt.eu-S1753189AbYKACoU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753189AbYKACoU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2008 22:44:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751561AbYKACoJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Oct 2008 22:44:09 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:54870 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751883AbYKACoI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2008 22:44:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=F8RdzZP4164kc94eu/q80gSKkZ3SbksvjGcdyTE5eED97oJAKzo1SFkKKrBxnTZe6b
         IPYEhqyYUZBVkXD0ZRMy39uKTjwIVfqahWvWKwYRpFRvy/m25dtBYAco4uO0Ba+6yfBD
         /RevhnEFZJdPyRQc1qtNb3rC8gtOupeKnz77I=
Date: Sat, 1 Nov 2008 05:43:59 +0300
From: Alexander Beregalov <a.beregalov@gmail.com>
To: linux-kernel@vger.kernel.org, gregkh@suse.de
Subject: [PATCH] Staging: remove double #include
Message-ID: <20081101024359.GD14519@orion>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>
---

 drivers/staging/echo/echo.c     |    1 -
 drivers/staging/me4000/me4000.c |    1 -
 2 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/echo/echo.c b/drivers/staging/echo/echo.c
index b8f2c5e..fd4007e 100644
--- a/drivers/staging/echo/echo.c
+++ b/drivers/staging/echo/echo.c
@@ -106,7 +106,6 @@
 
 #include <linux/kernel.h>	/* We're doing kernel work */
 #include <linux/module.h>
-#include <linux/kernel.h>
 #include <linux/slab.h>
 
 #include "bit_operations.h"
diff --git a/drivers/staging/me4000/me4000.c b/drivers/staging/me4000/me4000.c
index 0b33773..cddac25 100644
--- a/drivers/staging/me4000/me4000.c
+++ b/drivers/staging/me4000/me4000.c
@@ -39,7 +39,6 @@
 #include <asm/uaccess.h>
 #include <asm/io.h>
 #include <asm/system.h>
-#include <asm/uaccess.h>
 
 /* Include-File for the Meilhaus ME-4000 I/O board */
 #include "me4000.h"
