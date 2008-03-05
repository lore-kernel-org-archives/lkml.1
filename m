Return-Path: <linux-kernel-owner+w=401wt.eu-S1763432AbYCEWN3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763432AbYCEWN3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 17:13:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762813AbYCEWNK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 17:13:10 -0500
Received: from smtp5.pp.htv.fi ([213.243.153.39]:36417 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762783AbYCEWNI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 17:13:08 -0500
Date: Thu, 6 Mar 2008 00:13:04 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Michael Matz <matz@suse.de>
Cc: Chris Lattner <clattner@apple.com>, "H.Peter Anvin" <hpa@zytor.com>,
       Richard Guenther <richard.guenther@gmail.com>,
       Joe Buck <Joe.Buck@synopsys.com>, Jan Hubicka <hubicka@ucw.cz>,
       Aurelien Jarno <aurelien@aurel32.net>, linux-kernel@vger.kernel.org,
       gcc@gcc.gnu.org
Subject: Re: RELEASE BLOCKER: Linux doesn't follow x86/x86-64 ABI wrt
	direction flag
Message-ID: <20080305221303.GA937@cs181133002.pp.htv.fi>
References: <20080305202319.GA17053@volta.aurel32.net> <Pine.LNX.4.64.0803052133400.20583@wotan.suse.de> <20080305204234.GB17267@synopsys.com> <20080305204945.GB14011@atrey.karlin.mff.cuni.cz> <Pine.LNX.4.64.0803052158270.20583@wotan.suse.de> <20080305212005.GC17267@synopsys.com> <84fc9c000803051332q2f2eedeej7d3c0509e698cabf@mail.gmail.com> <47CF11D6.7070901@zytor.com> <738B72DB-A1D6-43F8-813A-E49688D05771@apple.com> <Pine.LNX.4.64.0803052258530.20583@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0803052258530.20583@wotan.suse.de>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 05, 2008 at 10:59:21PM +0100, Michael Matz wrote:
> Hi,
> 
> On Wed, 5 Mar 2008, Chris Lattner wrote:
> 
> > 
> > On Mar 5, 2008, at 1:34 PM, H. Peter Anvin wrote:
> > 
> > >Richard Guenther wrote:
> > > >We didn't yet run into this issue and build openSUSE with 4.3 since more
> > > >than
> > > >three month.
> > >
> > >Well, how often do you take a trap inside an overlapping memmove()?
> > 
> > How hard is it to change the kernel signal entry path from "pushf" to
> > "pushf;cld"?  Problem solved, no?
> 
> The problem is with old kernels, which by definition stay unfixed.

Compiling older kernels with new gcc versions has never been supported.

You are e.g. aware that for many 32bit architectures (including i386) 
and kernels up to and including 2.6.25-rc4 even the build fails with
gcc 4.3?

> Ciao,
> Michael.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

