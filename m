Return-Path: <linux-kernel-owner+w=401wt.eu-S1764030AbZCaXVl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764030AbZCaXVl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 19:21:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761029AbZCaXUT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 19:20:19 -0400
Received: from sous-sol.org ([216.99.217.87]:33109 "EHLO x200.localdomain"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759194AbZCaXUQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 19:20:16 -0400
Message-Id: <20090331231339.990044661@sous-sol.org>
User-Agent: quilt/0.47-1
Date: Tue, 31 Mar 2009 16:10:48 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Geert Uytterhoeven <geert@linux-m68k.org>,
       David S Miller <davem@davemloft.net>
Subject: [patch 03/45] dnet: drivers/net/dnet.c needs <linux/io.h>
References: <20090331231045.719396245@sous-sol.org>
Content-Disposition: inline; filename=dnet-drivers-net-dnet.c-needs-linux-io.h.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Geert Uytterhoeven <geert@linux-m68k.org>

[ Upstream commit 142071b83426674ef2dab98cf2a6627328d0988e ]

On m68k:
| drivers/net/dnet.c: In function 'dnet_readw_mac':
| drivers/net/dnet.c:36: error: implicit declaration of function 'writel'
| drivers/net/dnet.c:43: error: implicit declaration of function 'readl'
| drivers/net/dnet.c: In function 'dnet_probe':
| drivers/net/dnet.c:873: error: implicit declaration of function 'ioremap'
| drivers/net/dnet.c:873: warning: assignment makes pointer from integer without a cast
| drivers/net/dnet.c:939: error: implicit declaration of function 'iounmap'

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 drivers/net/dnet.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/dnet.c
+++ b/drivers/net/dnet.c
@@ -9,6 +9,7 @@
  * published by the Free Software Foundation.
  */
 #include <linux/version.h>
+#include <linux/io.h>
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <linux/kernel.h>

