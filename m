Return-Path: <linux-kernel-owner+w=401wt.eu-S933825AbZDJKrW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933825AbZDJKrW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 06:47:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761485AbZDJKrK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 06:47:10 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:51709 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761072AbZDJKrJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 06:47:09 -0400
Date: Fri, 10 Apr 2009 12:49:13 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Alex Chiang <achiang@hp.com>,
       Robin Holt <holt@sgi.com>, linux-kernel <linux-kernel@vger.kernel.org>,
       linux-ia64@vger.kernel.org
Subject: Re: cross-compilers
Message-ID: <20090410104913.GA21483@uranus.ravnborg.org>
References: <20090408003921.GA5054@ldl.fc.hp.com> <20090408010331.GB10768@sgi.com> <20090408054612.GA6744@ldl.fc.hp.com> <20090407225457.86f8a458.akpm@linux-foundation.org> <20090409003308.GK16602@bilbo.ozlabs.org> <20090408174443.79e71503.akpm@linux-foundation.org> <20090409215207.GN16602@bilbo.ozlabs.org> <20090409234750.GE7921@lug-owl.de> <20090410101220.GF7921@lug-owl.de> <8bd0f97a0904100319kb16c81bs596341e016cc41a@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <8bd0f97a0904100319kb16c81bs596341e016cc41a@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 10, 2009 at 06:19:21AM -0400, Mike Frysinger wrote:
> On Fri, Apr 10, 2009 at 06:12, Jan-Benedict Glaw wrote:
> > On Fri, 2009-04-10 01:47:50 +0200, Jan-Benedict Glaw wrote:
> >> I've started a build-bot like script for binutils + GCC from CVS/GIT.
> >> If it builds through, I'll start uploading i686 hosted compilers
> >> later on today.
> >
> > So... I've now build trunk kernel-only cross-compilers (hosted on
> > i686) for these targets:
> >
> >        bfin-uclinux.tar.bz2
> 
> we already host up-to-date Blackfin compilers on the Blackfin website:
> http://blackfin.uclinux.org/gf/project/toolchain/frs/
> 
> and we build for a variety of platforms ... atm that is x86, x86_64,
> ia64, and ppc
> 
> we also provide for simple distro integration:
>  - Gentoo has ebuilds in-tree
>  - deb based distros can use "deb
> http://download.analog.com/27516/distros/debian stable main"
>  - rpms are available at the link above (fedora/suse/etc...)
>  - tarballs are available at the link above (everyone else)
> 
> not sure it can get much easier than that for installing the Blackfin
> toolchain ;)
It can...
I'm after a one-stop place where we can locate cross compilers
for all architectures that Linux supports so it is a much simpler
task to actaully try to build our changes for as many architectures
as we supports.

And please host them on kernel.org - preferably as an update
of Vegards pages.

	Sam
