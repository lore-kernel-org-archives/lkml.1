Return-Path: <linux-kernel-owner+w=401wt.eu-S1422916AbXCOQGv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422916AbXCOQGv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 12:06:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422926AbXCOQGv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 12:06:51 -0400
Received: from one.firstfloor.org ([213.235.205.2]:46610 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422916AbXCOQGu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 12:06:50 -0400
Date: Thu, 15 Mar 2007 17:06:48 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Martin Bligh <mbligh@mbligh.org>, Ingo Molnar <mingo@elte.hu>,
       Andi Kleen <andi@firstfloor.org>, Steven Rostedt <rostedt@goodmis.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Chris Wright <chrisw@sous-sol.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Glauber de Oliveira Costa <glommer@gmail.com>
Subject: Re: [PATCH 00/18] Make common x86 arch area for i386 and x86_64 - Take 2
Message-ID: <20070315160648.GA11812@one.firstfloor.org>
References: <20070314050819.536207642@goodmis.org> <p73slc8863r.fsf@bingen.suse.de> <20070314125330.GA13168@elte.hu> <Pine.LNX.4.64.0703140850250.9690@woody.linux-foundation.org> <45F96B57.10206@mbligh.org> <Pine.LNX.4.64.0703150858040.3816@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0703150858040.3816@woody.linux-foundation.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> That's *exactly* what the patches do (except it's called "arch/x86", which 
> is clearly the best option - please don't use "ia" _anywhere_ except for 
> "ia64", since that's the only architecture that is really "intel 
> architecture").

And i860 @)

> > On the downside, it's more ../../.. type stuff. On the upside,
> > they're more cleanly separated and it's apparent what's going on.
> > Seems nicer to me than drivers/ and kernel/ for stuff that's
> > really arch specific, but shared between two arches.
> 
> Absolutely. I'm agreeing violently. I just suspect not a lot of people 
> really looked at the patches..

Well I just see a lot of pain from these patches but I doubt 
they will avoid any bugs. If people don't compile test both
archs they will always likely break on another. There are lots
of subtle dependencies that are not expressed in the pathname
even after this intrusive operation (e.g. in the includes).

That's just how it is.

If the architecture merging was ever done it would be likely
by extending arch/x86_64 to support (modern) 32bit. But this
change doesn't bring us any step closer to that goal.

I think it's just aesthetics -- i'm all for aesthetics but only 
if it gives better software and doesn't impact other people who
want to get something real done; neither of this is the case here.

-Andi

