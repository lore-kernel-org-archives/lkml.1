Return-Path: <linux-kernel-owner+w=401wt.eu-S1758168AbXI2RPI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758168AbXI2RPI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Sep 2007 13:15:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756237AbXI2RO5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Sep 2007 13:14:57 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:56935 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756182AbXI2RO4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Sep 2007 13:14:56 -0400
Date: Sat, 29 Sep 2007 19:16:24 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Florian Schmidt <mista.tapas@gmx.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: getting FUSD compiled with current kernels
Message-ID: <20070929171624.GA19429@uranus.ravnborg.org>
References: <200709291823.35868.mista.tapas@gmx.net> <200709291835.15489.mista.tapas@gmx.net> <200709291837.51976.mista.tapas@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200709291837.51976.mista.tapas@gmx.net>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 29, 2007 at 06:37:51PM +0200, Florian Schmidt wrote:
> On Saturday 29 September 2007, Florian Schmidt wrote:
> > On Saturday 29 September 2007, Florian Schmidt wrote:
> > > Hi,
> > >
> > > I'm trying to build FUSD [1] against current kernels [2.6.22]. I get
> > > errors [2]:
> >
> > Oh i forgot to show the code snippets in question. I put them to the
> 
> Oh and i also forget to mention that i get the same errors when using:
> 
> KDIR=/usr/src/linux-source-2.6.22/ make
> 
> [Where the ubuntu kernel package put the source. I configured it with the 
> default ubuntu .config and make oldconfig]. I get one more message though:
> 
> ~/source/build_stuff/fusd/kfusd$ KDIR=/usr/src/linux-source-2.6.22/ make
> make -C /usr/src/linux-source-2.6.22/ 
> SUBDIRS=/home/tapas/source/build_stuff/fusd/kfusd 
> EXTRA_CFLAGS=-I/home/tapas/source/build_stuff/fusd/kfusd/../include modules
> make[1]: Entering directory `/usr/src/linux-source-2.6.22'
> 
>   WARNING: Symbol version dump /usr/src/linux-source-2.6.22/Module.symvers
>            is missing; modules will have no dependencies and modversions.

This is because you build using a kernel with a non-complete build.
Maybe ubuntu locate output files somewhere else?

If thats the case use:
export KBUILD_OUTPUT=dir
make

to tell kbuild where to find the output files for the kernel source.

	Sam
