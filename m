Return-Path: <linux-kernel-owner+w=401wt.eu-S1758150AbYDBTGO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758150AbYDBTGO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 15:06:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755741AbYDBTF7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 15:05:59 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:56759 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755088AbYDBTF6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 15:05:58 -0400
Date: Wed, 2 Apr 2008 21:06:23 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Christoph Lameter <clameter@sgi.com>, Ralf Baechle <ralf@linux-mips.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, dmitri.vorobiev@gmail.com,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.25-rc8-mm1 (mips build failure)
Message-ID: <20080402190623.GA23651@uranus.ravnborg.org>
References: <20080401213214.8fbb6d6b.akpm@linux-foundation.org> <47F31C46.9000503@gmail.com> <20080401230322.331c50f4.akpm@linux-foundation.org> <Pine.LNX.4.64.0804021031480.26938@schroedinger.engr.sgi.com> <20080402112907.76e1c554.akpm@linux-foundation.org> <Pine.LNX.4.64.0804021130040.28113@schroedinger.engr.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0804021130040.28113@schroedinger.engr.sgi.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 02, 2008 at 11:33:42AM -0700, Christoph Lameter wrote:
> On Wed, 2 Apr 2008, Andrew Morton wrote:
> 
> > i386 generates
> > 
> > ->NR_PAGEFLAGS $18 __NR_PAGEFLAGS       #
> 
> > mips generates
> > 
> > ->NR_PAGEFLAGS 18 __NR_PAGEFLAGS         #
> 
> For some reason the asm-offset.c for mips generates it differently and the 
> sed expression in kbuild is different. So it does not match.

When the asm-offset stuff were consolidated the mips variant
did not match the others.
I do not recall if I ever tried this on a mips tool-chain and as
my dev box is busted atm I cannot even test it out now.

I would be happy if we could kill the MIPS specific sed expression
in the top-level Kbuild file.

Ralf - can you take a look at this and see if mips really generates
different assembler syntax which warrants the different sed expression.

If mips really needs a different sed expression then we should adjust
it so the output is similar to the other archs.

	Sam
