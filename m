Return-Path: <linux-kernel-owner+w=401wt.eu-S932182AbXHFCel@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932182AbXHFCel (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2007 22:34:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757060AbXHFCed
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Aug 2007 22:34:33 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:21993 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753179AbXHFCec (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2007 22:34:32 -0400
X-IronPort-AV: i="4.19,223,1183348800"; 
   d="scan'208"; a="36426244:sNHT29488620"
Subject: Re: [GIT PULL] Blackfin arch update for 2.6.23
From: Bryan Wu <bryan.wu@analog.com>
Reply-To: bryan.wu@analog.com
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: bryan.wu@analog.com, Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <8bd0f97a0708051926l63718982l4c991aebd817c94b@mail.gmail.com>
References: <1186318969.16030.2.camel@roc-laptop>
	 <8bd0f97a0708051904n294d5955r4dd801ca6b38b5a8@mail.gmail.com>
	 <1186366246.5609.4.camel@roc-desktop>
	 <8bd0f97a0708051926l63718982l4c991aebd817c94b@mail.gmail.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Analog Devices, Inc.
Date: Mon, 06 Aug 2007 10:34:09 +0800
Message-Id: <1186367649.5609.11.camel@roc-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
X-OriginalArrivalTime: 06 Aug 2007 02:34:31.0564 (UTC) FILETIME=[519C24C0:01C7D7D2]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-08-05 at 22:26 -0400, Mike Frysinger wrote:
> On 8/5/07, Bryan Wu <bryan.wu@analog.com> wrote:
> > On Sun, 2007-08-05 at 22:04 -0400, Mike Frysinger wrote:
> > > On 8/5/07, Bryan Wu <bryan.wu@analog.com> wrote:
> > > > Bryan Wu (4):
> > > >       Blackfin SPI driver: Initial supporting BF54x in SPI driver
> > > >
> > > > Michael Hennerich (11):
> > > >       Blackfin arch: store labels so we later know who allocated GPIO/Peripheral resources
> > > >       Blackfin arch: add peripheral resource allocation support
> > > >       Blackfin arch: Add label to call new GPIO API
> > > >       Blackfin SPI driver: Make BF54x SPI work and add support for  portmux API
> > > >       Blackfin SPI driver: use new GPIO API and add error handling
> > >
> > > i think this is the sort of thing Linus wants left for initial merge windows ?
> > > -mike
> >
> > Actually, this GPIO API has been added to the upstream in -RC1. In this
> > pull, Michael's patch just enable it in arch code and driver. And it is
> > tested at least 2-3 weeks, I think it is OK for the -RC merge.
> >
> > And most our driver things are moved to depend on this new GPIO API. I
> > just wanna make thing easier to maintain.
> 
> i was referring to the SPI stuff, not GPIO
> -mike

This GIT-PULL is for Blackfin new GPIO update, so I including this SPI
driver patches related to GPIO update. You know, there are still some
SPI patches not included in this GIT-PULL because they are not related
to GPIO update.

So next GIT-PULL, I will try to send out anomaly update from you and
Robin.

Regards,
- Bryan
