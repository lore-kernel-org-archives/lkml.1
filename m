Return-Path: <linux-kernel-owner+w=401wt.eu-S932996AbXGTJxi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932996AbXGTJxi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 05:53:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756498AbXGTJx3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 05:53:29 -0400
Received: from mx1.redhat.com ([66.187.233.31]:35141 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755421AbXGTJx2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 05:53:28 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] NET: Add missing entries to family name tables
To: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, dhowells@redhat.com
Date: Fri, 20 Jul 2007 10:53:25 +0100
Message-ID: <20070720095325.23049.72209.stgit@warthog.cambridge.redhat.com>
User-Agent: StGIT/0.12.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add missing entries to af_family_clock_key_strings[].

Signed-off-by: David Howells <dhowells@redhat.com>
---

 net/core/sock.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/net/core/sock.c b/net/core/sock.c
index bd209c4..cfed7d4 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -182,7 +182,8 @@ static const char *af_family_clock_key_strings[AF_MAX+1] = {
   "clock-21"       , "clock-AF_SNA"      , "clock-AF_IRDA"     ,
   "clock-AF_PPPOX" , "clock-AF_WANPIPE"  , "clock-AF_LLC"      ,
   "clock-27"       , "clock-28"          , "clock-29"          ,
-  "clock-AF_TIPC"  , "clock-AF_BLUETOOTH", "clock-AF_MAX"
+  "clock-AF_TIPC"  , "clock-AF_BLUETOOTH", "clock-AF_IUCV"     ,
+  "clock-AF_RXRPC" , "clock-AF_MAX"
 };
 #endif
 

