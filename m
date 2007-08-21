Return-Path: <linux-kernel-owner+w=401wt.eu-S932188AbXHUS0S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932188AbXHUS0S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 14:26:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761392AbXHUS0I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 14:26:08 -0400
Received: from ns2.suse.de ([195.135.220.15]:59798 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761347AbXHUS0G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 14:26:06 -0400
Date: Tue, 21 Aug 2007 21:19:59 +0200
From: Andi Kleen <ak@suse.de>
To: Adrian Bunk <bunk@kernel.org>
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jarek Poplawski <jarkao2@o2.pl>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
Subject: Re: RFC: drop support for gcc < 4.0
Message-ID: <20070821191959.GC2642@bingen.suse.de>
References: <20070821132038.GA22254@ff.dom.local> <20070821093103.3c097d4a.randy.dunlap@oracle.com> <20070821173550.GC30705@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070821173550.GC30705@stusta.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 21, 2007 at 07:35:50PM +0200, Adrian Bunk wrote:
> Obviously a gcc <= 3.4 [1], and therefore no unit-at-a-time.

Actually there are widely used 3.3 variants that support unit-at-a-time
(e.g. 3.3-hammer which was shipped by several distributions for some time)

There are still a lot of systems around which use gcc 3.3 (less so with
3.4). Unless there's a major bug that is hard to work around I would
prefer to keep it supported.

Bogus warnings should be relatively harmless.

> And it's becoming a real maintainance problem that not only this problem 
> but also other problems like some section mismatches [2] are only 
> present without unit-at-a-time.

The unit-at-a-time output order is not defined, so even if it works
with the current compiler a compiler change might still trigger
that problem. So it would be better to fix those anyways.

-Andi
