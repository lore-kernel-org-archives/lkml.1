Return-Path: <linux-kernel-owner+w=401wt.eu-S932653AbXF2May@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932653AbXF2May (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2007 08:30:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763202AbXF2MaG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jun 2007 08:30:06 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:1579 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759854AbXF2MaD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2007 08:30:03 -0400
Date: Thu, 28 Jun 2007 18:31:22 +0000
From: Pavel Machek <pavel@ucw.cz>
To: David Wagner <daw-usenet@taverner.cs.berkeley.edu>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [AppArmor 39/45] AppArmor: Profile loading and manipulation, pathname matching
Message-ID: <20070628183122.GH5339@ucw.cz>
References: <46732124.80509@novell.com> <Line.LNX.4.64.0706212044590.2100@localhost.localdomain> <20070622121742.GC6222@think.oraclecorp.com> <Line.LNX.4.64.0706220858170.5751@localhost.localdomain> <f5molu$63t$1@taverner.cs.berkeley.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f5molu$63t$1@taverner.cs.berkeley.edu>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> >What you do with AppArmor, instead of addressing the problem, is just 
> >redefine the environment along the lines of "set your house into a rock 
> >wall so there is only one path to it".
> 
> Harrumph.  Those analogies sound good but aren't a very good guide.
> 
> Let's take a concrete example.  Consider the following fragment of a
> policy for Mozilla:
>     allow ~/.mozilla
>     deny ~
> Ignore the syntax; the goal is to allow Mozilla to access files under
> ~/.mozilla but nothing else under my home directory.  This is a perfectly
> reasonable policy fragment to want to enforce.  And enforcing it in
> the obvious way using pathname-based access control is not a ridiculous
> thing to do.

Unfortunately, mozilla needs temporary files IIRC. And when you add
allow /tmp

to your config files, you get system where your fellow users can 
ln HOME/.ssh/identity /tmp/to-steal (or
ln HOME/.profile /tmp/put-evil-code-here)
and AA protection is not effective any more.

Would _you_ do this mistake?

Would our users do this mistake?

Is it right to provide them with auto-learning tools to make this
mistake really easy?

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
