Return-Path: <linux-kernel-owner+w=401wt.eu-S1756768AbYALPZL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756768AbYALPZL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jan 2008 10:25:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750934AbYALPY7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jan 2008 10:24:59 -0500
Received: from py-out-1112.google.com ([64.233.166.182]:25794 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750931AbYALPY6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jan 2008 10:24:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=tQcyyEV61hEN+mrDw6+rXObe+8V/E/vxKdd9NotVNv2AsW9JBaZseJ92Z0JOKuwA09GchI2DI2KhLUOExOLJRbt/yXZinI96PwuLg+xWvfX7+UGfSrZSdRW2fuKiYIYJTqs11+yxmg2p0Kzj5iQ5gEStaAXPegamKZloYXzCB7E=
Message-ID: <386072610801120724m77ac82d2h55374be25dbc5f9a@mail.gmail.com>
Date: Sat, 12 Jan 2008 23:24:56 +0800
From: "Bryan Wu" <cooloney.lkml@gmail.com>
To: "Robin Getz" <rgetz@blackfin.uclinux.org>
Subject: Re: [patch] split MMC_CAP_4_BIT_DATA
Cc: "Pierre Ossman" <drzeus-mmc@drzeus.cx>,
       "Mike Frysinger" <vapier.adi@gmail.com>,
       "Cai, Cliff" <Cliff.Cai@analog.com>, linux-kernel@vger.kernel.org
In-Reply-To: <200801120802.37259.rgetz@blackfin.uclinux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <386072610801081832w2befcbafwe9215067f022ed5d@mail.gmail.com>
	 <20080111103532.2789b74f@poseidon.drzeus.cx>
	 <200801111252.02285.rgetz@blackfin.uclinux.org>
	 <200801120802.37259.rgetz@blackfin.uclinux.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 12, 2008 9:02 PM, Robin Getz <rgetz@blackfin.uclinux.org> wrote:
> On Fri 11 Jan 2008 12:52, Robin Getz pondered:
>
> > On Fri 11 Jan 2008 04:35, Pierre Ossman pondered:
> > > On Fri, 11 Jan 2008 04:08:53 -0500
> > > "Mike Frysinger" <vapier.adi@gmail.com> wrote:
> > >
> > > > On Jan 11, 2008 3:40 AM, Pierre Ossman <drzeus-mmc@drzeus.cx> wrote:
> > > > > So it's far more probable that you've misdiagnosed your error than
> > > this being the actual problem.
> > > >
> > > > the guys who design the silicon are telling us it doesnt work.  our
> > > > tests show it not working.  i'm not sure what else you want here.
> > > >
> > >
> > > More information. You have not provided any speculation as to why it
> > > doesn't work, or what you've done to figure it out.
> >
> > I have been trying to get the detailed information from the hardware
> > (silicon designer) guy about why he believes support for 4-bit MMC is
> > not there, but I have not heard back yet.
> >
> > As soon as I hear from them - and either understand why 4-bit MMC doesn't
> > work, or if the Blackfin docs are incorrect (either is OK outcome) - I will
> > let you know.
>
> According to the HW folks - it is exactly as Pierre indicated - in theory it
> should work, 4-bit MMC requires usage of different set of commands as
> compared to 4-bit SD, so it should be just software - although no one has
> tested it yet.
>

Vivi is helping us to do the test again, and she will fire a bug
tracker about this issue next week.
So we can debug it again.

> So I guess this is back on Bryan/Cliff to make work....
>
> Thanks for pushing back.
>

Yes, Thanks a lot Pierre.
-Bryan Wu
