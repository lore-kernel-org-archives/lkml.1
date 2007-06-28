Return-Path: <linux-kernel-owner+w=401wt.eu-S932432AbXF2Mai@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932432AbXF2Mai (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2007 08:30:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762546AbXF2MaF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jun 2007 08:30:05 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:1577 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758332AbXF2MaC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2007 08:30:02 -0400
Date: Thu, 28 Jun 2007 18:13:11 +0000
From: Pavel Machek <pavel@ucw.cz>
To: David Wagner <daw-usenet@taverner.cs.berkeley.edu>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [AppArmor 39/45] AppArmor: Profile loading and manipulation, pathname matching
Message-ID: <20070628181311.GF5339@ucw.cz>
References: <46732124.80509@novell.com> <Line.LNX.4.64.0706212044590.2100@localhost.localdomain> <20070622121742.GC6222@think.oraclecorp.com> <Line.LNX.4.64.0706220858170.5751@localhost.localdomain> <f5mmuu$4d4$1@taverner.cs.berkeley.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f5mmuu$4d4$1@taverner.cs.berkeley.edu>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> I've heard four arguments against merging AA.
> 
> Argument 1. SELinux does it better than AA.  (Or: SELinux dominates AA.
> Or: SELinux can do everything that AA can.)
> 
> Argument 2. Object labeling (or: information flow control) is more secure
> than pathname-based access control.
> 
> Argument 3. AA isn't complete until it mediates network and IPC.
> 
> Argument 4. AA doesn't have buy-in from VFS maintainers.

...

> 1. I think this is a bogus argument for rejecting AA.  As I remember it,
...
> 3. This one I agree with.  If you want to sandbox network daemons that

> 4. Way over my head.  I'm not qualified to comment on this aspect.
> I suspect this is the argument that ought to be getting the most serious
> and thorough discussion, not the irrelevant SELinux-vs-AA faceoff.

I believe situation is 'vfs maintainers seriously dislike AA', but if
they were given good enough reasons -- like 'selinux is broken crap
that does not really work', we probably could twist their arms or
something.

So question is not 'is AA better then SELinux' but 'is AA so much
better than SELinux that we want to overrule vfs maintainers'.

							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
