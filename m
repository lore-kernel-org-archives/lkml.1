Return-Path: <linux-kernel-owner+w=401wt.eu-S933001AbXA2Wkb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933001AbXA2Wkb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 17:40:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933029AbXA2Wkb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 17:40:31 -0500
Received: from baghira.han.de ([62.48.90.2]:2556 "EHLO baghira.han.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933001AbXA2Wka (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 17:40:30 -0500
X-Greylist: delayed 1375 seconds by postgrey-1.27 at vger.kernel.org; Mon, 29 Jan 2007 17:40:30 EST
Date: Mon, 29 Jan 2007 23:17:03 +0100
From: Joerg Ahrens <joerg@hydrops.han.de>
To: Andi Kleen <ak@suse.de>
Cc: Andrew Morton <akpm@osdl.org>, Parag Warudkar <parag.warudkar@gmail.com>,
       dsd@gentoo.org, linux-kernel@vger.kernel.org
Subject: Re: [Bugme-new] [Bug 7891] New: vdso page is no longer mapped for
Message-ID: <20070129221703.GA6786@hydrops.han.de>
References: <82e4877d0701271201n3aa5bdf6v7c5fb8e41ee98c80@mail.gmail.com> <20070127140233.203ef7d3.akpm@osdl.org> <200701290410.29427.ak@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200701290410.29427.ak@suse.de>
User-Agent: Mutt/1.3.27i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 29, 2007 at 04:10:29AM +0100, Andi Kleen wrote:
> On Saturday 27 January 2007 23:02, Andrew Morton wrote:
> > On Sat, 27 Jan 2007 15:01:51 -0500
> >
> > "Parag Warudkar" <parag.warudkar@gmail.com> wrote:
> > > Here is a patch that does what Andrew Morton suggested (plus some more
> > > as explained below) .
> > > Patch inline below and also attached in case there is whitespace
> > > damage. Compile tested on i386 with make defconfig; make. If anyone
> > > can test on other arches and provide feedback that'd be great.
> >
> > Thanks - I can test elf on powerpc.  Does anyone remember how to
> > create a.out executables?
> 
> You need an old toolkit, but the historic section of ftp.funet.fi
> has a few binaries. I also got a tarball of an old a.out SUSE
> installation somewhere that I can dig out if there is interest.
> 

On http://jpmarat.de/dl/sigtest.tar.bz2 you will find a small test prog
(source and a.out static).

On http://jpmarat.de/dl/gcc27jail.tar.bz2 you will find a gcc 2.7.2 jail 
with toolchain extracted from an old SuSE installation (20M compressed
90M unpacked).
