Return-Path: <linux-kernel-owner+w=401wt.eu-S1752810Ab0AYUtl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752810Ab0AYUtl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jan 2010 15:49:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752432Ab0AYUtj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jan 2010 15:49:39 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:51894 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752300Ab0AYUti (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jan 2010 15:49:38 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [Bug #15015] blank screen at random times in laptop when sitting  idle
Date: Mon, 25 Jan 2010 21:50:29 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.33-rc4-rjw; KDE/4.3.3; x86_64; ; )
Cc: Manish Katiyar <mkatiyar@gmail.com>, Pekka Enberg <penberg@cs.helsinki.fi>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Jithin Emmanuel <jithin1987@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
References: <pYFNu11z2aM.A.pJH.CZMXLB@chimera> <ea11fea31001250644i78a9e4d9q725eb04f6a7da164@mail.gmail.com> <20100125103917.53f75e9a@jbarnes-piketon>
In-Reply-To: <20100125103917.53f75e9a@jbarnes-piketon>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201001252150.29362.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 25 January 2010, Jesse Barnes wrote:
> On Mon, 25 Jan 2010 20:14:28 +0530
> Manish Katiyar <mkatiyar@gmail.com> wrote:
> 
> > On Mon, Jan 25, 2010 at 7:40 PM, Pekka Enberg
> > <penberg@cs.helsinki.fi> wrote:
> > > On Mon, Jan 25, 2010 at 12:23 AM, Rafael J. Wysocki <rjw@sisk.pl>
> > > wrote:
> > >> This message has been generated automatically as a part of a report
> > >> of regressions introduced between 2.6.31 and 2.6.32.
> > >>
> > >> The following bug entry is on the current list of known regressions
> > >> introduced between 2.6.31 and 2.6.32.  Please verify if it still
> > >> should be listed and let me know (either way).
> > >>
> > >>
> > >> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=15015
> > >> Subject         : blank screen at random times in laptop when
> > >> sitting idle Submitter       : Jithin Emmanuel
> > >> <jithin1987@gmail.com> Date            : 2010-01-09 16:48 (16 days
> > >> old)
> > >
> > > FWIW, I might have seen this on my Macbook as well (screen went
> > > blank but I didn't check the logs). I think I managed to unblank
> > > the screen by hitting the "increase brightness" key. But as you
> > > say, the bug doesn't trigger very often and I have no idea how to
> > > reproduce it at will.
> > 
> > I have seen it too on my lenovo T60 with 2.6.32.2. It happens to me
> > frequently and has become famous as "coffee bug" in my colleagues.
> > Every morning when I goto office and after putting my laptop on
> > docking station go for coffee. Once I come back the laptop screen goes
> > blank, but haven't been able to manage how to get screen back. Only
> > option is hard reboot. This happens almost every once in two three
> > days.
> > 
> > Let me know what information/logs I can provide to help debug this.
> > BTW I normally suspend my laptop at home and then resume it in office
> > (if that matters).
> 
> Ouch, looks like our DPMS path is failing pretty hard.  I'll add some
> folks to cc, hopefully it'll be easy to track down.

Thanks for taking care of this.

Rafael
