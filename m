Return-Path: <linux-kernel-owner+w=401wt.eu-S1763386AbXGFJxM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763386AbXGFJxM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 05:53:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757928AbXGFJw6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 05:52:58 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:57648 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757261AbXGFJw5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 05:52:57 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [RFC][PATCH -mm] PM: Do not sync filesystems from within the freezer
Date: Fri, 6 Jul 2007 12:00:36 +0200
User-Agent: KMail/1.9.5
Cc: nigel@suspend2.net, benh@kernel.crashing.org, pavel@ucw.cz,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       mjg59@srcf.ucam.org, oliver@neukum.org, paulus@samba.org, mingo@elte.hu
References: <200707041658.59588.rjw@sisk.pl> <200707061914.02972.nigel@nigel.suspend2.net> <E1I6kA9-0003Zt-00@dorka.pomaz.szeredi.hu>
In-Reply-To: <E1I6kA9-0003Zt-00@dorka.pomaz.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707061200.37035.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, 6 July 2007 11:31, Miklos Szeredi wrote:
> > > > On Fri, 2007-07-06 at 09:13 +0200, Miklos Szeredi wrote:
> > > > > 
> > > > > Another myth, that has been debunked already.  The problem is: how do
> > > > > you define fuse processes?  There's no theoretical or even practial
> > > > > way to do that.
> > > > 
> > > > It could if they told the kernel via some black magic ...
> > > > 
> > > > But that still suck. The freezer sucks :-)
> > > 
> > > Yeah, and it wouldn't work in practice, since the auxilary tasks might
> > > be part of a library which is not even aware of being used by a "fuse
> > > task".
> > 
> > This is why I think the whole concept of filesystems in userspace is broken. 
> > Trying to shift things that need special privilege and special handling to 
> > userspace is just asking for trouble.
> 
> I'm not claiming fuse doesn't introduce problems.  I've been tackling
> those problems for a number of years now.  Suspend/hibernate is just
> the next thing that needs looking at.
> 
> Just blaming either suspend or fuse for these problems is unproductive
> and stupid.

Well, the "stupid" part is a bit offensive, don't you think?

> The problems _are_ solvable if not always simply. 

Agreed.

> > You can say it's the kernel code's fault, but then you have to
> > explain why it's only fuse (yeah ok, and XFS) that have problems.
> 
> I'm not faulting anythig.  My opinion, is that the freezer is not
> needed for suspend, and removing it will not just solve the problems
> with fuse but several others.  It probably needs a lot of work, but
> hey, that's why we are here.
> 
> The patch posted by Rafael, which lets the freezer skip uninterrupible
> tasks is a step in the right direction.

Thanks.

BTW, I think that this is just less radical than the change proposed by Matthew
and it should address the underlying problems.

Greetings,
Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth
