Return-Path: <linux-kernel-owner+w=401wt.eu-S1757873AbZABLnJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757873AbZABLnJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 06:43:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756840AbZABLmz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 06:42:55 -0500
Received: from pfepb.post.tele.dk ([195.41.46.236]:56889 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755803AbZABLmy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 06:42:54 -0500
Date: Fri, 2 Jan 2009 12:44:30 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Rob Landley <rob@landley.net>
Cc: Alejandro Mery <amery@opensde.org>, Christoph Hellwig <hch@infradead.org>,
       Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>,
       linux-kernel@vger.kernel.org,
       Embedded Linux mailing list <linux-embedded@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: PATCH [0/3]: Simplify the kernel build by removing perl.
Message-ID: <20090102114430.GA4883@uranus.ravnborg.org>
References: <200901020207.30359.rob@landley.net> <20090102094934.GB17841@infradead.org> <495DE995.1070002@opensde.org> <200901020515.33703.rob@landley.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200901020515.33703.rob@landley.net>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 02, 2009 at 05:15:32AM -0600, Rob Landley wrote:
> On Friday 02 January 2009 04:16:53 Alejandro Mery wrote:
> > Christoph Hellwig escribió:
> > > On Fri, Jan 02, 2009 at 10:26:37AM +0100, Arkadiusz Miskiewicz wrote:
> > >> On Friday 02 of January 2009, Rob Landley wrote:
> > >>> Before 2.6.25 (specifically git
> > >>> bdc807871d58285737d50dc6163d0feb72cb0dc2 ) building a Linux kernel
> > >>> never required perl to be installed on the build system.  (Various
> > >>> development and debugging scripts were written in perl and python and
> > >>> such, but they weren't involved in actually building a kernel.)
> > >>> Building a kernel before 2.6.25 could be done with a minimal system
> > >>> built from gcc, binutils, bash, make, busybox, uClibc, and the Linux
> > >>> kernel, and nothing else.
> > >>
> > >> And now bash is going to be required... while some distros don't
> > >> need/have bash. /bin/sh should be enough.
> > >
> > > *nod*  bash is in many ways a worse requirement than perl.  strict posix
> > > /bin/sh + awk + sed would be nicest, but if that's too much work perl
> > > seems reasonable.
> >
> > well, bash is not worse as bash is trivial to cross-compile to run on a
> > constrained sandbox and perl is a nightmare, but I agree bash should be
> > avoided too.
> >
> > I think the $(( ... )) bash-ism can be replaced with a simple .c helper
> > toy.
> 
> No, $[ ] is the bashism, $(( )) is susv3:
> http://www.opengroup.org/onlinepubs/9699919799/utilities/V3_chap02.html#tag_18_06_04
> 
> I intentionally switched from $[ ] to $(( )) to make dash work.
The focus on this patch is to create a minimal set of
dependencies so please document what dependencies / compatibility
this patch introduces.

It is not obvious for me for example if the script
requires sh, bash or dash or whatever.

The shebang is so often wrong that this is not docuemnting such
things.

	Sam
