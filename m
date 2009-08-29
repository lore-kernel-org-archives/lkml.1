Return-Path: <linux-kernel-owner+w=401wt.eu-S1752489AbZH2TAw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752489AbZH2TAw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Aug 2009 15:00:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752439AbZH2TAw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Aug 2009 15:00:52 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:47161 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752421AbZH2TAv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Aug 2009 15:00:51 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Mikael Pettersson <mikpe@it.uu.se>
Subject: Re: [Bug #14015] pty regressed again, breaking expect and gcc's testsuite
Date: Sat, 29 Aug 2009 21:01:38 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.31-rc8-rjw; KDE/4.3.0; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
References: <riPp5fx5ECC.A.2IG.qsGlKB@chimera> <19096.15539.205951.931871@pilspetsen.it.uu.se> <19097.14413.89047.384281@pilspetsen.it.uu.se>
In-Reply-To: <19097.14413.89047.384281@pilspetsen.it.uu.se>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200908292101.38800.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 29 August 2009, Mikael Pettersson wrote:
> Mikael Pettersson writes:
>  > Rafael J. Wysocki writes:
>  >  > On Thursday 27 August 2009, Mikael Pettersson wrote:
>  >  > > On Tue, 25 Aug 2009 22:34:53 +0200 (CEST), Rafael J. Wysocki wrote:
>  >  > > > The following bug entry is on the current list of known regressions
>  >  > > > from 2.6.30.  Please verify if it still should be listed and let me know
>  >  > > > (either way).
>  >  > > > 
>  >  > > > 
>  >  > > > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=3D14015
>  >  > > > Subject		: pty regressed again, breaking expect and gcc's testsuite
>  >  > > > Submitter	: Mikael Pettersson <mikpe@it.uu.se>
>  >  > > > Date		: 2009-08-14 23:41 (12 days old)
>  >  > > > References	: http://marc.info/?l=3Dlinux-kernel&m=3D125029329805643&w=3D4
>  >  > > 
>  >  > > Not fixed. With 2.6.31-rc7 I'm still seeing repeatable testsuite
>  >  > > failures on powerpc64. Reverting to 2.6.30 makes the failures go away.
>  >  > 
>  >  > Thanks for the update.
>  >  > 
>  >  > I guess 2.6.31-rc8 doesn't make any difference, does it?
>  > 
>  > I've scheduled a number of gcc bootstraps and testsuite runs
>  > with -rc8 on x86, powerpc64, and arm. I'll post an update in
>  > a day or so.
> 
> 2.6.31-rc8 results in bogus testsuite failures on all three platforms.

That may be a result of the known inotify borkage in -rc8 that has been fixed
in the current Linus' tree.

Thanks,
Rafael
