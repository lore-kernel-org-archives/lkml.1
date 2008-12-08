Return-Path: <linux-kernel-owner+w=401wt.eu-S1751730AbYLHSlr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751730AbYLHSlr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 13:41:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751076AbYLHSlj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 13:41:39 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:41217 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750715AbYLHSli (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 13:41:38 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Soeren Sonnenburg <kernel@nn7.de>
Subject: Re: [Bug #11698] 2.6.27-rc7, freezes with &gt; 1 s2ram cycle
Date: Mon, 8 Dec 2008 19:40:53 +0100
User-Agent: KMail/1.9.9
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
References: <49ZBswjGjrL.A.ECE.BGyNJB@chimera> <200812072116.08218.rjw@sisk.pl> <1228753843.3935.10.camel@localhost>
In-Reply-To: <1228753843.3935.10.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812081940.53840.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 8 of December 2008, Soeren Sonnenburg wrote:
> On Sun, 2008-12-07 at 21:16 +0100, Rafael J. Wysocki wrote:
> > On Thursday, 4 of December 2008, Soeren Sonnenburg wrote:
> > > On Wed, 2008-12-03 at 23:40 +0100, Rafael J. Wysocki wrote:
> > > > This message has been generated automatically as a part of a report
> > > > of regressions introduced between 2.6.26 and 2.6.27.
> > > > 
> > > > The following bug entry is on the current list of known regressions
> > > > introduced between 2.6.26 and 2.6.27.  Please verify if it still should
> > > > be listed and let me know (either way).
> > > > 
> > > > 
> > > > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11698
> > > > Subject		: 2.6.27-rc7, freezes with &gt; 1 s2ram cycle
> > > > Submitter	: Soeren Sonnenburg <kernel@nn7.de>
> > > > Date		: 2008-09-29 11:29 (66 days old)
> > > > References	: http://marc.info/?l=linux-kernel&m=122268780926859&w=4
> > > > Handled-By	: Rafael J. Wysocki <rjw@sisk.pl>
> > > 
> > > well it freezes at any s2ram resume attempt, even without X just from
> > > console.
> > 
> > There are quite some things you can try.
> > 
> > First, it would be helpful to verify if it also fails in the minimal
> > configuration, ie. when booted with init=/bin/bash, as described
> > in Documentation/power/basic-pm-debugging.txt under
> > "Testing minimal configuration".
> 
> OK, I've found the problem:
> 
> 1. it does work with init=/bin/bash
> 2. it did not work after doing a binary search in the modules, even
> removing all modules did not help
> 3. I figured out that it only happens when I update the CPU's microcode,
> (booting with init=/bin/bash and /etc/init.d/microcode.ctl start
> triggers it)
> 
> Even better: s2ram always gave me my display back when s2ram under
> console.
> 
> Now I wonder if this is Bug #12100 ?

Well, that's quite likely.

> Unfortunately I need the microcode update, as I am suffering from
> a) PAT WC disabled due to known CPU erratum.
> b) coretemp coretemp.0: Errata AE18 not fixed, update BIOS or microcode of the CPU!
> 
> Anyway I now have a chance to test whether #11698 still occurs.

Hm, #11698 is the $subject bug.  Did you mean some other bug?

Rafael
