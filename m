Return-Path: <linux-kernel-owner+w=401wt.eu-S935341AbXHGUrm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935341AbXHGUrm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 16:47:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760895AbXHGUqp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 16:46:45 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:51312 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935117AbXHGUqn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 16:46:43 -0400
Date: Tue, 7 Aug 2007 13:43:01 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk, bunk@stusta.de,
       "David S. Miller" <davem@davemloft.net>
Subject: [2.6.22.2 review 07/84] Missing header include in ipt_iprange.h
Message-ID: <20070807204301.GH23028@kroah.com>
References: <20070807204034.882009319@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="missing-header-include-in-ipt_iprange.h.patch"
In-Reply-To: <20070807204157.GA23028@kroah.com>
User-Agent: Mutt/1.5.15 (2007-04-06)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Bunk <bunk@stusta.de>

[NETFILTER]: ipt_iprange.h must #include <linux/types.h>

ipt_iprange.h must #include <linux/types.h> since it uses __be32.

This patch fixes kernel Bugzilla #7604.

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 include/linux/netfilter_ipv4/ipt_iprange.h |    2 ++
 1 file changed, 2 insertions(+)

--- a/include/linux/netfilter_ipv4/ipt_iprange.h
+++ b/include/linux/netfilter_ipv4/ipt_iprange.h
@@ -1,6 +1,8 @@
 #ifndef _IPT_IPRANGE_H
 #define _IPT_IPRANGE_H
 
+#include <linux/types.h>
+
 #define IPRANGE_SRC		0x01	/* Match source IP address */
 #define IPRANGE_DST		0x02	/* Match destination IP address */
 #define IPRANGE_SRC_INV		0x10	/* Negate the condition */

-- 
