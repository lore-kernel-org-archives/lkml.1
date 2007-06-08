Return-Path: <linux-kernel-owner+w=401wt.eu-S938456AbXFHHZv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938456AbXFHHZv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 03:25:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937983AbXFHHSL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 03:18:11 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:33285 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S937970AbXFHHSJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 03:18:09 -0400
Message-Id: <20070608071553.003907000@sous-sol.org>
References: <20070608071511.159309000@sous-sol.org>
User-Agent: quilt/0.46-1
Date: Fri, 08 Jun 2007 00:15:33 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       David Miller <davem@davemloft.net>, bunk@stusta.de
Subject: [patch 22/32] NET: Fix BMSR_100{HALF,FULL}2 defines in linux/mii.h
Content-Disposition: inline; filename=net-fix-bmsr_100-half-full-2-defines-in-linux-mii.h.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: David Miller <davem@davemloft.net>

Noticed by Matvejchikov Ilya.

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>

---
 include/linux/mii.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- linux-2.6.20.13.orig/include/linux/mii.h
+++ linux-2.6.20.13/include/linux/mii.h
@@ -56,8 +56,8 @@
 #define BMSR_ANEGCOMPLETE       0x0020  /* Auto-negotiation complete   */
 #define BMSR_RESV               0x00c0  /* Unused...                   */
 #define BMSR_ESTATEN		0x0100	/* Extended Status in R15 */
-#define BMSR_100FULL2		0x0200	/* Can do 100BASE-T2 HDX */
-#define BMSR_100HALF2		0x0400	/* Can do 100BASE-T2 FDX */
+#define BMSR_100HALF2           0x0200  /* Can do 100BASE-T2 HDX */
+#define BMSR_100FULL2           0x0400  /* Can do 100BASE-T2 FDX */
 #define BMSR_10HALF             0x0800  /* Can do 10mbps, half-duplex  */
 #define BMSR_10FULL             0x1000  /* Can do 10mbps, full-duplex  */
 #define BMSR_100HALF            0x2000  /* Can do 100mbps, half-duplex */

-- 
