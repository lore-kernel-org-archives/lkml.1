Return-Path: <linux-kernel-owner+w=401wt.eu-S965886AbXCVIyA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965886AbXCVIyA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 04:54:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965888AbXCVIyA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 04:54:00 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:34039 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965886AbXCVIx7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 04:53:59 -0400
Date: Thu, 22 Mar 2007 09:54:29 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Kees Cook <kees@outflux.net>, Randy Dunlap <randy.dunlap@oracle.com>,
       linux-kernel@vger.kernel.org, David Woodhouse <dwmw2@infradead.org>
Subject: Re: 2.6.21-rc4-mm1
Message-ID: <20070322085429.GA28500@uranus.ravnborg.org>
References: <20070319205623.299d0378.akpm@linux-foundation.org> <20070320103151.f65c81b6.randy.dunlap@oracle.com> <20070320192016.GC22797@outflux.net> <20070320214714.0e584cd4.akpm@linux-foundation.org> <20070321221905.GA22623@uranus.ravnborg.org> <20070321160111.b26be525.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070321160111.b26be525.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 21, 2007 at 04:01:11PM -0700, Andrew Morton wrote:
> On Wed, 21 Mar 2007 23:19:05 +0100
> Sam Ravnborg <sam@ravnborg.org> wrote:
> 
> > On Tue, Mar 20, 2007 at 09:47:14PM -0800, Andrew Morton wrote:
> > > On Tue, 20 Mar 2007 12:20:16 -0700 Kees Cook <kees@outflux.net> wrote:
> > > 
> > > > I can't 
> > > > get 2.6.21-rc4-mm1 to compile (with or without this fix):
> > > > 
> > > >   GEN     .version
> > > > init/.missing_syscalls.h.cmd:2: *** missing separator.  Stop.
> > > > make: *** [.tmp_vmlinux1] Error 2
> > > 
> > > How'd you manage that?
> > > 
> > > Sam, I think this is a you-thing rather than a dwmw2-thing?
> > Took a look. Things looked pretty OK but an updated patch
> > applied to kbuild.git.
> > Corrected a few things in the Makefile and combined the
> > patch from dwmw2 and Stephane.
> > 
> > kbuild.git pused out and patches follows.
> >
> 
> David has set up a git tree with this stuff, so you presumably
> have an out-of-date copy.
> 
> git://git.infradead.org/~dwmw2/syscalls-2.6.git
> 
> I don't know what's changed in there.  One never does, with git
> trees :(
I pulled that one and last patch in my serie was from that tree.

	Sam
