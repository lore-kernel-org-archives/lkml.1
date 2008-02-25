Return-Path: <linux-kernel-owner+w=401wt.eu-S1761864AbYBYWzi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761864AbYBYWzi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 17:55:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761710AbYBYWzY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 17:55:24 -0500
Received: from smtp1.linux-foundation.org ([207.189.120.13]:43081 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759618AbYBYWzU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 17:55:20 -0500
Date: Mon, 25 Feb 2008 14:53:47 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Michael S. Tsirkin" <m.s.tsirkin@gmail.com>
Cc: "Pavel Machek" <pavel@ucw.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       LKML <linux-kernel@vger.kernel.org>,
       "Alexey Starikovskiy" <astarikovskiy@suse.de>,
       "Len Brown" <len.brown@intel.com>, linux-acpi@vger.kernel.org,
       "Jeff Garzik" <jeff@garzik.org>
Subject: Re: broken suspend in .2.6.25-rc3 on T61p (was Re: new regression
 in 2.6.25-rc3: no keyboard/lid acpi events on thinkpad T61p)
Message-Id: <20080225145347.a61f6c61.akpm@linux-foundation.org>
In-Reply-To: <8f53421d0802251448v3e0db63j3f222f041e587f69@mail.gmail.com>
References: <8f53421d0802251119q470a79c1p31048ef136271f84@mail.gmail.com>
	<8f53421d0802251245j5439b37die840e34bb293f995@mail.gmail.com>
	<200802252157.10412.rjw@sisk.pl>
	<20080225212615.GA2659@elf.ucw.cz>
	<8f53421d0802251331n31b37db8gb644dc9aa2d553d4@mail.gmail.com>
	<20080225215049.GD2659@elf.ucw.cz>
	<8f53421d0802251415g2033ca6bqd4e6ea9e2d93f097@mail.gmail.com>
	<20080225222023.GK2659@elf.ucw.cz>
	<8f53421d0802251436vd98a97h5db6b8af3dc39d0@mail.gmail.com>
	<20080225143932.6b83b65d.akpm@linux-foundation.org>
	<8f53421d0802251448v3e0db63j3f222f041e587f69@mail.gmail.com>
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Feb 2008 00:48:12 +0200 "Michael S. Tsirkin" <m.s.tsirkin@gmail.com> wrote:

> On Tue, Feb 26, 2008 at 12:39 AM, Andrew Morton
> <akpm@linux-foundation.org> wrote:
> > On Tue, 26 Feb 2008 00:36:54 +0200 "Michael S. Tsirkin" <m.s.tsirkin@gmail.com> wrote:
> >
> >  > >  Hmm, mystery partly solved... as you guessed it, this piece of code
> >  > >  was not in my tree.
> >  > >
> >  > >  (still, how can this cause autoresume after 5 seconds is a mystery to
> >  > >  me).
> >  > >
> >  > >
> >  > >                                                                 Pavel
> >  >
> >  > Maybe it doesn't. Andrew saw the autoresume on -rc[2,3]
> >
> >  And earlier - I think 2.6.23 does it as well.
> 
> But that one at least resumes fine, does it not?

Nope, the resume-after-five-seconds and black-screen-after-resume have
always been there (I've only had the thing a few months).

I thought the restoring of the screen after resume is handled by the X
server?  I'm using the nv.o driver.  Perhaps nvidia's driver handles it
right, dunno.

