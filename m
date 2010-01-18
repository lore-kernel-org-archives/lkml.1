Return-Path: <linux-kernel-owner+w=401wt.eu-S1753008Ab0ARHSm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753008Ab0ARHSm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 02:18:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752891Ab0ARHSl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 02:18:41 -0500
Received: from miranda.se.axis.com ([193.13.178.8]:55137 "EHLO
	miranda.se.axis.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752347Ab0ARHSl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 02:18:41 -0500
X-Greylist: delayed 1803 seconds by postgrey-1.27 at vger.kernel.org; Mon, 18 Jan 2010 02:18:40 EST
From: Mikael Starvik <mikael.starvik@axis.com>
To: Roel Kluin <roel.kluin@gmail.com>,
       Jesper Nilsson <Jesper.Nilsson@axis.com>,
       linux-cris-kernel <linux-cris-kernel@axis.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Date: Mon, 18 Jan 2010 07:48:20 +0100
Subject: RE: [PATCH] CRIS v32: Typo in crisv32_arbiter_unwatch()?
Thread-Topic: [PATCH] CRIS v32: Typo in crisv32_arbiter_unwatch()?
Thread-Index: AcqXnuWuiawLhsi8RRK7x7EDsPAn2AAa0r3g
Message-ID: <4BEA3FF3CAA35E408EA55C7BE2E61D0546A78E3248@xmail3.se.axis.com>
References: <4B535106.3060007@gmail.com>
In-Reply-To: <4B535106.3060007@gmail.com>
Accept-Language: sv-SE
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: sv-SE
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yes, thank you!

Best Regards
/Mikael

-----Original Message-----
From: Roel Kluin [mailto:roel.kluin@gmail.com] 
Sent: den 17 januari 2010 19:04
To: Mikael Starvik; Jesper Nilsson; linux-cris-kernel; Andrew Morton; LKML
Subject: [PATCH] CRIS v32: Typo in crisv32_arbiter_unwatch()?

With id 1 the wrong bp was unwatched.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
I guess it should be this?

diff --git a/arch/cris/arch-v32/mach-fs/arbiter.c b/arch/cris/arch-v32/mach-fs/arbiter.c
index 84d31bd..82ef293 100644
--- a/arch/cris/arch-v32/mach-fs/arbiter.c
+++ b/arch/cris/arch-v32/mach-fs/arbiter.c
@@ -332,7 +332,7 @@ int crisv32_arbiter_unwatch(int id)
 	if (id == 0)
 		intr_mask.bp0 = regk_marb_no;
 	else if (id == 1)
-		intr_mask.bp2 = regk_marb_no;
+		intr_mask.bp1 = regk_marb_no;
 	else if (id == 2)
 		intr_mask.bp2 = regk_marb_no;
 	else if (id == 3)
