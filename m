Return-Path: <linux-kernel-owner+w=401wt.eu-S1762831AbYDZUbm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762831AbYDZUbm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2008 16:31:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761876AbYDZUb1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Apr 2008 16:31:27 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51522 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761252AbYDZUb0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2008 16:31:26 -0400
Date: Sat, 26 Apr 2008 13:30:49 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>, Adrian Bunk <bunk@kernel.org>,
       Harvey Harrison <harvey.harrison@gmail.com>,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: If you want me to quit I will quit
Message-Id: <20080426133049.187e255c.akpm@linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0804261213320.2813@woody.linux-foundation.org>
References: <1209190455.14173.13.camel@brick>
	<20080426110044.GB2252@cs181133002.pp.htv.fi>
	<20080426075132.b0fdbe13.akpm@linux-foundation.org>
	<20080426152341.GI2252@cs181133002.pp.htv.fi>
	<20080426084420.8e61c379.akpm@linux-foundation.org>
	<20080426171604.GN2252@cs181133002.pp.htv.fi>
	<alpine.LFD.1.10.0804261024580.2813@woody.linux-foundation.org>
	<481379BB.5050208@s5r6.in-berlin.de>
	<alpine.LFD.1.10.0804261153390.2813@woody.linux-foundation.org>
	<alpine.LFD.1.10.0804261213320.2813@woody.linux-foundation.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 26 Apr 2008 12:18:34 -0700 (PDT) Linus Torvalds <torvalds@linux-foundation.org> wrote:

> So it's an important part of the process to try to do a good job, and not 
> publicizing crap - but it's *equally* important to realize that crap 
> happens, and that it's easily *more* distracting to try to clean it up 
> after-the-fact than it is to just admit that it happened.
> 

Often it takes quite a long time for problems to become apparent.  Across a
month or two we end up with things like:

mm-have-zonelist-contains-structs-with-both-a-zone-pointer-and-zone_idx.patch
mm-have-zonelist-contains-structs-with-both-a-zone-pointer-and-zone_idx-fix-memcg-ooms.patch
mm-have-zonelist-contains-structs-with-both-a-zone-pointer-and-zone_idx-just-return-do_try_to_free_pages.patch
mm-have-zonelist-contains-structs-with-both-a-zone-pointer-and-zone_idx-just-return-do_try_to_free_pages-do_try_to_free_pages-gfp_mask-redundant.patch

and

mm-filter-based-on-a-nodemask-as-well-as-a-gfp_mask.patch
mm-filter-based-on-a-nodemask-as-well-as-a-gfp_mask-doc-fixes.patch
mm-filter-based-on-a-nodemask-as-well-as-a-gfp_mask-make-dequeue_huge_page_vma-obey-mpol_bind-nodemask.patch
mm-filter-based-on-a-nodemask-as-well-as-a-gfp_mask-make-dequeue_huge_page_vma-obey-mpol_bind-nodemask-rework.patch

that's two patches, each with three followon fixes.  Very common.

Fact is, this is the way in which developers want to work.  That is their
workflow, and their tools should follow their workflow.  If a tool's
behaviour prevents them from implementing their desired workflow, it isn't
the workflow which should be changed ;)

