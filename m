Return-Path: <linux-kernel-owner+w=401wt.eu-S1761144AbXK1OyY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761144AbXK1OyY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 09:54:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754413AbXK1OyO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 09:54:14 -0500
Received: from mx1.redhat.com ([66.187.233.31]:56896 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754522AbXK1OyN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 09:54:13 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] AF_RXRPC: Configure crypto correctly for AF_RXRPC
To: mingo@elte.hu, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org, dhowells@redhat.com
Date: Wed, 28 Nov 2007 14:53:58 +0000
Message-ID: <20071128145358.15389.83198.stgit@warthog.procyon.org.uk>
In-Reply-To: <20071122153359.GA7268@elte.hu>
References: <20071122153359.GA7268@elte.hu>
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

