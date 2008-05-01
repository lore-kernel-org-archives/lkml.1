Return-Path: <linux-kernel-owner+w=401wt.eu-S1760726AbYEAUJb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760726AbYEAUJb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 16:09:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760684AbYEAUJI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 16:09:08 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:52248 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760037AbYEAUJG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 16:09:06 -0400
Date: Thu, 1 May 2008 13:07:54 -0700
From: Joel Becker <Joel.Becker@oracle.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>, Willy Tarreau <w@1wt.eu>,
       David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       Jiri Slaby <jirislaby@gmail.com>
Subject: Re: Slow DOWN, please!!!
Message-ID: <20080501200754.GD19731@mail.oracle.com>
Mail-Followup-To: Al Viro <viro@ZenIV.linux.org.uk>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	"Rafael J. Wysocki" <rjw@sisk.pl>,
	Andrew Morton <akpm@linux-foundation.org>, Willy Tarreau <w@1wt.eu>,
	David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
	Jiri Slaby <jirislaby@gmail.com>
References: <20080429.190352.137408408.davem@davemloft.net> <200805011259.47343.rjw@sisk.pl> <alpine.LFD.1.10.0805010816340.5994@woody.linux-foundation.org> <200805011909.40203.rjw@sisk.pl> <alpine.LFD.1.10.0805011022370.5994@woody.linux-foundation.org> <20080501181157.GB5882@ZenIV.linux.org.uk> <alpine.LFD.1.10.0805011116060.5994@woody.linux-foundation.org> <20080501193714.GC5882@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080501193714.GC5882@ZenIV.linux.org.uk>
X-Burt-Line: Trees are cool.
X-Red-Smith: Ninety feet between bases is perhaps as close as man has ever
	come to perfection.
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 01, 2008 at 08:37:14PM +0100, Al Viro wrote:
> 	* one needs to understand enough of the area or know where/how
> to get the information needed for that.  I've got some experience with
> the latter and I suspect that most of the folks who do active reviews
> have their own set of tricks for getting into the unfamiliar area fast.
> Moreover, having such set of tricks is probably _the_ thing that makes
> us able to do that kind of work.
> 	Sharing such (i.e. "here's how one wades through unfamiliar
> area and gets a sense of what's going on there; here's what one looks
> out for; here's how to deal with data structures; here are the signs
> of problematic lifetime logics; here's how one formulates hypothesis
> about refcounting rules; here's how one verifies such and looks for
> possible bugs in that area; etc.) is a Good Idea(tm).

<snip>

> 	FWIW, I'm trying to do that - right now I'm flipping between
> wading through Cthulhu-damned fs/locks.c and its friends and getting
> the notes I've got from the last month work into edible form (which
> includes translation into something that resembles normal English,
> among other things - more than half of that is in... well, let's call
> it idiom-rich Russian).

	I think you've just nailed one of the tricks right there.  A
long time ago, I just sat down and wrote up a "how the locking works in
the vfs" document for myself and others.  Wrote up the structures, what
each member is for, where the structure appears and disappears, and all
the call chains for all of the locks.  When I was done, I had a pretty
good idea of how everything interacted.
	I think this is a great trick for ramping up on a section of the
code - documentation is good, but you understand self-written
documentation better.

Joel

-- 

Life's Little Instruction Book #452

	"Never compromise your integrity."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
