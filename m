Return-Path: <linux-kernel-owner+w=401wt.eu-S1762139AbZFIKb6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762139AbZFIKb6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 06:31:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932110AbZFIKU7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 06:20:59 -0400
Received: from kroah.org ([198.145.64.141]:55269 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932133AbZFIKU6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 06:20:58 -0400
X-Mailbox-Line: From greg@blue.kroah.org Tue Jun  9 02:41:06 2009
Message-Id: <20090609094106.388267421@blue.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 09 Jun 2009 02:39:49 -0700
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
       alan@lxorguk.ukuu.org.uk, Herbert Xu <herbert@gondor.apana.org.au>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 61/87] crypto: padlock - Revert aes-all alias to aes
References: <20090609093848.204935043@blue.kroah.org>
Content-Disposition: inline; filename=crypto-padlock-revert-aes-all-alias-to-aes.patch
In-Reply-To: <20090609094451.GA26439@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.29-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Herbert Xu <herbert@gondor.apana.org.au>

commit acd246b7494c629aa617da49716409566cf52149 upstream.

Since the padlock-aes driver doesn't require a fallback (it's
only padlock-sha that does), it should use the aes alias rather
than aes-all so that ones that do need a fallback can use it.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Chuck Ebbert <cebbert@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/crypto/padlock-aes.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/crypto/padlock-aes.c
+++ b/drivers/crypto/padlock-aes.c
@@ -489,4 +489,4 @@ MODULE_DESCRIPTION("VIA PadLock AES algo
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Michal Ludvig");
 
-MODULE_ALIAS("aes-all");
+MODULE_ALIAS("aes");


