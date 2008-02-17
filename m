Return-Path: <linux-kernel-owner+w=401wt.eu-S1756781AbYBQWz3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756781AbYBQWz3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 17:55:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754109AbYBQWzV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 17:55:21 -0500
Received: from twin.jikos.cz ([213.151.79.26]:49738 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754091AbYBQWzU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 17:55:20 -0500
Date: Sun, 17 Feb 2008 23:54:26 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jikos@twin.jikos.cz
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Adrian Bunk <bunk@kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: 2.6.25-rc2: Reported regressions from 2.6.24
In-Reply-To: <200802172304.00322.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.64.0802172342431.7699@twin.jikos.cz>
References: <200802172304.00322.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1747641777-728730522-1203288866=:7699"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1747641777-728730522-1203288866=:7699
Content-Type: TEXT/PLAIN; charset=iso-8859-2
Content-Transfer-Encoding: QUOTED-PRINTABLE

On Sun, 17 Feb 2008, Rafael J. Wysocki wrote:

> Bug-Entry=09: http://bugzilla.kernel.org/show_bug.cgi?id=3D9842
> Subject=09=09: key 49 and 94 send both 49 and 94 events on macbooks REGRE=
SSION
> Submitter=09: Emil Karlson <jkarlson@cc.hut.fi>
> Date=09=09: 2008-01-29 08:15

I have already fixed this one, and fix has been already picked by Linus=20
from my tree, so you can drop this one. (even the bugzilla is closed=20
properly).

> Bug-Entry=09: http://bugzilla.kernel.org/show_bug.cgi?id=3D9984
> Subject=09=09: problem with starting 2.5.25-rc1 and latest git

The kernel version seems to be a little bit bogus here :)

> Bug-Entry=09: http://bugzilla.kernel.org/show_bug.cgi?id=3D10002
> Subject=09=09: wpa_supplicant doens't work and froze the computer
> Submitter=09: Fran=E7ois Valenduc <francois.valenduc@tvcablenet.be>
> Date=09=09: 2008-02-16 08:25
[ ... ]
> Bug-Entry=09: http://bugzilla.kernel.org/show_bug.cgi?id=3D10014
> Subject=09=09: commit 45b503548210fe6f23e92b856421c2a3f05fd034 is broken
> Submitter=09: Rafael J. Wysocki <rjw@sisk.pl>
> Date=09=09: 2008-02-16 03:08
> References=09: http://lkml.org/lkml/2008/2/15/542

These two are the same bug. I think we really need 45b503548 reverted in=20
mainline.

> Bug-Entry=09: http://bugzilla.kernel.org/show_bug.cgi?id=3D10022
> Subject=09=09: [2.6.25-rc1] jerky mouse cursor and randoooom key repeats
> Submitter=09: Frans Pop <elendil@planet.nl>
> Date=09=09: 2008-02-13 09:41
> References=09: http://lkml.org/lkml/2008/2/13/82
> Handled-By=09: Jiri Kosina <jkosina@suse.cz>

Looks like this is issue with CONFIG_GROUP_SCHED. Waiting for Peter's=20
feedback.

BTW it would be nice to receive CC in the bugzilla, when I have Handled-by=
=20
on that bug :) (but hey, I know that it is difficult to track all the=20
persons addressess, when they are not using them consistently).

> Please let me know if there are any Bugzilla entries that should be added=
 to
> the list in there.

Thanks a lot Rafael for this regression tracking.

BTW I think it might still be useful to CC everyone involved on these=20
reports, even though the bugzillas probably have the correct addressess=20
already.

Thanks,

--=20
Jiri Kosina
SUSE Labs

---1747641777-728730522-1203288866=:7699--
