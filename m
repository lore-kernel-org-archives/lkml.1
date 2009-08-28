Return-Path: <linux-kernel-owner+w=401wt.eu-S1753167AbZH1UXc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753167AbZH1UXc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Aug 2009 16:23:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753144AbZH1UXa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Aug 2009 16:23:30 -0400
Received: from fanny.its.uu.se ([130.238.4.241]:42181 "EHLO fanny.its.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753113AbZH1UX1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Aug 2009 16:23:27 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19096.15539.205951.931871@pilspetsen.it.uu.se>
Date: Fri, 28 Aug 2009 22:23:15 +0200
From: Mikael Pettersson <mikpe@it.uu.se>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Mikael Pettersson <mikpe@it.uu.se>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: [Bug #14015] pty regressed again, breaking expect and gcc's testsuite
In-Reply-To: <200908282056.10251.rjw@sisk.pl>
References: <riPp5fx5ECC.A.2IG.qsGlKB@chimera>
	<_yaHeGjHEzG.A.tMH.9sGlKB@chimera>
	<19094.58486.867940.103340@pilspetsen.it.uu.se>
	<200908282056.10251.rjw@sisk.pl>
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki writes:
 > On Thursday 27 August 2009, Mikael Pettersson wrote:
 > > On Tue, 25 Aug 2009 22:34:53 +0200 (CEST), Rafael J. Wysocki wrote:
 > > > The following bug entry is on the current list of known regressions
 > > > from 2.6.30.  Please verify if it still should be listed and let me know
 > > > (either way).
 > > > 
 > > > 
 > > > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=3D14015
 > > > Subject		: pty regressed again, breaking expect and gcc's testsuite
 > > > Submitter	: Mikael Pettersson <mikpe@it.uu.se>
 > > > Date		: 2009-08-14 23:41 (12 days old)
 > > > References	: http://marc.info/?l=3Dlinux-kernel&m=3D125029329805643&w=3D4
 > > 
 > > Not fixed. With 2.6.31-rc7 I'm still seeing repeatable testsuite
 > > failures on powerpc64. Reverting to 2.6.30 makes the failures go away.
 > 
 > Thanks for the update.
 > 
 > I guess 2.6.31-rc8 doesn't make any difference, does it?

I've scheduled a number of gcc bootstraps and testsuite runs
with -rc8 on x86, powerpc64, and arm. I'll post an update in
a day or so.
