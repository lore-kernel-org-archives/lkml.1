Return-Path: <linux-kernel-owner+w=401wt.eu-S1765484AbYHRTm4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765484AbYHRTm4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 15:42:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761392AbYHRTjG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 15:39:06 -0400
Received: from ns1.suse.de ([195.135.220.2]:49197 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932586AbYHRTjE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 15:39:04 -0400
Date: Mon, 18 Aug 2008 12:20:32 -0700
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
       alan@lxorguk.ukuu.org.uk,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>,
       Al Viro <viro@zeniv.linux.org.uk>, Jeff Dike <jdike@addtoit.com>
Subject: [patch 34/49] uml: missing export of csum_partial() on uml/amd64
Message-ID: <20080818192032.GI10350@suse.de>
References: <20080818191012.663450219@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="uml-missing-export-of-csum_partial-on-uml-amd64.patch"
In-Reply-To: <20080818191834.GA10350@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.25-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Al Viro <viro@ftp.linux.org.uk>

commit 3e3b48e5198544dd90e27265a70c1a834139e025 upstream

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Cc: Jeff Dike <jdike@addtoit.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/um/sys-x86_64/ksyms.c |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/um/sys-x86_64/ksyms.c
+++ b/arch/um/sys-x86_64/ksyms.c
@@ -14,3 +14,4 @@ EXPORT_SYMBOL(__up_wakeup);
 
 /*XXX: we need them because they would be exported by x86_64 */
 EXPORT_SYMBOL(__memcpy);
+EXPORT_SYMBOL(csum_partial);

-- 
