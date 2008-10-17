Return-Path: <linux-kernel-owner+w=401wt.eu-S1755716AbYJQQSs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755716AbYJQQSs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 12:18:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753883AbYJQQSk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 12:18:40 -0400
Received: from xenotime.net ([66.160.160.81]:48102 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753806AbYJQQSj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 12:18:39 -0400
Date: Fri, 17 Oct 2008 09:18:36 -0700 (PDT)
From: "Randy.Dunlap" <rdunlap@xenotime.net>
X-X-Sender: rddunlap@shark.he.net
To: Vegard Nossum <vegard.nossum@gmail.com>
cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       Eric Van Hensbergen <ericvh@gmail.com>,
       Ron Minnich <rminnich@sandia.gov>, Latchesar Ionkov <lucho@ionkov.net>
Subject: Re: linux-next: Tree for October 17
In-Reply-To: <19f34abd0810170230s755aa0e4vea38c26e093e173c@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0810170917200.685@shark.he.net>
References: <20081017194045.202e6271.sfr@canb.auug.org.au>
 <19f34abd0810170230s755aa0e4vea38c26e093e173c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 17 Oct 2008, Vegard Nossum wrote:

> On Fri, Oct 17, 2008 at 10:40 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> > Hi all,
> >
> > Today's tree will not build for powerpc allyesconfig (libc aborts the
> > link due to a free() problem), sparc(32) defconfig and probably some
> > other configurations.
> 
> Hi, I ran into this with slightly modified fedora config:
> 
>   CC      net/9p/protocol.o
> net/9p/protocol.c: In function 'p9pdu_finalize':
> net/9p/protocol.c:545: error: 'p9_debug_level' undeclared (first use
> in this function)
> net/9p/protocol.c:545: error: (Each undeclared identifier is reported only once
> net/9p/protocol.c:545: error: for each function it appears in.)
> net/9p/protocol.c:545: error: 'P9_DEBUG_PKT' undeclared (first use in
> this function)
> make[2]: *** [net/9p/protocol.o] Error 1
> make[1]: *** [net/9p] Error 2
> make: *** [net] Error 2
> 
> ...and couldn't find it in the automatic build test results either. 9P
> maintainers Cced.

This build failure happened with 20081016 also.

There are plenty of randconfig build failures and not enough time
in the day to fix all of them before Stephen produces the next next.

-- 
~Randy
