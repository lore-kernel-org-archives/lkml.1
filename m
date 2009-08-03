Return-Path: <linux-kernel-owner+w=401wt.eu-S1753791AbZHCBDS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753791AbZHCBDS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Aug 2009 21:03:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752018AbZHCBDR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Aug 2009 21:03:17 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:55622 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751685AbZHCBDQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Aug 2009 21:03:16 -0400
Date: Mon, 3 Aug 2009 11:03:14 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Eric Miao <eric.y.miao@gmail.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Marek Vasut <marek.vasut@gmail.com>, Joe Perches <joe@perches.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next: manual merge of the pxa tree with Linus' tree
Message-Id: <20090803110314.1c2c3cca.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Eric,

Today's linux-next merge of the pxa tree got a conflict in MAINTAINERS
between commit 8b58be884a9fd650abb7f7adf3f885fb9cecd79d ("MAINTAINERS:
coalesce name and email address lines") from Linus' tree and commit
4ad9febe53347962225169c5bde2ec030e46ab1d ("Palm Tungsten|C initial
support") from the pxa tree.

Just context changes.  I fixed it up (see below) and can carry the fix as
necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc MAINTAINERS
index 1677158,642cd9a..0000000
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@@ -705,12 -803,15 +705,12 @@@ W:	http://wiki.openmoko.org/wiki/Neo_Fr
  S:	Supported
  
  ARM/TOSA MACHINE SUPPORT
 -P:	Dmitry Eremin-Solenikov
 -M:	dbaryshkov@gmail.com
 -P:	Dirk Opfer
 -M:	dirk@opfer-online.de
 +M:	Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
 +M:	Dirk Opfer <dirk@opfer-online.de>
  S:	Maintained
  
- ARM/PALMTX,PALMT5,PALMLD,PALMTE2 SUPPORT
+ ARM/PALMTX,PALMT5,PALMLD,PALMTE2,PALMTC SUPPORT
 -P:	Marek Vasut
 -M:	marek.vasut@gmail.com
 +M:	Marek Vasut <marek.vasut@gmail.com>
  W:	http://hackndev.com
  S:	Maintained
  
