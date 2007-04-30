Return-Path: <linux-kernel-owner+w=401wt.eu-S1754145AbXD3XEV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754145AbXD3XEV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 19:04:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754106AbXD3XEV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 19:04:21 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:43464 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753999AbXD3XEU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 19:04:20 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Linux 2.6.21
Date: Tue, 1 May 2007 01:08:33 +0200
User-Agent: KMail/1.9.5
Cc: Alexey Dobriyan <adobriyan@gmail.com>, Andi Kleen <andi@firstfloor.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Adrian Bunk <bunk@stusta.de>, Diego Calleja <diegocg@gmail.com>,
       Chuck Ebbert <cebbert@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <20070426040806.GJ3468@stusta.de> <200704300009.07257.rjw@sisk.pl> <20070429233019.e782f949.akpm@linux-foundation.org>
In-Reply-To: <20070429233019.e782f949.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705010108.35248.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 30 April 2007 08:30, Andrew Morton wrote:
> On Mon, 30 Apr 2007 00:09:06 +0200 "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> 
> > On Sunday, 29 April 2007 22:52, Alexey Dobriyan wrote:
> > > On Sun, Apr 29, 2007 at 10:18:10PM +0200, Rafael J. Wysocki wrote:
> > > > [For example, you can create a bugzilla entry with a link to the lkml.org copy
> > > > of the relevant message, so why to require the reporter to file the report with
> > > > the bugzilla himself?]
> > > 
> > > Last time I did this, bugzilla at osdl.org won't let me add original
> > > reporter to goddamn CC list. It would be el neat, because not everyone
> > > followed instructions and forwarding emails between reporter and
> > > bugzilla sucks.
> > 
> > That's related to what I said before.  The requirement that the addresses on
> > the CC list must be 'known' to bugzilla is deadly wrong in every case I can
> > imagine.
> 
> But unknown-to-bugzilla email addresses are accepted when they're sent to
> bugme-daemon@kernel-bugs.osdl.org.  This is why I'll very often switch a
> bug report to email, copying individuals and mailing lists and
> bugme-daemon.  Then bugzilla just sits silently in the background recording
> everything.

If I wanted to do this, what would I have to do?  I mean, assume I have a bug
report that I want to send to someone whom the bugzilla doesn't like.
What's the right procedure in such a case?

> But once a bug has switched to email, it needs to stay there - it would be
> bad if someone were to update the bug via the web UI because none of the
> emailed participants would know of the update.  So i'll often explicitly
> ask "please follow up via emailed reply-to-all".
> 
> It's not great, but there's certainly enough material here for people to get
> in and work on the bug, should they be so inclined.
> 
> My overall approach with this stuff is: short-term bugs are handled via email
> and long-term ones are tracked in buzilla.

I think that's reasonable, I've always done it this way, AFAIR.

> Hence someone (Hi, Mom) needs to track all the emailed-only bug reports and get
> them filed in bugzilla once they go stale.

I can do that with suspend/hibernation-related bug reports, but sometimes
I'm not sure who is the right person to notify in the first place.

