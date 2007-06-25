Return-Path: <linux-kernel-owner+w=401wt.eu-S1757460AbXFYPUj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757460AbXFYPUj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 11:20:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755739AbXFYPUa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 11:20:30 -0400
Received: from waste.org ([66.93.16.53]:43684 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755776AbXFYPUa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 11:20:30 -0400
Date: Mon, 25 Jun 2007 10:20:04 -0500
From: Matt Mackall <mpm@selenic.com>
To: Alexander Gabert <pappy@gentoo.org>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       Arjan van de Ven <arjan@infradead.org>, libc-alpha@sourceware.org,
       hardened@gentoo.org
Subject: Re: [PATCH] get_random_long() and AT_ENTROPY for auxv, kernel 2.6.21.5
Message-ID: <20070625152004.GS11115@waste.org>
References: <4675C678.3080807@gentoo.org> <1182128803.22999.9.camel@laptopd505.fenrus.org> <20070620203022.GO11166@waste.org> <467EADA0.9020101@gentoo.org> <20070625034508.GE11115@waste.org> <467FD8E9.1000200@gentoo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <467FD8E9.1000200@gentoo.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 25, 2007 at 05:02:01PM +0200, Alexander Gabert wrote:
> >Am I right in thinking you have three unrelated patches here?
> >  
> I don't think so but you may be right nonetheless if my opinion.

The point is: the way we do development here is to break things down
into a series of simple, obvious pieces and send them individually.
Each patch should build and run when applied on top of the earlier
patches. Then each part can be reviewed, tested, and applied on its
own. It also makes figuring out what happened in the future and
tracking down bugs much easier.

So send three patches in this order:

- fix get_random_int
- rename it
- add auxv bits

Also, you might want to drop Linus from the cc: list unless he's
chimed in on this topic already. The likely path here is for the first
two patches to go through me and the last to go through Arjan, then on
to Andrew Morton for his -mm tree, and then to Linus after a bit.

-- 
Mathematics is the supreme nostalgia of our time.
