Return-Path: <linux-kernel-owner+w=401wt.eu-S933701AbXHGCIP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933701AbXHGCIP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 22:08:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762877AbXHGCH7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 22:07:59 -0400
Received: from nwd2mail10.analog.com ([137.71.25.55]:15834 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752448AbXHGCH6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 22:07:58 -0400
X-IronPort-AV: i="4.19,226,1183348800"; 
   d="scan'208"; a="47620083:sNHT27060908"
Subject: Re: [GIT PULL] Blackfin arch update for 2.6.23
From: Bryan Wu <bryan.wu@analog.com>
Reply-To: bryan.wu@analog.com
To: David Brownell <david-b@pacbell.net>
Cc: Mike Frysinger <vapier.adi@gmail.com>, bryan.wu@analog.com,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <200708060907.02506.david-b@pacbell.net>
References: <1186318969.16030.2.camel@roc-laptop>
	 <8bd0f97a0708051904n294d5955r4dd801ca6b38b5a8@mail.gmail.com>
	 <200708060907.02506.david-b@pacbell.net>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Analog Devices, Ltd.
Date: Tue, 07 Aug 2007 10:06:38 +0800
Message-Id: <1186452398.6413.13.camel@roc-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
X-OriginalArrivalTime: 07 Aug 2007 02:07:56.0612 (UTC) FILETIME=[C55B8840:01C7D897]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-08-06 at 09:07 -0700, David Brownell wrote:
> On Sunday 05 August 2007, Mike Frysinger wrote:
> > On 8/5/07, Bryan Wu <bryan.wu@analog.com> wrote:
> > > Bryan Wu (4):
> > >       Blackfin SPI driver: Initial supporting BF54x in SPI driver
> > >
> > > Michael Hennerich (11):
> > >       Blackfin arch: store labels so we later know who allocated GPIO/Peripheral resources
> > >       Blackfin arch: add peripheral resource allocation support
> > >       Blackfin arch: Add label to call new GPIO API
> > >       Blackfin SPI driver: Make BF54x SPI work and add support for portmux API
> > >       Blackfin SPI driver: use new GPIO API and add error handling
> > 
> > i think this is the sort of thing Linus wants left for initial merge windows ?
> 
> What, merging patches that have never even been seen by the relevant
> subsystem maintainer(s)?
> 
> I've never seen any of those SPI patches before, and am not inclined
> to try plucking three of them out of a composite patch for a separate
> review ...
> 

Yeah, although the Blackfin on-chip SPI driver is originally developed
by Luke Yang, currently it is maintained by me. Sorry for this missing,
I will send driver update patches
to related subsystem maintainers in LKML.

> Same goes for GPIO, for that matter.  It's harder to goof those up,
> but it's still possible.  If those were reviewed I personally might
> be inclined to OK merges after RC1; GPIOs get used almost everywhere.
> (Pretty much as Bryan commented...)  Those look more like portmux
> changes than GPIO changes though.

Actually, I wanna to obey the merge window policy, but there are some
many changes in my local tree related to GPIO, silicon anomaly (common
fixing). So I choose GPIO changes in this git-pull, thanks for your
understanding situation.

I will remove the SPI driver patch from this GIT-PULL, a new GIT-PULL
will be requested. 
(Frankly speaking, I am afraid of being added to Linus's shit-list for
the next few releases, -:(( ).

Thanks a lot, Mike and David. 
Best Regards,

- Bryan Wu
