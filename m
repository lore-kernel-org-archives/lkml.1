Return-Path: <linux-kernel-owner+w=401wt.eu-S1758848AbXKTIb0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758848AbXKTIb0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 03:31:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757449AbXKTIbT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 03:31:19 -0500
Received: from mtagate7.uk.ibm.com ([195.212.29.140]:46578 "EHLO
	mtagate7.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756781AbXKTIbS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 03:31:18 -0500
Date: Tue, 20 Nov 2007 09:30:44 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 1/3] tty: Add the new termios2 ioctls to the compatible
	list.
Message-ID: <20071120083044.GB7992@osiris.boeblingen.de.ibm.com>
References: <20071119125206.GA8623@osiris.boeblingen.de.ibm.com> <20071119230249.874ba094.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071119230249.874ba094.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 19, 2007 at 11:02:49PM -0800, Andrew Morton wrote:
> On Mon, 19 Nov 2007 13:52:06 +0100 Heiko Carstens <heiko.carstens@de.ibm.com> wrote:
> > Index: linux-2.6/fs/compat_ioctl.c
> > ===================================================================
> > --- linux-2.6.orig/fs/compat_ioctl.c
> > +++ linux-2.6/fs/compat_ioctl.c
> > @@ -1954,6 +1954,12 @@ ULONG_IOCTL(TIOCSCTTY)
> >  COMPATIBLE_IOCTL(TIOCGPTN)
> >  COMPATIBLE_IOCTL(TIOCSPTLCK)
> >  COMPATIBLE_IOCTL(TIOCSERGETLSR)
> > +#ifdef TCGETS2
> > +COMPATIBLE_IOCTL(TCGETS2)
> > +COMPATIBLE_IOCTL(TCSETS2)
> > +COMPATIBLE_IOCTL(TCSETSW2)
> > +COMPATIBLE_IOCTL(TCSETSF2)
> > +#endif
> >  /* Little f */
> >  COMPATIBLE_IOCTL(FIOCLEX)
> >  COMPATIBLE_IOCTL(FIONCLEX)
> 
> Should this be in 2.6.24?

Can't hurt. At least it passed Alan's test suite  on s390 (32 bit, 64 bit
and compat mode).
