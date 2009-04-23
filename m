Return-Path: <linux-kernel-owner+w=401wt.eu-S1757000AbZDWUot@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757000AbZDWUot (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 16:44:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754994AbZDWUoa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 16:44:30 -0400
Received: from mail-bw0-f163.google.com ([209.85.218.163]:49338 "EHLO
	mail-bw0-f163.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754592AbZDWUo1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 16:44:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:mime-version:content-disposition
         :message-id:content-type:content-transfer-encoding;
        b=KX6IofhNFv6IDS2DDvgUdcnOObJ7CCPMHbRRPP57bGBHjw7iJNkPJOZlVVcEOfbn9T
         Q0/8LV6qtkcu1PxJAsENObNTFW0cZfAlIJ2CiOVRk+Qv7fAeVhcgwkdMg0iGY68XVDwx
         KafY7uawE4mPBPrzoEW/EV/apLaF2wvEC1kdU=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       Joe Perches <joe@perches.com>,
       David Brownell <dbrownell@users.sourceforge.net>
Subject: [PATCH] palm_bk3710: palm_bk3710_udmatimings[] CodingStyle fixup
Date: Thu, 23 Apr 2009 22:48:29 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.29-next-20090403; KDE/4.2.2; i686; ; )
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200904232248.29263.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Remove superfluous commas and add missing whitespaces.

Noticed-by: Joe Perches <joe@perches.com>
Cc: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/palm_bk3710.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

Index: b/drivers/ide/palm_bk3710.c
===================================================================
--- a/drivers/ide/palm_bk3710.c
+++ b/drivers/ide/palm_bk3710.c
@@ -66,12 +66,12 @@ struct palm_bk3710_udmatiming {
 };
 
 static const struct palm_bk3710_udmatiming palm_bk3710_udmatimings[6] = {
-	{160, 240 / 2,},	/* UDMA Mode 0 */
-	{125, 160 / 2,},	/* UDMA Mode 1 */
-	{100, 120 / 2,},	/* UDMA Mode 2 */
-	{100, 90 / 2,},		/* UDMA Mode 3 */
-	{100, 60 / 2,},		/* UDMA Mode 4 */
-	{85,  40 / 2,},		/* UDMA Mode 5 */
+	{ 160, 240 / 2 },	/* UDMA Mode 0 */
+	{ 125, 160 / 2 },	/* UDMA Mode 1 */
+	{ 100, 120 / 2 },	/* UDMA Mode 2 */
+	{ 100,  90 / 2 },	/* UDMA Mode 3 */
+	{ 100,  60 / 2 },	/* UDMA Mode 4 */
+	{  85,  40 / 2 },	/* UDMA Mode 5 */
 };
 
 static void palm_bk3710_setudmamode(void __iomem *base, unsigned int dev,
