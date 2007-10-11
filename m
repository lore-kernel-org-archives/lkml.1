Return-Path: <linux-kernel-owner+w=401wt.eu-S1756048AbXJKFuW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756048AbXJKFuW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2007 01:50:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753394AbXJKFuJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Oct 2007 01:50:09 -0400
Received: from rv-out-0910.google.com ([209.85.198.184]:31270 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753204AbXJKFuH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2007 01:50:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=G8MPaZEpRcJN4muXL11anmSEhe444Cg3EA/CsB8nZb8Xx75zkRbBrn9srLFCitME0+FrMc11o3xaI3hADbcboVXLTj1PkWRtzpCLZBOtxeND0lml1/rx2/0lqsbT1uDK0v8HzdCA0g/P3zGTZ8jROtOfpdNPBIJv96+WHjIiiA4=
Message-ID: <d9def9db0710102250wc813813p18fd73c52594db8e@mail.gmail.com>
Date: Thu, 11 Oct 2007 07:50:07 +0200
From: "Markus Rechberger" <mrechberger@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [v4l-dvb-maintainer] [GIT PATCHES] V4L/DVB changes for 2.6.24
Cc: mchehab@infradead.org, torvalds@linux-foundation.org,
       linux-dvb-maintainer@linuxtv.org, video4linux-list@redhat.com,
       linux-kernel@vger.kernel.org
In-Reply-To: <20071010223222.27799eef.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1192053794.15601.47.camel@gaivota>
	 <d9def9db0710101600m79bd52e5s210d28630469b1c9@mail.gmail.com>
	 <20071010163625.b4b438ec.akpm@linux-foundation.org>
	 <d9def9db0710102209g1cc905a7w5565f1ecda720ea4@mail.gmail.com>
	 <20071010223222.27799eef.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/11/07, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Thu, 11 Oct 2007 07:09:47 +0200 "Markus Rechberger"
> <mrechberger@gmail.com> wrote:
>
> > On 10/11/07, Andrew Morton <akpm@linux-foundation.org> wrote:
> > > On Thu, 11 Oct 2007 01:00:39 +0200
> > > "Markus Rechberger" <mrechberger@gmail.com> wrote:
> > >
> > > Please don't send 900 line emails to which you have added only an
> additional
> > > paragraph.
> > >
> > > > >  drivers/media/video/em28xx/em28xx-core.c           |    1 -
> > > > >  drivers/media/video/em28xx/em28xx-input.c          |    1 -
> > > > >  drivers/media/video/em28xx/em28xx-video.c          |    6 +-
> > > >
> > > > not accepted
> > >
> > > Until your attempt to get the userspace-driver work merged into the
> kernel
> > > is successful (and from my reading of last month's discussion it is
> nowhere
> > > near that), we should continue to maintain the present driver.
> > >
> > > If you choose to not participate in that maintenance then others will
> need
> > > to do their best in this regard.
> > >
> > > What we should not and will not do is to permit the current driver to be
> > > held hostage to your attempt to force a controversial and apparently
> > > unwelcome change into the tree.
> > >
> >
> > It makes no sense to keep the kernel driver uptodate,
>
> It makes heaps of sense to keep the in-tree driver up to date if the
> out-of-tree driver is unmergeable, which appears to be the case.
>

what is unmergeable?

> > it would make
> > more sense to support the latest driver (which some people are
> > supporting).
>
> But that ignores all of last month's discussion and the various
> reservations which various people have expressed.
>

There were discussions since the beginning of 2006 which lead nowhere.
It finally turned out to be a personal issue between developers and to
stop those useless discussions and to not having to rely on an
incomplete API and not having to strip off the sample drivers the
alternative way was developed.

> Please take my advise, based upon my experience in kernel development: I
> don't expect that we'll be merging the mcentral.de driver in anything like
> its present form.
>
> So we must continue to maintain and evolve the kernel.org driver.
>
> > I just had a look at the driver downloads it makes around 600
> > downloads for september for this driver. If someone's interested in
> > those stats I can give access to it privatly.
> > The current option for people who own such a device is to take the
> > driver from mcentral.de.
>
> Well that's a shame.  But we have n,000 drivers in-tree which work OK
> without doing unusual and disturbing user/kernel splits.
>

ahm, there are more problems than you might think about...
* broken drivers (eg saa7115, incomplete driver tvp5150)
* limited API which is managed by a few (DVB/V4L)
* having to deal with people who disagree alot

I submitted the patches RFCs and didn't get proper comments back then
this doesn't motivate me in any way to continue the work and spend any
efforts in getting companies to release their sample drivers.

As pointed out it's possible to release the complete driver in
userland even as binary driver if someone wants to, unless someone
kicks out usbfs. But the conversion would take a while. And regarding
the plans of the other drivers I pointed out what my plans are.

Markus
