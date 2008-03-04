Return-Path: <linux-kernel-owner+w=401wt.eu-S1762360AbYCDIHW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762360AbYCDIHW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 03:07:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753901AbYCDIHE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 03:07:04 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:52827 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750882AbYCDIHD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 03:07:03 -0500
Date: Tue, 4 Mar 2008 09:06:44 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: [patch] mark netconsole broken
Message-ID: <20080304080644.GC2947@elte.hu>
References: <20080203150246.50647fa4.akpm@linux-foundation.org> <20080203150744.cf7d0415.akpm@linux-foundation.org> <20080204044304.d244e761.akpm@linux-foundation.org> <20080206003412.dca555d4.akpm@linux-foundation.org> <20080206011643.d9021649.akpm@linux-foundation.org> <20080303210540.cea55e13.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080303210540.cea55e13.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andrew Morton <akpm@linux-foundation.org> wrote:

> This netconsole regression is still present in current mainline.  
> Rafael, can you please add it to the list?
> 
> It's strange that I can hit it on three separate machines with e100 
> and e1000 yet nobody else has reported it (afaik).  Is nobody using 
> netconsole?

i'd suggest the patch below, to mark it broken.

	Ingo

---
 drivers/net/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux/drivers/net/Kconfig
===================================================================
--- linux.orig/drivers/net/Kconfig
+++ linux/drivers/net/Kconfig
@@ -3109,7 +3109,7 @@ config NET_FC
 
 config NETCONSOLE
 	tristate "Network console logging support (EXPERIMENTAL)"
-	depends on EXPERIMENTAL
+	depends on EXPERIMENTAL && BROKEN
 	---help---
 	If you want to log kernel messages over the network, enable this.
 	See <file:Documentation/networking/netconsole.txt> for details.
