Return-Path: <linux-kernel-owner+w=401wt.eu-S1753274AbZHXSbO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753274AbZHXSbO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 14:31:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753251AbZHXSbM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 14:31:12 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:52266 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753232AbZHXSbL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 14:31:11 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Mikael Pettersson <mikpe@it.uu.se>
Subject: Re: [Bug #14015] pty regressed again, breaking expect and gcc's testsuite
Date: Mon, 24 Aug 2009 20:32:10 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.31-rc6-rjw; KDE/4.3.0; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
References: <jCYznkTxcLB.A.EPH.eNIjKB@chimera> <ADSuNT6McuD.A.wlH.nNIjKB@chimera> <19090.26298.630328.344190@pilspetsen.it.uu.se>
In-Reply-To: <19090.26298.630328.344190@pilspetsen.it.uu.se>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200908242032.11065.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 24 August 2009, Mikael Pettersson wrote:
> On Wed, 19 Aug 2009 22:27:02 +0200 (CEST), Rafael J. Wysocki wrote:
> > The following bug entry is on the current list of known regressions
> > from 2.6.30.  Please verify if it still should be listed and let me know
> > (either way).
> > 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=3D14015
> > Subject		: pty regressed again, breaking expect and gcc's testsuite
> > Submitter	: Mikael Pettersson <mikpe@it.uu.se>
> > Date		: 2009-08-14 23:41 (6 days old)
> > References	: http://marc.info/?l=3Dlinux-kernel&m=3D125029329805643&w=3D4
> 
> The good news is that I don't see this issue any more with 2.6.31-rc7
> on x86. The bad news is that the first time I reported this issue, for
> -rc3 or -rc4 I think, I thought it was fixed in -rc5 only to see it
> reappear in -rc6 on x86 and in -rc5 on ARM. So I'd like to keep this
> open another week while I run more regression tests on non-x86 platforms.
> 
> While I don't suspect any arch-specific problems in the pty/tty code,
> I do suspect timing/race-type problems which are obviously affected
> by platform speed etc.

OK, thanks for the update.

Rafael
