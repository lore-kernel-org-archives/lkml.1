Return-Path: <linux-kernel-owner+w=401wt.eu-S1759365AbZABSw3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759365AbZABSw3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 13:52:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758463AbZABSwT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 13:52:19 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:56473 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758114AbZABSwS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 13:52:18 -0500
Date: Fri, 2 Jan 2009 18:51:48 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Sam Ravnborg <sam@ravnborg.org>, Ingo Molnar <mingo@elte.hu>,
       David Miller <davem@davemloft.net>,
       Andrew Morton <akpm@linux-foundation.org>, rdreier@cisco.com,
       ian.campbell@citrix.com, jeremy.fitzhardinge@citrix.com, deller@gmx.de,
       rusty@rustcorp.com.au, linux-parisc@vger.kernel.org,
       linux-kernel@vger.kernel.org, kyle@mcmartin.ca, randolph@tausq.org,
       dave@hiauly1.hia.nrc.ca
Subject: Re: [PATCH] kbuild: Disallow GCC 4.1.0 / 4.1.1
Message-ID: <20090102185148.GI28946@ZenIV.linux.org.uk>
References: <alpine.LFD.2.00.0812310942110.5086@localhost.localdomain> <20081231105425.9ccac21d.akpm@linux-foundation.org> <alpine.LFD.2.00.0812311318420.5086@localhost.localdomain> <20081231.141408.60544902.davem@davemloft.net> <20090102115547.GB3027@elte.hu> <alpine.LFD.2.00.0901020844070.5086@localhost.localdomain> <alpine.LFD.2.00.0901020933370.5086@localhost.localdomain> <20090102175737.GA5818@uranus.ravnborg.org> <alpine.LFD.2.00.0901021000020.5086@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0901021000020.5086@localhost.localdomain>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 02, 2009 at 10:04:27AM -0800, Linus Torvalds wrote:
> 
> 
> On Fri, 2 Jan 2009, Sam Ravnborg wrote:
> > 
> > Bugger....
> > Now I cannot do cross compile for: alpha, arm, m68k and sparc.
> > 
> > Not that I actually try to run these beasts but just being able
> > to do cross compile has served me well.
> 
> We _could_ make a "CONFIG_COMPILE_ONLY" check, but wouldn't it be even 
> nicer to make sure the cross-compiles are something that might actually be 
> expected to work?
> 
> I realize that cross-tools tend to lag a bit - the pressure to maintain 
> them tends to be much lower - but I was sure we had somebody who did a 
> reasonable cross-compiler toolchain. Is gcc-4.1 really the most modern 
> thing that is easily available?

FWIW, I'm using 4.3 on all targets at the moment.  See
git://git.kernel.org/pub/scm/linux/kernel/git/viro/toolchain.git/
for fedora-based variant of that sucker.  And yes, it does include
cross-to-sparc; all but sh/sh64, in fact (sh had serious compiler
breakage around 4.3.0 and backporting from -HEAD was far beyond
what I considered reasonable at that point).
