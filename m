Return-Path: <linux-kernel-owner+w=401wt.eu-S1761434AbYBAWkm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761434AbYBAWkm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 17:40:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759649AbYBAWia
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 17:38:30 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:50833 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761279AbYBAWi1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 17:38:27 -0500
Date: Fri, 1 Feb 2008 23:38:29 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Jeff Garzik <jeff@garzik.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       linux arch <linux-arch@vger.kernel.org>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Are Section mismatches out of control?
Message-ID: <20080201223829.GB17828@uranus.ravnborg.org>
References: <20080201104718.GA11717@uranus.ravnborg.org> <20080201030329.9b760777.akpm@linux-foundation.org> <47A34C47.9040306@garzik.org> <20080201201713.GA15905@uranus.ravnborg.org> <47A37FE5.2060200@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47A37FE5.2060200@garzik.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 01, 2008 at 03:24:05PM -0500, Jeff Garzik wrote:
> Sam Ravnborg wrote:
> >One can ignore or one can fix...
> >I decided to spend some of my friday on fixing section mismatch
> >warnings as I've got a bit irritated over people spending time
> >complaining but failing to provide patches.
> 
> >	Sam - who expected more people to actually fix this stuff :-(
> 
> Well, with due respect, it's a bit presumptuous to add a bunch of 
> warnings to the kernel build (due to more strict checking), and then get 
> annoyed when people aren't jumping up and fixing this stuff immediately.

I did some testing and the new code does not emit warnings which were
not emitted before. But previously you had to use less typical
configurations to see them like HOTPLUG_CPU=y, HOTPLUG=n, gcc 3.3

> 
> There were no build complaints in 2.6.24 for my stuff (libata and 
> drivers/net) during my test builds, nor were there any for my 2.6.25-git 
> merge window pushes, nor were there any complaints when I last checked 
> Andrew's -mm tree.
> 
> So from our perspective, you dumped a lot of work in our laps from out 
> of the blue, getting irritated at us along the way.
> 
> Maybe we can resolve this in a more kinder, gentler, coordinated 
> fashion?  :)
It is the misinformation being spread that irritates me.
Thousand of hours, no real bugs found etc.

Anyway - that is all forgot tomorrow when we get the warning level down
to zero.
> 
> What could be done to prevent this sort of situation in the future? 
> Maybe add these checks to -mm, and then not push your strict checking 
> upstream until the build noise is reduced?

The good thing about getting it upstream is the additional attention.
If we do not get it down to acceptable levels I have no problems
turning off the section mismatch in minline but keep it enabled
in -mm.

	Sam
