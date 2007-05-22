Return-Path: <linux-kernel-owner+w=401wt.eu-S933826AbXEVM5p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933826AbXEVM5p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 08:57:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758003AbXEVM5Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 08:57:25 -0400
Received: from mx1.redhat.com ([66.187.233.31]:34628 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757507AbXEVM5Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 08:57:24 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 1/2] AF_RXRPC: AF_RXRPC depends on IPv4
To: akpm@osdl.org
Cc: linux-kernel@vger.kernel.org, netdeg@vger.kernel.org, dhowells@redhat.com
Date: Tue, 22 May 2007 13:56:05 +0100
Message-ID: <20070522125605.27625.42682.stgit@warthog.cambridge.redhat.com>
User-Agent: StGIT/0.12.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add a dependency for CONFIG_AF_RXRPC on CONFIG_INET.  This fixes this error:

net/built-in.o: In function `rxrpc_get_peer':
(.text+0x42824): undefined reference to `ip_route_output_key'

Signed-off-by: David Howells <dhowells@redhat.com>
---

 net/rxrpc/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/rxrpc/Kconfig b/net/rxrpc/Kconfig
index 91b3d52..e662f1d 100644
--- a/net/rxrpc/Kconfig
+++ b/net/rxrpc/Kconfig
@@ -4,7 +4,7 @@
 
 config AF_RXRPC
 	tristate "RxRPC session sockets"
-	depends on EXPERIMENTAL
+	depends on INET && EXPERIMENTAL
 	select KEYS
 	help
 	  Say Y or M here to include support for RxRPC session sockets (just

