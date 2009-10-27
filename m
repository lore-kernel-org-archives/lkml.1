Return-Path: <linux-kernel-owner+w=401wt.eu-S1756752AbZJ0Tny@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756752AbZJ0Tny (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 15:43:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753566AbZJ0Tny
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 15:43:54 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51695 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753479AbZJ0Tnx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 15:43:53 -0400
Date: Tue, 27 Oct 2009 12:42:45 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Steven Rostedt <rostedt@goodmis.org>
cc: Stefan Richter <stefanr@s5r6.in-berlin.de>, Theodore Tso <tytso@mit.edu>,
       Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Nicolas Pitre <nico@fluxnic.net>, "Luck, Tony" <tony.luck@intel.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       "Luis R. Rodriguez" <mcgrof@gmail.com>, Jeff Garzik <jeff@garzik.org>,
       Robert Richter <robert.richter@amd.com>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Jean Delvare <khali@linux-fr.org>, Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [RFC] to rebase or not to rebase on linux-next
In-Reply-To: <1256671624.26028.419.camel@gandalf.stny.rr.com>
Message-ID: <alpine.LFD.2.01.0910271232200.31845@localhost.localdomain>
References: <20091022122042.e535d43c.sfr@canb.auug.org.au>  <20091023112732.GB5886@elte.hu> <4AE19A74.1090709@garzik.org>  <20091023123555.GA25366@elte.hu>  <57C9024A16AD2D4C97DC78E552063EA3E33D0174@orsmsx505.amr.corp.intel.com>  <20091023134115.GD27097@elte.hu>
  <alpine.LFD.2.00.0910231424440.21460@xanadu.home>  <20091023191631.GA1879@elte.hu>  <1256326512.26028.34.camel@gandalf.stny.rr.com>  <20091023205400.GA8356@elte.hu> <20091024080326.GA7461@mit.edu>  <4AE2F0F6.30909@s5r6.in-berlin.de> 
 <alpine.LFD.2.01.0910271200060.31845@localhost.localdomain> <1256671624.26028.419.camel@gandalf.stny.rr.com>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 27 Oct 2009, Steven Rostedt wrote:
>
> On Tue, 2009-10-27 at 12:06 -0700, Linus Torvalds wrote:
> >  Don't lie about 
> > getting an ack that you didn't get before you made that patch public.
> 
> But how do you get your ack without making it public?

There's a difference between exposing your git tree to the public, and 
showing your patches to others.

A public git tree is _not_ the place to ask for comments for patches. If 
you haven't gotten Ack's, you have two choices:

 - that commit should not show up in a tree that is marked for -next, 
   because it's still waiting for feedback and people to test it. It may 
   be in a _private_ git tree of course, but it's not "ready" yet.

 - you are going to commit it regardless of acks or not, and you don't 
   care, and you shouldn't lie about it later.

Those are the two obvious choices. Adding ack's later, after it has 
already been exported and tested in -next is kind of pointless, isn't it? 
It's basically lying about how the patch came to be.

If you want Ack's from people, then send that patch around by email.

NOTE! If you know the people you want acks from are git users, then the 
email can certainly be something like "look at so-and-so branch of my git 
tree <here>". You can certainly use private git branches as a way to talk 
to other developers about code you're not fully happy with yet, with the 
clear understanding that you want acks and comments on it.

Put another way: there's a big conceptual difference between "public git 
tree" and "private git branch that may well be available to others and 
is meant for development". In git itself, Junio has the 'pu' branch that 
is clearly marked as being rebased etc.

				Linus
