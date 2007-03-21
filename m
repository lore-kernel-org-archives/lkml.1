Return-Path: <linux-kernel-owner+w=401wt.eu-S1753083AbXCUXBk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753083AbXCUXBk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 19:01:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753086AbXCUXBk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 19:01:40 -0400
Received: from smtp.osdl.org ([65.172.181.24]:57886 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753066AbXCUXBj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 19:01:39 -0400
Date: Wed, 21 Mar 2007 16:01:11 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Kees Cook <kees@outflux.net>, Randy Dunlap <randy.dunlap@oracle.com>,
       linux-kernel@vger.kernel.org, David Woodhouse <dwmw2@infradead.org>
Subject: Re: 2.6.21-rc4-mm1
Message-Id: <20070321160111.b26be525.akpm@linux-foundation.org>
In-Reply-To: <20070321221905.GA22623@uranus.ravnborg.org>
References: <20070319205623.299d0378.akpm@linux-foundation.org>
	<20070320103151.f65c81b6.randy.dunlap@oracle.com>
	<20070320192016.GC22797@outflux.net>
	<20070320214714.0e584cd4.akpm@linux-foundation.org>
	<20070321221905.GA22623@uranus.ravnborg.org>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Mar 2007 23:19:05 +0100
Sam Ravnborg <sam@ravnborg.org> wrote:

> On Tue, Mar 20, 2007 at 09:47:14PM -0800, Andrew Morton wrote:
> > On Tue, 20 Mar 2007 12:20:16 -0700 Kees Cook <kees@outflux.net> wrote:
> > 
> > > I can't 
> > > get 2.6.21-rc4-mm1 to compile (with or without this fix):
> > > 
> > >   GEN     .version
> > > init/.missing_syscalls.h.cmd:2: *** missing separator.  Stop.
> > > make: *** [.tmp_vmlinux1] Error 2
> > 
> > How'd you manage that?
> > 
> > Sam, I think this is a you-thing rather than a dwmw2-thing?
> Took a look. Things looked pretty OK but an updated patch
> applied to kbuild.git.
> Corrected a few things in the Makefile and combined the
> patch from dwmw2 and Stephane.
> 
> kbuild.git pused out and patches follows.
>

David has set up a git tree with this stuff, so you presumably
have an out-of-date copy.

git://git.infradead.org/~dwmw2/syscalls-2.6.git

I don't know what's changed in there.  One never does, with git
trees :(
