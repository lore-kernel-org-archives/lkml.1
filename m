Return-Path: <linux-kernel-owner+w=401wt.eu-S1762807AbYBGVSW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762807AbYBGVSW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 16:18:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762651AbYBGVCx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 16:02:53 -0500
Received: from wa-out-1112.google.com ([209.85.146.183]:62163 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934798AbYBGVCu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 16:02:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=FHPK99gXFamG5B5vcA1vD2x8q0olqBjbHQhT26gNbPLwajWICTUsLKAn33KaTSj8BfZNtgDA4jZowWpgA2Q8HA5xwaSIw1Hc7kspwSDyc+bh0IiqI3xHO4EkwCjpl7tDlsJOWHr54GkW8cOJsw79VGP7RvCtimC+S08M/cy1pYg=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] ide: remove stale version number
Date: Thu, 7 Feb 2008 22:15:54 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: linux-ide@vger.kernel.org, Robert Hancock <hancockr@shaw.ca>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200802072215.54384.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thursday 03 January 2008, Robert Hancock wrote:

[...]

> How about getting rid of this stupid thing in drivers/ide/ide.c:
> 
> #define       REVISION        "Revision: 7.00alpha2"
> 
> which is used in:
> 
> printk(KERN_INFO "Uniform Multi-Platform E-IDE driver " REVISION "\n");
> 
> It's been 7.00alpha2 for god knows how long, so clearly this version 
> number is not useful..

Cc: Robert Hancock <hancockr@shaw.ca>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

Index: b/drivers/ide/ide.c
===================================================================
--- a/drivers/ide/ide.c
+++ b/drivers/ide/ide.c
@@ -44,8 +44,6 @@
  *  inspiration from lots of linux users, esp.  hamish@zot.apana.org.au
  */
 
-#define	REVISION	"Revision: 7.00alpha2"
-
 #define _IDE_C			/* Tell ide.h it's really us */
 
 #include <linux/module.h>
@@ -1618,7 +1616,7 @@ static int __init ide_init(void)
 {
 	int ret;
 
-	printk(KERN_INFO "Uniform Multi-Platform E-IDE driver " REVISION "\n");
+	printk(KERN_INFO "Uniform Multi-Platform E-IDE driver\n");
 	system_bus_speed = ide_system_bus_speed();
 
 	printk(KERN_INFO "ide: Assuming %dMHz system bus speed "
