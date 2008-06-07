Return-Path: <linux-kernel-owner+w=401wt.eu-S1761530AbYFGBMI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761530AbYFGBMI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 21:12:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759007AbYFGBIz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 21:08:55 -0400
Received: from sous-sol.org ([216.99.217.87]:42321 "EHLO sous-sol.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757381AbYFGBIy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 21:08:54 -0400
Message-Id: <20080607010622.742485555@sous-sol.org>
References: <20080607010215.358296706@sous-sol.org>
User-Agent: quilt/0.46-1
Date: Fri, 06 Jun 2008 18:02:48 -0700
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
       Phil Oester <kernel@linuxace.com>, Patrick McHardy <kaber@trash.net>,
       David S Miller <davem@davemloft.net>
Subject: [patch 33/50] netfilter: xt_iprange: module aliases for xt_iprange
Content-Disposition: inline; filename=netfilter-xt_iprange-module-aliases-for-xt_iprange.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Phil Oester <kernel@linuxace.com>

upstream commit: 01b7a314291b2ef56ad718ee1374a1bac4768b29 

Using iptables 1.3.8 with kernel 2.6.25, rules which include '-m
iprange' don't automatically pull in xt_iprange module.  Below patch
adds module aliases to fix that.  Patch against latest -git, but seems
like a good candidate for -stable also.

Signed-off-by: Phil Oester <kernel@linuxace.com>
Signed-off-by: Patrick McHardy <kaber@trash.net>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 net/netfilter/xt_iprange.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/net/netfilter/xt_iprange.c
+++ b/net/netfilter/xt_iprange.c
@@ -179,3 +179,5 @@ module_exit(iprange_mt_exit);
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>, Jan Engelhardt <jengelh@computergmbh.de>");
 MODULE_DESCRIPTION("Xtables: arbitrary IPv4 range matching");
+MODULE_ALIAS("ipt_iprange");
+MODULE_ALIAS("ip6t_iprange");

-- 
