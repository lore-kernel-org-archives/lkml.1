Return-Path: <linux-kernel-owner+w=401wt.eu-S1757405AbYBQXIV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757405AbYBQXIV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 18:08:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754237AbYBQXIL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 18:08:11 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:39897 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754217AbYBQXIK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 18:08:10 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jiri Kosina <jkosina@suse.cz>
Subject: Re: 2.6.25-rc2: Reported regressions from 2.6.24
Date: Mon, 18 Feb 2008 00:06:41 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Adrian Bunk <bunk@kernel.org>, Ingo Molnar <mingo@elte.hu>
References: <200802172304.00322.rjw@sisk.pl> <Pine.LNX.4.64.0802172342431.7699@twin.jikos.cz>
In-Reply-To: <Pine.LNX.4.64.0802172342431.7699@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200802180006.41880.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 17 of February 2008, Jiri Kosina wrote:
> On Sun, 17 Feb 2008, Rafael J. Wysocki wrote:
> 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=9842
> > Subject		: key 49 and 94 send both 49 and 94 events on macbooks REGRESSION
> > Submitter	: Emil Karlson <jkarlson@cc.hut.fi>
> > Date		: 2008-01-29 08:15
> 
> I have already fixed this one, and fix has been already picked by Linus 
> from my tree, so you can drop this one. (even the bugzilla is closed 
> properly).

Hmm, the script should have noticed that.  I'll need to figure out why it didn't.

> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=9984
> > Subject		: problem with starting 2.5.25-rc1 and latest git
> 
> The kernel version seems to be a little bit bogus here :)

Well, this is the original message's subject. :-)

> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10002
> > Subject		: wpa_supplicant doens't work and froze the computer
> > Submitter	: François Valenduc <francois.valenduc@tvcablenet.be>
> > Date		: 2008-02-16 08:25
> [ ... ]
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10014
> > Subject		: commit 45b503548210fe6f23e92b856421c2a3f05fd034 is broken
> > Submitter	: Rafael J. Wysocki <rjw@sisk.pl>
> > Date		: 2008-02-16 03:08
> > References	: http://lkml.org/lkml/2008/2/15/542
> 
> These two are the same bug.

Ah, okay.  I'll mark one of them as a duplicate.

> I think we really need 45b503548 reverted in mainline.

Definitely.

> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10022
> > Subject		: [2.6.25-rc1] jerky mouse cursor and randoooom key repeats
> > Submitter	: Frans Pop <elendil@planet.nl>
> > Date		: 2008-02-13 09:41
> > References	: http://lkml.org/lkml/2008/2/13/82
> > Handled-By	: Jiri Kosina <jkosina@suse.cz>
> 
> Looks like this is issue with CONFIG_GROUP_SCHED. Waiting for Peter's 
> feedback.
> 
> BTW it would be nice to receive CC in the bugzilla, when I have Handled-by 
> on that bug :) (but hey, I know that it is difficult to track all the 
> persons addressess, when they are not using them consistently).

In fact, some people don't like to get messages from the Bugzilla and asked me
directly not to put them in the CC lists in there, so I'm a bit cautious ...

> > Please let me know if there are any Bugzilla entries that should be added to
> > the list in there.
> 
> Thanks a lot Rafael for this regression tracking.
> 
> BTW I think it might still be useful to CC everyone involved on these 
> reports, even though the bugzillas probably have the correct addressess 
> already.

Hm, I'd rather avoid sending messages with 100+ addresses in the CC list. :-)

Perhaps I can write a script to send followup messages to everyone involved
for each of the regressions listed, but that will take time (or perhaps someone
could do that for me ;-)).

Thanks,
Rafael
