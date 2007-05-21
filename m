Return-Path: <linux-kernel-owner+w=401wt.eu-S935082AbXEUTow@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935082AbXEUTow (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 15:44:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933775AbXEUT15
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 15:27:57 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:52563 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933766AbXEUT1z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 15:27:55 -0400
Message-Id: <20070521191751.994432000@sous-sol.org>
References: <20070521191612.800400000@sous-sol.org>
User-Agent: quilt/0.46-1
Date: Mon, 21 May 2007 12:17:09 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, David Miller <davem@davemloft.net>,
       bunk@stusta.de
Subject: [patch 57/69] SPARC64: Bump PROMINTR_MAX to 32.
Content-Disposition: inline; filename=sparc64-bump-promintr_max-to-32.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: David Miller <davem@davemloft.net>

Some devices have more than 15 which was the previous
setting.

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>

---
 include/asm-sparc64/openprom.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.21.1.orig/include/asm-sparc64/openprom.h
+++ linux-2.6.21.1/include/asm-sparc64/openprom.h
@@ -177,7 +177,7 @@ struct linux_nodeops {
 /* More fun PROM structures for device probing. */
 #define PROMREG_MAX     24
 #define PROMVADDR_MAX   16
-#define PROMINTR_MAX    15
+#define PROMINTR_MAX    32
 
 struct linux_prom_registers {
 	unsigned which_io;	/* hi part of physical address			*/

-- 
