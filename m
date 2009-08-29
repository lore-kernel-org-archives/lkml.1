Return-Path: <linux-kernel-owner+w=401wt.eu-S1751890AbZH2O7f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751890AbZH2O7f (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Aug 2009 10:59:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751836AbZH2O7e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Aug 2009 10:59:34 -0400
Received: from fanny.its.uu.se ([130.238.4.241]:44912 "EHLO fanny.its.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751813AbZH2O7d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Aug 2009 10:59:33 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19097.14413.89047.384281@pilspetsen.it.uu.se>
Date: Sat, 29 Aug 2009 16:16:45 +0200
From: Mikael Pettersson <mikpe@it.uu.se>
To: Mikael Pettersson <mikpe@it.uu.se>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: [Bug #14015] pty regressed again, breaking expect and gcc's testsuite
In-Reply-To: <19096.15539.205951.931871@pilspetsen.it.uu.se>
References: <riPp5fx5ECC.A.2IG.qsGlKB@chimera>
	<_yaHeGjHEzG.A.tMH.9sGlKB@chimera>
	<19094.58486.867940.103340@pilspetsen.it.uu.se>
	<200908282056.10251.rjw@sisk.pl>
	<19096.15539.205951.931871@pilspetsen.it.uu.se>
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mikael Pettersson writes:
 > Rafael J. Wysocki writes:
 >  > On Thursday 27 August 2009, Mikael Pettersson wrote:
 >  > > On Tue, 25 Aug 2009 22:34:53 +0200 (CEST), Rafael J. Wysocki wrote:
 >  > > > The following bug entry is on the current list of known regressions
 >  > > > from 2.6.30.  Please verify if it still should be listed and let me know
 >  > > > (either way).
 >  > > > 
 >  > > > 
 >  > > > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=3D14015
 >  > > > Subject		: pty regressed again, breaking expect and gcc's testsuite
 >  > > > Submitter	: Mikael Pettersson <mikpe@it.uu.se>
 >  > > > Date		: 2009-08-14 23:41 (12 days old)
 >  > > > References	: http://marc.info/?l=3Dlinux-kernel&m=3D125029329805643&w=3D4
 >  > > 
 >  > > Not fixed. With 2.6.31-rc7 I'm still seeing repeatable testsuite
 >  > > failures on powerpc64. Reverting to 2.6.30 makes the failures go away.
 >  > 
 >  > Thanks for the update.
 >  > 
 >  > I guess 2.6.31-rc8 doesn't make any difference, does it?
 > 
 > I've scheduled a number of gcc bootstraps and testsuite runs
 > with -rc8 on x86, powerpc64, and arm. I'll post an update in
 > a day or so.

2.6.31-rc8 results in bogus testsuite failures on all three platforms.
