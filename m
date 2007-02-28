Return-Path: <linux-kernel-owner+w=401wt.eu-S1751090AbXB1ThN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751090AbXB1ThN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Feb 2007 14:37:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751079AbXB1ThN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Feb 2007 14:37:13 -0500
Received: from 3a.49.1343.static.theplanet.com ([67.19.73.58]:39215 "EHLO
	pug.o-hand.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751090AbXB1ThM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Feb 2007 14:37:12 -0500
X-Greylist: delayed 1410 seconds by postgrey-1.27 at vger.kernel.org; Wed, 28 Feb 2007 14:37:11 EST
Subject: [PATCH 0/5] Add LZO Compression
From: Richard Purdie <rpurdie@openedhand.com>
To: LKML <linux-kernel@vger.kernel.org>, David Woodhouse <dwmw2@infradead.org>,
       herbert@gondor.apana.org.au
Cc: linux-mtd <linux-mtd@lists.infradead.org>, linux-crypto@vger.kernel.org
Content-Type: text/plain
Date: Wed, 28 Feb 2007 19:13:18 +0000
Message-Id: <1172689998.16062.135.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The following patch series adds LZO compression support to the kernel
and exposes it in a variety of places (jffs2, crypto).

This is particularly useful for jffs2 where significant boot time
speedups (~10%) and file read speed improvements (~40%) are seen when
its used with only a slight drop in file compression ratio.

It also adds a favourlzo mode to jffs2 which is similar to the existing
size mode but lets lzo compression win if the lzo compressed size is
"similar" to but not the best compression ratio. This means we can keep
zlib compression where it makes a significant difference to compressed
file size.

The final jffs2 patch which starts adding sysfs support is something I
have around from testing and I'm including it for comments to see if its
desirable upstream. It could be extended further to allow greater
control of jffs2 at runtime.

Richard





