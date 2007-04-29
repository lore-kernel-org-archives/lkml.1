Return-Path: <linux-kernel-owner+w=401wt.eu-S1030342AbXD2UOQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030342AbXD2UOQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 16:14:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031357AbXD2UOQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 16:14:16 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:38599 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030342AbXD2UOO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 16:14:14 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andi Kleen <andi@firstfloor.org>
Subject: Re: Linux 2.6.21
Date: Sun, 29 Apr 2007 22:18:10 +0200
User-Agent: KMail/1.9.5
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Adrian Bunk <bunk@stusta.de>, Diego Calleja <diegocg@gmail.com>,
       Chuck Ebbert <cebbert@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <20070426040806.GJ3468@stusta.de> <200704292050.56575.rjw@sisk.pl> <20070429191432.GA31445@one.firstfloor.org>
In-Reply-To: <20070429191432.GA31445@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Content-Disposition: inline
Message-Id: <200704292218.11242.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 29 April 2007 21:14, Andi Kleen wrote:
> On Sun, Apr 29, 2007 at 08:50:55PM +0200, Rafael J. Wysocki wrote:
> > On Sunday, 29 April 2007 19:37, Andi Kleen wrote:
> > > > My personal experience with bugzilla is that it's very unfriendly to
> > > > reporters.  IMHO it's suitable for tracking unresolved problems along with
> > > > debug patches, system information etc., but not for _reporting_ new ones.
> > > 
> > > What did you find unfriendly? 
> > 
> > - You are required to select a category and 'component' for your report, which
> > often is difficult (especially if you're not a kernel expert)
> 
> Usually there is other and then someone else figures it out.
> 
> > - You need to have a bugzilla account (or to create one, if you don't)
> > - If you want to add an address to the CC list, it must be known to bugzilla
> > and there's no (obvious) way to check which addresses are known (bugzilla
> > rejects the report if there's a 'wrong' email address in the list)  [IMO this is
> > really really broken.]
> 
> The Novell bugzilla actually has that fixed. You have a search email button
> to look up addresses.  Perhaps that feature will be ported someday into
> the kernel.org one (I would like to have it too) 
> 
> > - You are asked to provide many details that need not be relevant and casual
> > reporters don't know that they can skip this part
> > - Attaching files is tedious and referring to attachments unintuitive
> 
> Anyways that are mostly all detail (except the registration requirement) that
> could be probably all easily fixed.
> 
> > And I think they are two _totally_ conceptually different things.  You report
> > a bug to let somebody know that there's a problem and this doesn't necessarily
> 
> The problem is we need a way to route those reports to the right people.
> Routing it to a single person or broadcasting it just doesn't scale.
> And the best way I know of is to use some database that keeps track of the state.
> 
> That is what bugzilla is essentially.
> 
> > For this reason there should be a simple means of filing initial bug reports
> > with someone to look at them and forward them to appropriate people who will
> > decide if the problem needs to be tracked.  If they do, it's time to use
> > bugzilla.  Not earlier.
> 
> The only sane way to do that would be to save them somewhere and keep
> a list and then let a group of people process them.

But emailed reports _are_ saved anyway and we _know_ how to get a copy.
>From lkml.org, for example.  Why don't we use that?  The only missing piece
is the 'keep a list' thing, but that's not a rocket science, IMHO.

[For example, you can create a bugzilla entry with a link to the lkml.org copy
of the relevant message, so why to require the reporter to file the report with
the bugzilla himself?]

_Moreover_, some LKML archives, for example at http://marc.info/?l=linux-kernel,
keep track of each thread separately, so you can browse any of them at any
time.  In particular, you can see the _history_ of each bug report sent to LKML
if you have a link to any message in its thread.

Really, if we ask reporters to put '[BUG]' in the subjects of their messages,
you'll even be able to use the lkml.org archives plus wget and a couple of
shell scripts to cherry pick the links to all bug reports sent to the list
within a given time interval.

All of this functionality is out there already.

> Hmm, wait... sounds like bugzilla, doesn't it?
> 
> > You are right, email is not suitable for tracking bugs.

Well, now, I think that even this statement is not exactly right. :-)

> > Still, it works quite well as a means of sending initial reports.
>
> I disagree. It works small scale but does not really scale well.

IMO that depends on how you handle it.

Greetings,
Rafael
