Return-Path: <linux-kernel-owner+w=401wt.eu-S1755348AbYHSS2u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755348AbYHSS2u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 14:28:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751280AbYHSS2l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 14:28:41 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59900 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751162AbYHSS2k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 14:28:40 -0400
Date: Tue, 19 Aug 2008 11:28:28 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Dmitry <dbaryshkov@gmail.com>
Cc: david-b@pacbell.net, linux-kernel@vger.kernel.org,
       dbrownell@users.sourceforge.net
Subject: Re: [PATCH] Make gpiochip label const
Message-Id: <20080819112828.dcfed0eb.akpm@linux-foundation.org>
In-Reply-To: <bc64b4640808190413o151cfb8x7809f0e08d1f7aaa@mail.gmail.com>
References: <1218573588-25528-1-git-send-email-dbaryshkov@gmail.com>
	<20080812220619.D2011362B0F@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
	<20080817190035.GA29170@doriath.ww600.siemens.net>
	<20080819014305.44a1f9b8.akpm@linux-foundation.org>
	<bc64b4640808190413o151cfb8x7809f0e08d1f7aaa@mail.gmail.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Aug 2008 15:13:47 +0400
Dmitry <dbaryshkov@gmail.com> wrote:

> 2008/8/19 Andrew Morton <akpm@linux-foundation.org>:
> > On Sun, 17 Aug 2008 23:00:35 +0400 Dmitry Baryshkov <dbaryshkov@gmail.com> wrote:
> >
> >> On Tue, Aug 12, 2008 at 03:06:19PM -0700, David Brownell wrote:
> >> > > From dbaryshkov@gmail.com  Tue Aug 12 13:54:29 2008
> >> > > From: Dmitry Baryshkov <dbaryshkov@gmail.com>
> >> > > To: linux-kernel@vger.kernel.org
> >> > > Cc: Dmitry Baryshkov <dbaryshkov@gmail.com>,
> >> > >   David Brownell <dbrownell@users.sourceforge.net>
> >> > > Subject: [PATCH] Make gpiochip label const
> >> > > Date: Wed, 13 Aug 2008 00:39:48 +0400
> >> > >
> >> > > Mark gpiochip label as a const char pointer.
> >> > >
> >> > > Signed-off-by: Dmitry Baryshkov <dbaryshkov@gmail.com>
> >> > > Cc: David Brownell <dbrownell@users.sourceforge.net>
> >> >
> >> > Acked-By: David Brownell <dbrownell@users.sourceforge.net>
> >> >
> >>
> >> Sorry to disturb, but will this make into 2.6.27-rc? Thanks.
> >>
> >
> > Ordinarily it would not.  Is there some reason why you think it should?
> >
> 
> It fixes lots of warnings (one per each instance of code filling the gpio chip)


That should have been in the changelog!

When fixing warnings or compilations errors, the compiler output should
also be in the changelog.

I don't recall seeing such warnings and I cannot make them happen with
drivers/gpio/gpiolib.c or with drivers/gpio/max732x.c or with
drivers/gpio/pca953x.c.  So we still don't know what this patch
does :(

> and is pretty much small to honour inclusion IMO

Well sure it's small.  But converting things to `const' carries a
fairly high risk of adding new warnings or breaking the build.

