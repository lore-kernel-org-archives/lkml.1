Return-Path: <linux-kernel-owner+w=401wt.eu-S1761994AbXGES4Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761994AbXGES4Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 14:56:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760168AbXGES4G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 14:56:06 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:54804 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758779AbXGES4D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 14:56:03 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH] Optional Beeping During Resume From Suspend To Ram.
Date: Thu, 5 Jul 2007 21:03:16 +0200
User-Agent: KMail/1.9.5
Cc: Nigel Cunningham <nigel@nigel.suspend2.net>,
       LKML <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>
References: <200706192118.23706.nigel@nigel.suspend2.net> <200707042350.25117.rjw@sisk.pl> <20070704224653.GB2491@elf.ucw.cz>
In-Reply-To: <20070704224653.GB2491@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707052103.17104.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 5 July 2007 00:46, Pavel Machek wrote:
> Hi!
> 
> > > Here's the version that uses just one variable, relative to Nigel's
> > > patch. Hmm, and it also closes nasty trap for the user in
> > > acpi_sleep_setup; order of parameters actually mattered there,
> > > acpi_sleep=s3_bios,s3_mode doing something different from
> > > acpi_sleep=s3_mode,s3_bios .  It actually works here.
> > > 
> > > Will you fold it into  patch28, or should I create a changelog?
> > 
> > Hmm, I think we should keep the record straight.  Please add a changelog
> > if that's not a problem.
> 
> (I also added documentation and removed the superfluous beep_flags).

OK, thanks.

Added to the patchset as

http://www.sisk.pl/kernel/hibernation_and_suspend/2.6.22-rc7/patches/50-Optional-Beeping-During-Resume-From-Suspend-To-Ram-tidy.patch

I think both patches are -mm-ready, aren't they?

Greetings,
Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth
