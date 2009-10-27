Return-Path: <linux-kernel-owner+w=401wt.eu-S1756646AbZJ0THn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756646AbZJ0THn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 15:07:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756628AbZJ0THm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 15:07:42 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53561 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755668AbZJ0THm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 15:07:42 -0400
Date: Tue, 27 Oct 2009 12:06:03 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
cc: Theodore Tso <tytso@mit.edu>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>, Nicolas Pitre <nico@fluxnic.net>,
       "Luck, Tony" <tony.luck@intel.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       "Luis R. Rodriguez" <mcgrof@gmail.com>, Jeff Garzik <jeff@garzik.org>,
       Robert Richter <robert.richter@amd.com>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Jean Delvare <khali@linux-fr.org>, Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [RFC] to rebase or not to rebase on linux-next
In-Reply-To: <4AE2F0F6.30909@s5r6.in-berlin.de>
Message-ID: <alpine.LFD.2.01.0910271200060.31845@localhost.localdomain>
References: <20091022122042.e535d43c.sfr@canb.auug.org.au> <20091023112732.GB5886@elte.hu> <4AE19A74.1090709@garzik.org> <20091023123555.GA25366@elte.hu> <57C9024A16AD2D4C97DC78E552063EA3E33D0174@orsmsx505.amr.corp.intel.com> <20091023134115.GD27097@elte.hu>
 <alpine.LFD.2.00.0910231424440.21460@xanadu.home> <20091023191631.GA1879@elte.hu> <1256326512.26028.34.camel@gandalf.stny.rr.com> <20091023205400.GA8356@elte.hu> <20091024080326.GA7461@mit.edu> <4AE2F0F6.30909@s5r6.in-berlin.de>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 24 Oct 2009, Stefan Richter wrote:
> 
> Per linux-next submission rules, all /essential/ credits are already
> present.  But I agree that it is worth rewinding a for-next branch in
> order to add (non-essential) credits later.

I'd actually personally prefer that people do _not_ generally add 
"credits" later.

Quite frankly, if something was committed without having been ack'ed by 
some person, then later - when that person sees it on a commit list, for 
example - it's worthless adding somebodys late ack.

Same largely goes for 'tested-by' lines. 

And 'signed-off-by' are actively _wrong_ to add later. If it didn't come 
with a sign-off in the first place, it shouldn't have been committed.

One reason I say this is that I really think it's wrong to even give 
credit to some late-comer that pipes in after the patch has already made 
it into somebody's tree. If they didn't comment on it while it was passed 
around as a patch on mailing lists, what's the point? By the time it's in 
somebody elses published tree, any "ack" is worthless, and that person 
should simply _not_ get credit for being late to the party.

So I think that there are many good reasons to rebase patches in your own 
tree, but I do _not_ think that "adding late acks" is one such reason. If 
you've published your tree to others, then it's done. Don't lie about 
getting an ack that you didn't get before you made that patch public.

			Linus
