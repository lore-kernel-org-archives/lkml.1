Return-Path: <linux-kernel-owner+w=401wt.eu-S1756144AbYCZWLc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756144AbYCZWLc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 18:11:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752954AbYCZWLY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 18:11:24 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:41429 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752629AbYCZWLX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 18:11:23 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Ray Lee" <ray-lk@madrabbit.org>
Subject: Re: 2.6.25-rc6-git6: Reported regressions from 2.6.24
Date: Wed, 26 Mar 2008 23:11:13 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: LKML <linux-kernel@vger.kernel.org>, "Adrian Bunk" <bunk@kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Natalie Protasevich" <protasnb@gmail.com>
References: <200803220259.48534.rjw@sisk.pl> <2c0942db0803260930y741dfe81r114bd18b35e0bbe5@mail.gmail.com>
In-Reply-To: <2c0942db0803260930y741dfe81r114bd18b35e0bbe5@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803262311.15024.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, 26 of March 2008, Ray Lee wrote:
> 2008/3/21 Rafael J. Wysocki <rjw@sisk.pl>:
> > This message contains a list of some regressions from 2.6.24 reported since
> >  2.6.25-rc1 was released, for which there are no fixes in the mainline I know
> >  of.  If any of them have been fixed already, please let me know.
> [...]
> >  Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=10041
> >  Subject         : 2.6.25-rc1/2 regression: first-time login into gnome fails
> >  Submitter       : Romano Giannetti <romanol@upcomillas.es>
> >  Date            : 2008-02-18 11:56 (33 days old)
> >  References      : http://lkml.org/lkml/2008/2/18/145
> >  Handled-By      : Ray Lee <ray-lk@madrabbit.org>
> 
> This appears to be a race in user space that people have been hitting
> for some time, but has gotten more likely with the latest kernel. It
> matches the behavior of a gnome dbus bug [
> http://bugzilla.gnome.org/show_bug.cgi?id=395488 ]. The way to avoid
> that bug is to install the dbus-x11 package which forces dbus to start
> up earlier, avoiding the race.
> 
> Though the original reporter hasn't replied, Christoph Hellwig hit the
> same issue and was able to confirm that installing the dbus-x11
> package avoids the issue, papering over bug, wherever it may lie.
> Regardless, there are reports of this issue that go back before
> 2.6.25, so I don't think this is a regression, just a timing issue
> that's a lot easier to hit with the latest kernel.
> 
> This is one of those things that'd be nice to have in a Known Issues
> document in the kernel release. "Debian and derivative distributions
> may need to install dbus-x11 package to avoid a known userspace issue
> in the dbus package. [gnome bug 395488]"

Okay, I closed the bug (resolution WILL_NOT_FIX).

Thanks,
Rafael
