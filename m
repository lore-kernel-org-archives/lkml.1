Return-Path: <linux-kernel-owner+w=401wt.eu-S1760071AbXIBV0q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760071AbXIBV0q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2007 17:26:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750719AbXIBV0i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Sep 2007 17:26:38 -0400
Received: from postfix2-g20.free.fr ([212.27.60.43]:47126 "EHLO
	postfix2-g20.free.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751696AbXIBV0h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2007 17:26:37 -0400
Date: Sun, 2 Sep 2007 23:29:39 +0200
From: FD Cami <francois.cami@free.fr>
To: "Alessandro Suardi" <alessandro.suardi@gmail.com>
Cc: "charles gagalac" <charles.gagalac@gmail.com>,
       "daryll q" <daryll_26m@yahoo.com.ph>, linux-kernel@vger.kernel.org
Subject: Re: Hang in 2.6.23-rc5
Message-Id: <20070902232939.f2c8acbb.francois.cami@free.fr>
In-Reply-To: <5a4c581d0709021338s1e9e0dc0md490a032781b60e8@mail.gmail.com>
References: <994260.18490.qm@web57301.mail.re1.yahoo.com>
	<6cf66ee10709021205u7d57b93fv777f414dbba4373f@mail.gmail.com>
	<5a4c581d0709021338s1e9e0dc0md490a032781b60e8@mail.gmail.com>
X-Mailer: Sylpheed 2.4.4 (GTK+ 2.10.14; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2 Sep 2007 22:38:28 +0200
"Alessandro Suardi" <alessandro.suardi@gmail.com> wrote:

> On 9/2/07, charles gagalac <charles.gagalac@gmail.com> wrote:
> > On 9/2/07, daryll q wrote:
> > > Upgraded my kernel from 2.6.23-rc2 to 2.6.23-rc5.
> > >
> > >  System hangs (caps lock and scroll lock leds are both flashing).
> > >
> > >  It *randomly* happens but most of the time during after login to
> > > KDE.
> > >
> > >  I have not investigated it yet because I have not tried doing
> > > it  before.
> > >
> > >  Also the system is really not responding so I can't do much..
> > > Just hope it blue screen so I can send the error code easily :)
> >
> > i experienced hangs, with the flashing caps and scroll locks as
> > you've described, in a few of my later pulls prior to rc5.  i
> > couldn't reproduce the hangs and my logs didn't show evidence of a
> > problem.  my system under rc5, so far, hasn't hung on me.
> >
> > charles
> 
> Oh, I thought I was the only one. I also had a single hang+flashing
>  Caps & Scroll Lock with -rc5, but haven't had one since.
> 
> I had VMWare Player modules loaded at the time though, and I
>  recently rebuilt them with the any-any-patch-113 (earlier versions
>  would not build with very recent kernels).
> 
> -rc4-git2 and -git3 never hung even with VMWare modules loaded.
> 
> So I disabled the autoload of VMWare stuff. The problem has not
>  reproduced so far. My system is a Dell D610, running updated
>  Fedora 7, with Intel 915GM video chipset.

I've just had a kernel panic, running a vanilla 2.6.23-rc5, no
proprietary modules loaded, running X11 under moderate load.
2.6.23-rc[2-4] have been rock solid on the same box. I've reverted
to rc4 for now.

François
