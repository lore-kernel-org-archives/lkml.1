Return-Path: <linux-kernel-owner+w=401wt.eu-S1761998AbXLMGqv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761998AbXLMGqv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 01:46:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759772AbXLMGiG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 01:38:06 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:56573 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758775AbXLMGiF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 01:38:05 -0500
Date: Wed, 12 Dec 2007 22:35:11 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, davem@davemloft.net
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       David Howells <dhowells@redhat.com>,
       Herbert Xu <herbert@gondor.apana.org.au>
Subject: [patch 26/36] RXRPC: Add missing select on CRYPTO
Message-ID: <20071213063511.GA25301@kroah.com>
References: <20071213062511.265908583@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="rxrpc-add-missing-select-on-crypto.patch"
In-Reply-To: <20071213063308.GA25301@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.22-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: David Howells <dhowells@redhat.com>

[RXRPC]: Add missing select on CRYPTO

[ Upstream commit: d5a784b3719ae364f49ecff12a0248f6e4252720 ]

AF_RXRPC uses the crypto services, so should depend on or select CRYPTO.

Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/rxrpc/Kconfig |    1 +
 1 file changed, 1 insertion(+)

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

-- 
