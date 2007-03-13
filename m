Return-Path: <linux-kernel-owner+w=401wt.eu-S933783AbXCMWU6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933783AbXCMWU6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 18:20:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933781AbXCMWU6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 18:20:58 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:58100
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S933775AbXCMWU5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 18:20:57 -0400
Date: Tue, 13 Mar 2007 15:20:54 -0700 (PDT)
Message-Id: <20070313.152054.31641425.davem@davemloft.net>
To: nish.aravamudan@gmail.com
Cc: greg@kroah.com, linux-kernel@vger.kernel.org, akpm@osdl.org,
       torvalds@osdl.org, stable@kernel.org, sparclinux@vger.kernel.org
Subject: Re: Linux 2.6.20.3
From: David Miller <davem@davemloft.net>
In-Reply-To: <29495f1d0703131458j18f9aee1tcd9a2b2ff6ecdf41@mail.gmail.com>
References: <20070313183353.GA7434@kroah.com>
	<29495f1d0703131457i43883529p5da1502b68ff0948@mail.gmail.com>
	<29495f1d0703131458j18f9aee1tcd9a2b2ff6ecdf41@mail.gmail.com>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Nish Aravamudan" <nish.aravamudan@gmail.com>
Date: Tue, 13 Mar 2007 14:58:24 -0700

> On 3/13/07, Nish Aravamudan <nish.aravamudan@gmail.com> wrote:
> > On 3/13/07, Greg KH <greg@kroah.com> wrote:
> > > We (the -stable team) are announcing the release of the 2.6.20.3 kernel.
> > > It contains a number of bugfixes and all 2.6.20 users are recommended to
> > > upgrade.
> > >
> > > The diffstat and short summary of the fixes are below.
> > >
> > > I'll also be replying to this message with a copy of the patch between
> > > 2.6.20.2 and 2.6.20.3.
> >
> > Compared to 2.6.20.1 (will try 2.6.20.2 as well), I now get:
> 
> err, duh -- this is a Sun Ultra 60, debian testing install.

Figure out if 2.6.20.2 does it too, then please try to git bisect
it down further.

I took a quick look and the two sparc64 commits between 2.6.20.1
and 2.6.20.2 are benign, a fix for E450 interrupts and a kenvctrld
fix which is for a driver for hardware your ultra60 doesn't have. :)

There is a decent amount of raid and nfs fixes in here, do you
use either?

Another commit that might be relevant is:

commit 530b09160744a12450fdacb2b78779c9830a29c8
Author: Aristeu Sergio Rozanski Filho <aristeu.sergio@gmail.com>
Date:   Thu Mar 1 19:02:55 2007 -0500

    tty_io: fix race in master pty close/slave pty close path

Hmmm...

Please let us know if you can narrow it down further.
