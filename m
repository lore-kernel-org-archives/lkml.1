Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756712Ab0BJXYF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Feb 2010 18:24:05 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:44999 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755511Ab0BJXYB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Feb 2010 18:24:01 -0500
Date: Thu, 11 Feb 2010 10:23:59 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Sascha Hauer <s.hauer@pengutronix.de>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Amit Kucheria <amit.kucheria@canonical.com>
Subject: linux-next: manual merge of the i.MX tree with Linus' tree
Message-Id: <20100211102359.dad2539d.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.0beta7 (GTK+ 2.18.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sascha,

Today's linux-next merge of the i.MX tree got a conflict in
arch/arm/Makefile between commit 95b8f20fd6a2694a16b8addb190b942bfb670c88
("ARM: fix badly placed mach/plat entries in Kconfig & Makefile") from
Linus' tree and commit b996b5830364c1b1d2469be574f4ebe831987ba9 ("mxc:
Add support for the Babbage board (i.MX5)") from the i.MX tree.

I fixed it up (see below) and can carry the fix for a while.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/Makefile
index c7f6f41,056daf8..0000000
--- a/arch/arm/Makefile
+++ b/arch/arm/Makefile
@@@ -146,7 -146,7 +146,8 @@@ machine-$(CONFIG_ARCH_MX1)		:= mx
  machine-$(CONFIG_ARCH_MX2)		:= mx2
  machine-$(CONFIG_ARCH_MX25)		:= mx25
  machine-$(CONFIG_ARCH_MX3)		:= mx3
+ machine-$(CONFIG_ARCH_MX5)		:= mx5
 +machine-$(CONFIG_ARCH_MXC91231)		:= mxc91231
  machine-$(CONFIG_ARCH_NETX)		:= netx
  machine-$(CONFIG_ARCH_NOMADIK)		:= nomadik
  machine-$(CONFIG_ARCH_NS9XXX)		:= ns9xxx
