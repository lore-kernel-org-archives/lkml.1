Return-Path: <linux-kernel-owner+w=401wt.eu-S1759164AbYG3Xfa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759164AbYG3Xfa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 19:35:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758982AbYG3Xex
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 19:34:53 -0400
Received: from cantor.suse.de ([195.135.220.2]:35602 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760637AbYG3Xew (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 19:34:52 -0400
Date: Wed, 30 Jul 2008 16:26:59 -0700
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
       alan@lxorguk.ukuu.org.uk, "David S. Miller" <davem@davemloft.net>
Subject: [patch 08/29] sparc64: Do not define BIO_VMERGE_BOUNDARY.
Message-ID: <20080730232659.GI30670@suse.de>
References: <20080730231003.655833364@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="sparc64-do-not-define-bio_vmerge_boundary.patch"
In-Reply-To: <20080730232451.GA30670@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.25-stable review patch.  If anyone has any objections, please let us 
know.

------------------
From: David S. Miller <davem@davemloft.net>

[ Upstream commit 74988bd85d1cb97987534fd7ffbc570e81145418 ]

The IOMMU code and the block layer can split things
up using different rules, so this can't work reliably.

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 include/asm-sparc64/io.h |    1 -
 1 file changed, 1 deletion(-)

--- a/include/asm-sparc64/io.h
+++ b/include/asm-sparc64/io.h
@@ -16,7 +16,6 @@
 /* BIO layer definitions. */
 extern unsigned long kern_base, kern_size;
 #define page_to_phys(page)	(page_to_pfn(page) << PAGE_SHIFT)
-#define BIO_VMERGE_BOUNDARY	8192
 
 static inline u8 _inb(unsigned long addr)
 {

-- 
