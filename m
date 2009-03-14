Return-Path: <linux-kernel-owner+w=401wt.eu-S1753473AbZCNBU7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753473AbZCNBU7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 21:20:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751973AbZCNBTq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 21:19:46 -0400
Received: from kroah.org ([198.145.64.141]:34725 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751539AbZCNBTo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 21:19:44 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Mar 13 18:10:31 2009
Message-Id: <20090314011031.704352984@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 13 Mar 2009 18:09:40 -0700
From: Greg KH <gregkh@suse.de>
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
       alan@lxorguk.ukuu.org.uk, "David S. Miller" <davem@davemloft.net>
Subject: [patch 003/114] sparc64: Fix crashes in jbusmc_print_dimm()
References: <20090314010937.416083662@mini.kroah.org>
Content-Disposition: inline; filename=sparc64-fix-crashes-in-jbusmc_print_dimm.patch
In-Reply-To: <20090314011649.GA26170@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: David S. Miller <davem@davemloft.net>

[ Upstream commit 1b0e235cc9bfae4bc0f5cd0cba929206fb0f6a64 ]

Return was missing for the case where there is no dimm
info match.

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/sparc64/kernel/chmc.c |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/sparc64/kernel/chmc.c
+++ b/arch/sparc64/kernel/chmc.c
@@ -306,6 +306,7 @@ static int jbusmc_print_dimm(int syndrom
 		buf[1] = '?';
 		buf[2] = '?';
 		buf[3] = '\0';
+		return 0;
 	}
 	p = dp->controller;
 	prop = &p->layout;


