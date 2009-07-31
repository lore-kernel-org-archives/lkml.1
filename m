Return-Path: <linux-kernel-owner+w=401wt.eu-S1751171AbZGaEjR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751171AbZGaEjR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jul 2009 00:39:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750870AbZGaEjQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Jul 2009 00:39:16 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:32798 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750751AbZGaEjP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jul 2009 00:39:15 -0400
Date: Fri, 31 Jul 2009 14:39:12 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jiri Kosina <jkosina@suse.cz>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Joe Perches <joe@perches.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Markus Heidelberg <markus.heidelberg@web.de>
Subject: linux-next: manual merge of the trivial tree with the  tree
Message-Id: <20090731143912.7a6afdbb.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jiri,

Today's linux-next merge of the trivial tree got a conflict in
MAINTAINERS between commit 24725d1ecf26ba05d74c1cc3ae7467b61a900421
("MAINTAINERS: Update KERNEL JANITORS") from Linus' tree and commit
70301b8cc8a23d57d3e6120c012c86569285efcb ("trivial: update the Kernel
Janitors' web-page URL") from the trivial tree.

Just context differences.  I fixed it up (see below) and can carry the
fix as necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc MAINTAINERS
index fa86fd5,354cc16..0000000
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@@ -2912,13 -3374,16 +2912,13 @@@ F:	Makefil
  F:	scripts/Makefile.*
  
  KERNEL JANITORS
 -P:	Several
  L:	kernel-janitors@vger.kernel.org
- W:	http://www.kerneljanitors.org/
+ W:	http://janitor.kernelnewbies.org/
 -S:	Maintained
 +S:	Odd fixes
  
  KERNEL NFSD, SUNRPC, AND LOCKD SERVERS
 -P:	J. Bruce Fields
 -M:	bfields@fieldses.org
 -P:	Neil Brown
 -M:	neilb@suse.de
 +M:	"J. Bruce Fields" <bfields@fieldses.org>
 +M:	Neil Brown <neilb@suse.de>
  L:	linux-nfs@vger.kernel.org
  W:	http://nfs.sourceforge.net/
  S:	Supported
