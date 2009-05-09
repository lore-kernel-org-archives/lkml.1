Return-Path: <linux-kernel-owner+w=401wt.eu-S1753199AbZEIITY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753199AbZEIITY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 May 2009 04:19:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750861AbZEIITK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 May 2009 04:19:10 -0400
Received: from mga14.intel.com ([143.182.124.37]:20164 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750826AbZEIITI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 May 2009 04:19:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,320,1239001200"; 
   d="scan'208";a="140982345"
Date: Sat, 9 May 2009 16:18:42 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Matt Mackall <mpm@selenic.com>,
       Andi Kleen <andi@firstfloor.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH 6/8] pagemap: document 9 more exported page flags
Message-ID: <20090509081842.GA8168@localhost>
References: <20090508105320.316173813@intel.com> <20090508111031.568178884@intel.com> <20090509171125.8D08.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090509171125.8D08.A69D9226@jp.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 09, 2009 at 04:13:40PM +0800, KOSAKI Motohiro wrote:
> > Also add short descriptions for all of the 20 exported page flags.
> > 
> > Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
> > ---
> >  Documentation/vm/pagemap.txt |   62 +++++++++++++++++++++++++++++++++
> >  1 file changed, 62 insertions(+)
> > 
> > --- linux.orig/Documentation/vm/pagemap.txt
> > +++ linux/Documentation/vm/pagemap.txt
> > @@ -49,6 +49,68 @@ There are three components to pagemap:
> >       8. WRITEBACK
> >       9. RECLAIM
> >      10. BUDDY
> > +    11. MMAP
> > +    12. ANON
> > +    13. SWAPCACHE
> > +    14. SWAPBACKED
> > +    15. COMPOUND_HEAD
> > +    16. COMPOUND_TAIL
> > +    16. HUGE
> 
> nit. 16 appear twice.

Good catch!

Andrew, this fix can be folded into the last patch.
---
pagemap: fix HUGE numbering

Thanks to KOSAKI Motohiro for catching this.

cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 Documentation/vm/pagemap.txt |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux.orig/Documentation/vm/pagemap.txt
+++ linux/Documentation/vm/pagemap.txt
@@ -55,7 +55,7 @@ There are three components to pagemap:
     14. SWAPBACKED
     15. COMPOUND_HEAD
     16. COMPOUND_TAIL
-    16. HUGE
+    17. HUGE
     18. UNEVICTABLE
     19. HWPOISON
     20. NOPAGE
