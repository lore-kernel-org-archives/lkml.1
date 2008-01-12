Return-Path: <linux-kernel-owner+w=401wt.eu-S1763478AbYALNBk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763478AbYALNBk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jan 2008 08:01:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762306AbYALNBc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jan 2008 08:01:32 -0500
Received: from nwd2mail11.analog.com ([137.71.25.57]:36257 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761684AbYALNBc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jan 2008 08:01:32 -0500
X-IronPort-AV: E=Sophos;i="4.24,275,1196658000"; 
   d="scan'208";a="46637606"
From: Robin Getz <rgetz@blackfin.uclinux.org>
Organization: Blackfin uClinux org
To: "Pierre Ossman" <drzeus-mmc@drzeus.cx>
Subject: Re: [patch] split MMC_CAP_4_BIT_DATA
Date: Sat, 12 Jan 2008 08:02:37 -0500
User-Agent: KMail/1.9.5
Cc: "Mike Frysinger" <vapier.adi@gmail.com>,
       "Bryan Wu" <cooloney.lkml@gmail.com>,
       "Cai, Cliff" <Cliff.Cai@analog.com>, linux-kernel@vger.kernel.org
References: <386072610801081832w2befcbafwe9215067f022ed5d@mail.gmail.com> <20080111103532.2789b74f@poseidon.drzeus.cx> <200801111252.02285.rgetz@blackfin.uclinux.org>
In-Reply-To: <200801111252.02285.rgetz@blackfin.uclinux.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801120802.37259.rgetz@blackfin.uclinux.org>
X-OriginalArrivalTime: 12 Jan 2008 13:01:29.0714 (UTC) FILETIME=[3F748D20:01C8551B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 11 Jan 2008 12:52, Robin Getz pondered:
> On Fri 11 Jan 2008 04:35, Pierre Ossman pondered:
> > On Fri, 11 Jan 2008 04:08:53 -0500
> > "Mike Frysinger" <vapier.adi@gmail.com> wrote:
> > 
> > > On Jan 11, 2008 3:40 AM, Pierre Ossman <drzeus-mmc@drzeus.cx> wrote:
> > > > So it's far more probable that you've misdiagnosed your error than
> > this being the actual problem.
> > > 
> > > the guys who design the silicon are telling us it doesnt work.  our
> > > tests show it not working.  i'm not sure what else you want here.
> > > 
> > 
> > More information. You have not provided any speculation as to why it
> > doesn't work, or what you've done to figure it out.
> 
> I have been trying to get the detailed information from the hardware
> (silicon designer) guy about why he believes support for 4-bit MMC is
> not there, but I have not heard back yet.
> 
> As soon as I hear from them - and either understand why 4-bit MMC doesn't 
> work, or if the Blackfin docs are incorrect (either is OK outcome) - I will 
> let you know.

According to the HW folks - it is exactly as Pierre indicated - in theory it 
should work, 4-bit MMC requires usage of different set of commands as 
compared to 4-bit SD, so it should be just software - although no one has 
tested it yet.

So I guess this is back on Bryan/Cliff to make work....

Thanks for pushing back.

-Robin
