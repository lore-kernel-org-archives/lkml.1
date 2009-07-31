Return-Path: <linux-kernel-owner+w=401wt.eu-S1751873AbZGaAeA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751873AbZGaAeA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 20:34:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751199AbZGaAeA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 20:34:00 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:36063 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751076AbZGaAd7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 20:33:59 -0400
Date: Fri, 31 Jul 2009 10:33:54 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Russell King <rmk@arm.linux.org.uk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Hartley Sweeten <hartleys@visionengravers.com>,
       Ryan Mallon <ryan@bluewatersys.com>, Joe Perches <joe@perches.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next: manual merge of the arm tree with Linus' tree
Message-Id: <20090731103354.5e7fdd42.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Russell,

Today's linux-next merge of the arm tree got a conflict in MAINTAINERS
between commit 8b58be884a9fd650abb7f7adf3f885fb9cecd79d ("MAINTAINERS:
coalesce name and email address lines") from Linus' tree and commit
d19d36672ee379f26b79df985a9a2e5afb3f1df1 ("[ARM] 5599/1: MAINTAINERS:
update for EP93XX ARM") from the arm tree.

I fixed it up (see below) and can carry the fix as necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc MAINTAINERS
index 79471ba,1be6a0c..0000000
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@@ -535,12 -604,18 +535,15 @@@ W:	http://maxim.org.za/at91_26.htm
  S:	Maintained
  
  ARM/CIRRUS LOGIC EP93XX ARM ARCHITECTURE
- M:	Lennert Buytenhek <kernel@wantstofly.org>
 -P:	Hartley Sweeten
 -M:	hsweeten@visionengravers.com
 -P:	Ryan Mallon
 -M:	ryan@bluewatersys.com
++M:	Hartley Sweeten <hsweeten@visionengravers.com>
++M:	Ryan Mallon <ryan@bluewatersys.com>
  L:	linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)
  S:	Maintained
+ F:	arch/arm/mach-ep93xx/
+ F:	arch/arm/mach-ep93xx/include/mach/
  
  ARM/CIRRUS LOGIC EDB9315A MACHINE SUPPORT
 -P:	Lennert Buytenhek
 -M:	kernel@wantstofly.org
 +M:	Lennert Buytenhek <kernel@wantstofly.org>
  L:	linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)
  S:	Maintained
  
