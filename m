Return-Path: <linux-kernel-owner+w=401wt.eu-S1753443AbZBHNkW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753443AbZBHNkW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Feb 2009 08:40:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751872AbZBHNkI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Feb 2009 08:40:08 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:38357 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751330AbZBHNkH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Feb 2009 08:40:07 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Paul Collins <paul@burly.ondioline.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: Badness at kernel/time/timekeeping.c:98 in pmud (timekeeping_suspended)
Date: Sun, 8 Feb 2009 14:39:30 +0100
User-Agent: KMail/1.11.0 (Linux/2.6.29-rc2-tst; KDE/4.2.0; x86_64; ; )
Cc: Thomas Gleixner <tglx@linutronix.de>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
References: <87prihcepl.fsf@burly.wgtn.ondioline.org> <87k58nda87.fsf@burly.wgtn.ondioline.org> <874oz5pmvd.fsf@burly.wgtn.ondioline.org>
In-Reply-To: <874oz5pmvd.fsf@burly.wgtn.ondioline.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902081439.31548.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 08 February 2009, Paul Collins wrote:
> Paul Collins <paul@burly.ondioline.org> writes:
> 
> > "Rafael J. Wysocki" <rjw@sisk.pl> writes:
> >
> >> On Wednesday 21 January 2009, Paul Collins wrote:
> >>> Got a couple of these on a PowerBook running 2.6.29-rc2 either during
> >>> suspend or resume -- it's hard to tell.  (The suspend message is
> >>> timestamped in syslog with the time I resumed, so I guess it was
> >>> buffered along with the subsequent "Badness" messages.)
> >>
> >> Please check if the patch from http://lkml.org/lkml/2009/1/13/144 fixes the
> >> problem for you.
> >
> > It does not fix the problem.
> 
> I'm also getting this warning since 2.6.28.1, which incorporated commit
> 1c5745aa380efb6417b5681104b007c8612fb496 ("sched_clock: prevent
> scd->clock from moving backwards, take #2") as commit
> e268dcdd404f4558cdd24c8ecede3e064df8fa33, this being the patch that
> introduced the WARN_ON(timekeeping_suspended) check.

Hm, I thought the timekeeping suspend problem was fixed in this commit.  Ingo?
