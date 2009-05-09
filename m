Return-Path: <linux-kernel-owner+w=401wt.eu-S1753610AbZEIJNX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753610AbZEIJNX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 May 2009 05:13:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751171AbZEIJNP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 May 2009 05:13:15 -0400
Received: from thunk.org ([69.25.196.29]:34798 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751024AbZEIJNO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 May 2009 05:13:14 -0400
Date: Sat, 9 May 2009 05:13:08 -0400
From: Theodore Tso <tytso@mit.edu>
To: Grozdan <neutrino8@gmail.com>
Cc: Jeff Garzik <jeff@garzik.org>, linux-kernel@vger.kernel.org
Subject: Re: Linux and LLVM
Message-ID: <20090509091308.GE15054@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Grozdan <neutrino8@gmail.com>, Jeff Garzik <jeff@garzik.org>,
	linux-kernel@vger.kernel.org
References: <c5bd819b0905081228m4ee6472bhc3968b178f038b9c@mail.gmail.com> <4A048AF4.1080205@garzik.org> <c5bd819b0905081250k2095beb6r1aae22fcd82ac468@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c5bd819b0905081250k2095beb6r1aae22fcd82ac468@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 08, 2009 at 09:50:04PM +0200, Grozdan wrote:
> 2009/5/8 Jeff Garzik <jeff@garzik.org>:
> > Grozdan wrote:
> >>
> > It is highly unlikely we will switch compilers away from gcc -- we have
> > enough problems just supporting multiple gcc versions.
> >
> > That said, you could join the effort to get LLVM to compile under the
> > kernel.  Here is a meta-bug for that:
> > http://llvm.org/bugs/show_bug.cgi?id=4068
> >
> > It is a moot question until LLVM can actually build a bootable kernel :)
> 
> Thanks for the quick answer! I was not aware that currently there's
> lots of work until CLANG can compile a bootable Linux kernel. Thanks
> for the link too. I'll dig through it

Note also that the list of architectures currently supported by Linux:

http://en.wikipedia.org/wiki/Linux_kernel_portability_and_supported_architectures

Seems to be a superset of the architectures supported by LLVM, and the
CLANG web page states that it is production quality only on the x86
and x86_64 architectures.  So "switch away from" seems to be a rather
ambitious goal.  

As Jeff has suggested, getting CLANG to at least be able to compile a
single Linux kernel, on one architecture is clearly the first step.

The next step will be to work on fixing regressions on a wide variety
of different kernel configurations such that in people's mind, that
when a kernel bug is submitted, the probability that it is a compiler
bug must be roughly the same as in GCC --- in other words, that for
any give bug report submitted, P(LLVM/CLANG compiler bug) must be less
than P(GCC compiler bug).  At that point, assuming there is a large
enough community of users who prefer to use LLVM/CLANG (presumably
because its code generator is proving itself superior to gcc), it
would be possible to call LLVM/CLANG "supported" under Linux.

I suspect we have quite a ways to go before we get to that point, and
even then there is the issue of the architectures which aren't yet
supported by LLVM.

Regards,

					- Ted
