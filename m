Return-Path: <linux-kernel-owner+w=401wt.eu-S932107AbXK1OiY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932107AbXK1OiY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 09:38:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759498AbXK1OiM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 09:38:12 -0500
Received: from mx1.redhat.com ([66.187.233.31]:60084 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759652AbXK1OiJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 09:38:09 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] AF_RXRPC: Configure crypto correctly for AF_RXRPC
To: mingo@elte.hu, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org, dhowells@redhat.com
Date: Wed, 28 Nov 2007 14:37:53 +0000
Message-ID: <20071128143753.15234.29444.stgit@warthog.procyon.org.uk>
In-Reply-To: 20071122153359.GA7268@elte.hu
References: 20071122153359.GA7268@elte.hu
User-Agent: StGIT/0.13
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

AF_RXRPC uses the crypto services, so should depend on or select CRYPTO.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 net/rxrpc/Kconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/net/rxrpc/Kconfig b/net/rxrpc/Kconfig
index e662f1d..0d3103c 100644
--- a/net/rxrpc/Kconfig
+++ b/net/rxrpc/Kconfig
@@ -5,6 +5,7 @@
 config AF_RXRPC
 	tristate "RxRPC session sockets"
 	depends on INET && EXPERIMENTAL
+	select CRYPTO
 	select KEYS
 	help
 	  Say Y or M here to include support for RxRPC session sockets (just

