Return-Path: <linux-kernel-owner+w=401wt.eu-S1757131AbZLNMJe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757131AbZLNMJe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 07:09:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757093AbZLNMJc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 07:09:32 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:50472 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757096AbZLNMJb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 07:09:31 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: andrew hendry <andrew.hendry@gmail.com>
Subject: Re: [GIT]: Networking
Date: Mon, 14 Dec 2009 12:53:41 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31-14-generic; KDE/4.3.2; x86_64; ; )
Cc: David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, Henner Eisen <eis@baty.hanse.de>
References: <20091205.193505.193701079.davem@davemloft.net> <20091213.202037.229738549.davem@davemloft.net> <d45a3acc0912132026w5ab6b3b3x3f211566779257d3@mail.gmail.com>
In-Reply-To: <d45a3acc0912132026w5ab6b3b3x3f211566779257d3@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-Id: <200912141253.42017.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX19vbqjxK3/HA1EF/gXerD5x42nIMGGTzdaSmjZ
 aWhS1amCoariS8dpRMWs4N30/LNnjs/x8VxcNsiNdBswCcRQyb
 ULOqq2+mWkSHKrPzLyxFw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 14 December 2009, andrew hendry wrote:
> Thanks, I didn't know X.25 was actively maintained. I get bounces.
> Is the the maintainers out of date?

>From looking at the posts on the x.25 mailing list and the changes
that went into the kernel during the last three years in that area,
I think it is safe to say that you are now the maintainer ;-).

The last mail on this topic from Henner Eisen was around 2001.

> AX.25 NETWORK LAYER
> M:      Ralf Baechle <ralf@linux-mips.org>
> 
> X.25 NETWORK LAYER
> M:      Henner Eisen <eis@baty.hanse.de>

How about this change?

--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5839,9 +5839,9 @@ F:	sound/soc/codecs/wm8350.c
 F:	sound/soc/codecs/wm8400.c
 
 X.25 NETWORK LAYER
-M:	Henner Eisen <eis@baty.hanse.de>
+M:	Andrew Hendry <andrew.hendry@gmail.com>
 L:	linux-x25@vger.kernel.org
-S:	Maintained
+S:	Odd Fixes
 F:	Documentation/networking/x25*
 F:	include/net/x25*
 F:	net/x25/
