Return-Path: <linux-kernel-owner+w=401wt.eu-S936027AbXEUT4r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936027AbXEUT4r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 15:56:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934312AbXEUTbR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 15:31:17 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:52721 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765636AbXEUTbN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 15:31:13 -0400
Message-Id: <20070521191729.006384000@sous-sol.org>
References: <20070521191612.800400000@sous-sol.org>
User-Agent: quilt/0.46-1
Date: Mon, 21 May 2007 12:16:45 -0700
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
       bunk@stusta.de, Sergei Shtylyov <sshtylyov@ru.mvista.com>,
       Jeff Garzik <jgarzik@pobox.com>, Matt Mackall <mpm@selenic.com>
Subject: [patch 33/69] NETPOLL: Remove CONFIG_NETPOLL_RX
Content-Disposition: inline; filename=netpoll-remove-config_netpoll_rx.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Sergei Shtylyov <sshtylyov@ru.mvista.com>

Get rid of the CONFIG_NETPOLL_RX option completely since all the
dependencies have been removed long ago...

Signed-off-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Acked-by: Jeff Garzik <jgarzik@pobox.com>
Acked-by: Matt Mackall <mpm@selenic.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>

---
 drivers/net/Kconfig |    5 -----
 1 file changed, 5 deletions(-)

--- linux-2.6.21.1.orig/drivers/net/Kconfig
+++ linux-2.6.21.1/drivers/net/Kconfig
@@ -2929,11 +2929,6 @@ endif #NETDEVICES
 config NETPOLL
 	def_bool NETCONSOLE
 
-config NETPOLL_RX
-	bool "Netpoll support for trapping incoming packets"
-	default n
-	depends on NETPOLL
-
 config NETPOLL_TRAP
 	bool "Netpoll traffic trapping"
 	default n

-- 
