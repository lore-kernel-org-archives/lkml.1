Return-Path: <linux-kernel-owner+w=401wt.eu-S1756818AbXJKFdz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756818AbXJKFdz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2007 01:33:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753537AbXJKFds
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Oct 2007 01:33:48 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52077 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753527AbXJKFdr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2007 01:33:47 -0400
Date: Wed, 10 Oct 2007 22:32:22 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Markus Rechberger" <mrechberger@gmail.com>
Cc: mchehab@infradead.org, torvalds@linux-foundation.org,
       linux-dvb-maintainer@linuxtv.org, video4linux-list@redhat.com,
       linux-kernel@vger.kernel.org
Subject: Re: [v4l-dvb-maintainer] [GIT PATCHES] V4L/DVB changes for 2.6.24
Message-Id: <20071010223222.27799eef.akpm@linux-foundation.org>
In-Reply-To: <d9def9db0710102209g1cc905a7w5565f1ecda720ea4@mail.gmail.com>
References: <1192053794.15601.47.camel@gaivota>
	<d9def9db0710101600m79bd52e5s210d28630469b1c9@mail.gmail.com>
	<20071010163625.b4b438ec.akpm@linux-foundation.org>
	<d9def9db0710102209g1cc905a7w5565f1ecda720ea4@mail.gmail.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Oct 2007 07:09:47 +0200 "Markus Rechberger" <mrechberger@gmail.com> wrote:

> On 10/11/07, Andrew Morton <akpm@linux-foundation.org> wrote:
> > On Thu, 11 Oct 2007 01:00:39 +0200
> > "Markus Rechberger" <mrechberger@gmail.com> wrote:
> >
> > Please don't send 900 line emails to which you have added only an additional
> > paragraph.
> >
> > > >  drivers/media/video/em28xx/em28xx-core.c           |    1 -
> > > >  drivers/media/video/em28xx/em28xx-input.c          |    1 -
> > > >  drivers/media/video/em28xx/em28xx-video.c          |    6 +-
> > >
> > > not accepted
> >
> > Until your attempt to get the userspace-driver work merged into the kernel
> > is successful (and from my reading of last month's discussion it is nowhere
> > near that), we should continue to maintain the present driver.
> >
> > If you choose to not participate in that maintenance then others will need
> > to do their best in this regard.
> >
> > What we should not and will not do is to permit the current driver to be
> > held hostage to your attempt to force a controversial and apparently
> > unwelcome change into the tree.
> >
> 
> It makes no sense to keep the kernel driver uptodate,

It makes heaps of sense to keep the in-tree driver up to date if the
out-of-tree driver is unmergeable, which appears to be the case.

> it would make
> more sense to support the latest driver (which some people are
> supporting).

But that ignores all of last month's discussion and the various
reservations which various people have expressed.

Please take my advise, based upon my experience in kernel development: I
don't expect that we'll be merging the mcentral.de driver in anything like
its present form.

So we must continue to maintain and evolve the kernel.org driver.

> I just had a look at the driver downloads it makes around 600
> downloads for september for this driver. If someone's interested in
> those stats I can give access to it privatly.
> The current option for people who own such a device is to take the
> driver from mcentral.de.

Well that's a shame.  But we have n,000 drivers in-tree which work OK
without doing unusual and disturbing user/kernel splits.
