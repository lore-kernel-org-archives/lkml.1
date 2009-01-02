Return-Path: <linux-kernel-owner+w=401wt.eu-S932518AbZABWwh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932518AbZABWwh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 17:52:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753501AbZABWw2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 17:52:28 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:50190 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753307AbZABWw2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 17:52:28 -0500
Date: Fri, 2 Jan 2009 22:52:03 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Andi Kleen <andi@firstfloor.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Sam Ravnborg <sam@ravnborg.org>, Ingo Molnar <mingo@elte.hu>,
       David Miller <davem@davemloft.net>,
       Andrew Morton <akpm@linux-foundation.org>, rdreier@cisco.com,
       ian.campbell@citrix.com, jeremy.fitzhardinge@citrix.com, deller@gmx.de,
       rusty@rustcorp.com.au, linux-parisc@vger.kernel.org,
       linux-kernel@vger.kernel.org, kyle@mcmartin.ca, randolph@tausq.org,
       dave@hiauly1.hia.nrc.ca
Subject: Re: [PATCH] kbuild: Disallow GCC 4.1.0 / 4.1.1
Message-ID: <20090102225203.GK28946@ZenIV.linux.org.uk>
References: <20081231105425.9ccac21d.akpm@linux-foundation.org> <alpine.LFD.2.00.0812311318420.5086@localhost.localdomain> <20081231.141408.60544902.davem@davemloft.net> <20090102115547.GB3027@elte.hu> <alpine.LFD.2.00.0901020844070.5086@localhost.localdomain> <alpine.LFD.2.00.0901020933370.5086@localhost.localdomain> <20090102175737.GA5818@uranus.ravnborg.org> <alpine.LFD.2.00.0901021000020.5086@localhost.localdomain> <20090102185148.GI28946@ZenIV.linux.org.uk> <87mye9jz9p.fsf@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87mye9jz9p.fsf@basil.nowhere.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 02, 2009 at 08:14:58PM +0100, Andi Kleen wrote:
> Al Viro <viro@ZenIV.linux.org.uk> writes:
> >
> > FWIW, I'm using 4.3 on all targets at the moment.  See
> > git://git.kernel.org/pub/scm/linux/kernel/git/viro/toolchain.git/
> > for fedora-based variant of that sucker.  And yes, it does include
> > cross-to-sparc; all but sh/sh64, in fact (sh had serious compiler
> > breakage around 4.3.0 and backporting from -HEAD was far beyond
> > what I considered reasonable at that point).
> 
> The full opensuse distribution also has a couple of spec files for
> generating cross compilers from recent versions. These are for
> icecream, but can be relatively easily adapted (or the binaries
> reused)
> 
> In general I don't think building cross compilers is as hard
> as it used to be, so it can be reasonably done without any support
> scripts too.

*snort*

Well, the only support script here is "call rpmbuild with the right
arguments" (and kmk, which is about running kernel cross-build
conveniently and has nothing to do with building cross-toolchain
itself).

I'll need to update that to more current gcc anyway (and see if that
takes care of sh/sh64), so if you can dig those .spec out... throw
them my way and I'll add them to repository.

How well do they handle the targets for which you have no glibc-dev
binary rpms, BTW?  I needed headers for ia64 and ppc64; both fortunately
are among the generally supported targets...
