Return-Path: <linux-kernel-owner+w=401wt.eu-S933852AbZHWN2w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933852AbZHWN2w (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Aug 2009 09:28:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933853AbZHWN2v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Aug 2009 09:28:51 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:49132 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933645AbZHWN2u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Aug 2009 09:28:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=W4/geRGnc59csPNymC1O7nYvs3pjlXLEzrSGidPMROh1iewn+nH0ErhF6a537TiPlX
         Nt9zTFKUka582IN4IJGmT9kyOZZcAkbAevXGRcWR+aux+wFRmNJgtlF5q9XOkoZp9ofD
         vZPK0ws5I8MmeRrHuFKMnCle+Vzx81XsmZaek=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: "Greg Kroah-Hartman" <gregkh@suse.de>
Cc: devel@driverdev.osuosl.org, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Marcin Slusarz <marcin.slusarz@gmail.com>,
       Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org
Date: Sun, 23 Aug 2009 15:29:19 +0200
Message-Id: <20090823132919.17784.65031.sendpatchset@localhost.localdomain>
In-Reply-To: <20090823132846.17784.13359.sendpatchset@localhost.localdomain>
References: <20090823132846.17784.13359.sendpatchset@localhost.localdomain>
Subject: [PATCH 05/33] Staging: rt3070: update allowed channels list for Japan
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] Staging: rt3070: update allowed channels list for Japan

rt3070 driver allows use of 5G channel 34 while rt{286,287,309}0
drivers don't and quick googling seems to confirm the limitation.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
seems like wireless-regdb-2009.08.17 also needs the update
(s/5170/5180/ for JP)

 drivers/staging/rt2860/chlist.h |    5 -----
 1 file changed, 5 deletions(-)

Index: b/drivers/staging/rt2860/chlist.h
===================================================================
--- a/drivers/staging/rt2860/chlist.h
+++ b/drivers/staging/rt2860/chlist.h
@@ -524,12 +524,7 @@ static CH_REGION ChRegion[] =
 			JAP,
 			{
 				{ 1,   14,  20, BOTH, FALSE},	// 2.4 G, ch 1~14
-#ifndef RT30xx
 				{ 36, 	4,  23, IDOR, FALSE},	// 5G, ch 36~48
-#endif
-#ifdef RT30xx
-				{ 34, 	4,  23, IDOR, FALSE},	// 5G, ch 34~46
-#endif
 				{ 0},							// end
 			}
 		},
