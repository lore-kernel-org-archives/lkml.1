Return-Path: <linux-kernel-owner+w=401wt.eu-S1759447AbYDMP4F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759447AbYDMP4F (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2008 11:56:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754529AbYDMPzz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Apr 2008 11:55:55 -0400
Received: from [210.212.49.7] ([210.212.49.7]:37353 "HELO nspam-mx.mnnit.ac.in"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with SMTP
	id S1754329AbYDMPzy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2008 11:55:54 -0400
X-Nspam-Scanner-Mail-From: cs044024@mnnit.ac.in via nspam-mx.mnnit.ac.in
X-Nspam-Scanner: 1.25st (Clear:RC:1(210.212.49.9):SA:0(-3.4/5.0):. Processed in 2.506059 secs Process 27457)
Message-ID: <43702.210.212.49.15.1208101980.squirrel@mail.mnnit.ac.in>
In-Reply-To: <1208002923.7427.5.camel@twins>
References: <42423.210.212.49.15.1207972006.squirrel@mail.mnnit.ac.in>
    <1208002923.7427.5.camel@twins>
Date: Sun, 13 Apr 2008 21:23:00 +0530 (IST)
Subject: Re: modifying CFS failure
From: cs044024@mnnit.ac.in
To: linux-kernel@vger.kernel.org
Cc: "Willy Tarreau"@mnnit.ac.in, " <w@1wt.eu>, "@mnnit.ac.in,
       Peter@mnnit.ac.in, Zijlstra@mnnit.ac.in,
       " <peterz@infradead.org>"@mnnit.ac.in
User-Agent: SquirrelMail/1.4.6-1
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Please provide it as a series of patches against sched-devel/latest.
>
> Just plain AVL code and a huge modified CFS backport make it impossible
> to tell what changed and why.
>

We haven't modified anything in CFS except replacing all the RB-Tree
function calls by AVL tree function calls, so that only the implementation
of the tree DS changes, and everything else remains same. We have retained
the interface of tree DS and core scheduler as it is, so we assumed that
everything must work fine.

> Which brings us to the question: _why_. That is, why are you trying to
> replace the rb-tree with an avl tree? Just because the worst case depth
> of the avl is slightly better than for an rb-tree, which can be offset
> by the slightl more expesive balance operations.
>
Actually we wanted to replace RB with time ordered radix tree. But that
seemed a tougher task, so we started with AVL trees first.

> I'm glad people are working on CFS - its an interesting piece of the
> kernel after all...
>
Thanks. This is really encouraging.


