Return-Path: <linux-kernel-owner+w=401wt.eu-S1754919AbXKZPUJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754919AbXKZPUJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 10:20:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750959AbXKZPTz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 10:19:55 -0500
Received: from ug-out-1314.google.com ([66.249.92.170]:17157 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751279AbXKZPTy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 10:19:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=pROAW4cx1mpeLB/lIBuaNQElR1/RaDpcccHe9IzZXpdfTM7hTsCgAKYXw8x633hzfszZSFy3tgE+sCBCedJErsjJXMM0GNAn/e2x5/TiD0j5Av4bHXUJPYV00IbYhw4QyGE1am1KH6kIQCgeV4oS/h0j8+alS9J+mKtHiDU2ZMs=
Message-ID: <2c0942db0711260719t4468807bm85fcc8cc4ebd138@mail.gmail.com>
Date: Mon, 26 Nov 2007 07:19:52 -0800
From: "Ray Lee" <ray-lk@madrabbit.org>
To: "Robert P. J. Day" <rpjday@crashcourse.ca>
Subject: Re: can support for "rpm"-based package building just be dropped?
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.LFD.0.9999.0711261010480.22378@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <alpine.LFD.0.9999.0711260352060.30676@localhost.localdomain>
	 <2c0942db0711260658j5ce017e7ucce4c373748ed7b7@mail.gmail.com>
	 <alpine.LFD.0.9999.0711261007370.22202@localhost.localdomain>
	 <alpine.LFD.0.9999.0711261010480.22378@localhost.localdomain>
X-Google-Sender-Auth: ca72976d1b68785f
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Nov 26, 2007 7:12 AM, Robert P. J. Day <rpjday@crashcourse.ca> wrote:
> On Mon, 26 Nov 2007, Robert P. J. Day wrote:
>
> > On Mon, 26 Nov 2007, Ray Lee wrote:
> >
> > > On Nov 26, 2007 12:54 AM, Robert P. J. Day <rpjday@crashcourse.ca> wrote:
> > > >   on current systems, "rpm" no longer has build capability and will
> > > > fail thusly:
> > > >
> > > > rpm --target i386 -ta ../kernel-2.6.24rc3g2ffbb837dirty.tar.gz
> > > > --target: unknown option
> > > >
> > > >   so it would make more sense to just require "rpmbuild" on the
> > > > machine, would it not?
> > >
> > > Only on current machines. You'd break building kernel RPMs on older
> > > systems that don't have rpmbuild installed. So the change wouldn't
> > > fix anything, and would break some non-zero number of setups that
> > > are currently working, making the change a guaranteed net loss.
> > >
> > > A patch that added version checks against rpm and whinged
> > > appropriately about needing rpmbuild would likely be accepted,
> > > though.
> >
> > yes, i suspect that's the right answer.
> >
> > rday
>
> BTW, is there someone who knows what the relevant version is of "rpm"
> that stopped incorporating the packaging functionality?  i'm a bit
> swamped today but if someone wants to whip up a patch and get it in
> before the next major release, that would be useful, i would think.
>
> in short, can someone else handle this?  :-)

I'm afraid I'm all .deb here, so no go for me.
