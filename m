Return-Path: <linux-kernel-owner+w=401wt.eu-S1760284AbXHFCLU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760284AbXHFCLU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2007 22:11:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753342AbXHFCLM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Aug 2007 22:11:12 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:28055 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752710AbXHFCLM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2007 22:11:12 -0400
X-IronPort-AV: i="4.19,223,1183348800"; 
   d="scan'208"; a="36424248:sNHT29552733"
Subject: Re: [GIT PULL] Blackfin arch update for 2.6.23
From: Bryan Wu <bryan.wu@analog.com>
Reply-To: bryan.wu@analog.com
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: bryan.wu@analog.com, Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <8bd0f97a0708051904n294d5955r4dd801ca6b38b5a8@mail.gmail.com>
References: <1186318969.16030.2.camel@roc-laptop>
	 <8bd0f97a0708051904n294d5955r4dd801ca6b38b5a8@mail.gmail.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Analog Devices, Inc.
Date: Mon, 06 Aug 2007 10:10:46 +0800
Message-Id: <1186366246.5609.4.camel@roc-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
X-OriginalArrivalTime: 06 Aug 2007 02:11:10.0694 (UTC) FILETIME=[0EA05860:01C7D7CF]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-08-05 at 22:04 -0400, Mike Frysinger wrote:
> On 8/5/07, Bryan Wu <bryan.wu@analog.com> wrote:
> > Bryan Wu (4):
> >       Blackfin SPI driver: Initial supporting BF54x in SPI driver
> >
> > Michael Hennerich (11):
> >       Blackfin arch: store labels so we later know who allocated GPIO/Peripheral resources
> >       Blackfin arch: add peripheral resource allocation support
> >       Blackfin arch: Add label to call new GPIO API
> >       Blackfin SPI driver: Make BF54x SPI work and add support for  portmux API
> >       Blackfin SPI driver: use new GPIO API and add error handling
> 
> i think this is the sort of thing Linus wants left for initial merge windows ?
> -mike

Actually, this GPIO API has been added to the upstream in -RC1. In this
pull, Michael's patch just enable it in arch code and driver. And it is
tested at least 2-3 weeks, I think it is OK for the -RC merge.

And most our driver things are moved to depend on this new GPIO API. I
just wanna make thing easier to maintain.

Thanks Mike
- Bryan Wu
