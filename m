Return-Path: <linux-kernel-owner+w=401wt.eu-S1030555AbXBUHYn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030555AbXBUHYn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 02:24:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030561AbXBUHYn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 02:24:43 -0500
Received: from mail.sf-mail.de ([62.27.20.61]:43991 "EHLO mail.sf-mail.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030555AbXBUHYm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 02:24:42 -0500
From: Rolf Eike Beer <eike-kernel@sf-tec.de>
To: akpm@linux-foundation.org
Subject: [PATCH 1/2][IPX] Remove outdated information from Kconfig
Date: Tue, 20 Feb 2007 19:58:08 +0100
User-Agent: KMail/1.9.6
Cc: trivial@kernel.org, linux-kernel@vger.kernel.org, acme@conectiva.com.br,
       netdev@vger.kernel.org
References: <200702201957.13531.eike-kernel@sf-tec.de>
In-Reply-To: <200702201957.13531.eike-kernel@sf-tec.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702201958.09312.eike-kernel@sf-tec.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

SPX was removed in early 2.5. How to connect to a Mac or the other OS isn't
hard to find out these days.

Signed-off-by: Rolf Eike Beer <eike-kernel@sf-tec.de>

---
commit 0566e9a5f19ca9fe1982e2b4a89aff131cc6525b
tree 20b72b4e347a0ff926f82188bb296c2b3a8911f5
parent ce4e52a8be675c1724fa3af503ff1c75478ff2e8
author Rolf Eike Beer <eike-kernel@sf-tec.de> Tue, 20 Feb 2007 19:43:37 +0100
committer Rolf Eike Beer <eike-kernel@sf-tec.de> Tue, 20 Feb 2007 19:43:37 +0100

 net/ipx/Kconfig |    6 +-----
 1 files changed, 1 insertions(+), 5 deletions(-)

diff --git a/net/ipx/Kconfig b/net/ipx/Kconfig
index 980a826..e9ad006 100644
--- a/net/ipx/Kconfig
+++ b/net/ipx/Kconfig
@@ -16,8 +16,7 @@ config IPX
 	  support", below.
 
 	  IPX is similar in scope to IP, while SPX, which runs on top of IPX,
-	  is similar to TCP. There is also experimental support for SPX in
-	  Linux (see "SPX networking", below).
+	  is similar to TCP.
 
 	  To turn your Linux box into a fully featured NetWare file server and
 	  IPX router, say Y here and fetch either lwared from
@@ -26,9 +25,6 @@ config IPX
 	  information, read the IPX-HOWTO available from
 	  <http://www.tldp.org/docs.html#howto>.
 
-	  General information about how to connect Linux, Windows machines and
-	  Macs is on the WWW at <http://www.eats.com/linux_mac_win.html>.
-
 	  The IPX driver would enlarge your kernel by about 16 KB. To compile
 	  this driver as a module, choose M here: the module will be called ipx.
 	  Unless you want to integrate your Linux box with a local Novell
