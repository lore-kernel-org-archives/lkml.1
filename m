Return-Path: <linux-kernel-owner+w=401wt.eu-S1753656AbZDTEn4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753656AbZDTEn4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 00:43:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753746AbZDTEnp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 00:43:45 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:46196 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751698AbZDTEno (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 00:43:44 -0400
Date: Mon, 20 Apr 2009 06:45:51 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Paul Mundt <lethal@linux-sh.org>,
       linux-kbuild <linux-kbuild@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Russell King <rmk+lkml@arm.linux.org.uk>,
       Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [GIT] kbuild
Message-ID: <20090420044551.GB8494@uranus.ravnborg.org>
References: <20090419092555.GA19213@uranus.ravnborg.org> <20090419223959.GB12054@linux-sh.org> <20090419234501.GA6475@uranus.ravnborg.org> <alpine.LFD.2.00.0904191745390.2199@localhost.localdomain> <20090420014158.GV26366@ZenIV.linux.org.uk> <20090420024954.GW26366@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090420024954.GW26366@ZenIV.linux.org.uk>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 20, 2009 at 03:49:54AM +0100, Al Viro wrote:
> On Mon, Apr 20, 2009 at 02:41:58AM +0100, Al Viro wrote:
> > On Sun, Apr 19, 2009 at 05:52:32PM -0700, Linus Torvalds wrote:
> > > 
> > > 
> > > On Mon, 20 Apr 2009, Sam Ravnborg wrote:
> > > > 
> > > > You will soon see a path from me where I fix sh too.
> > > 
> > > Can we do a global 'sed s:asm/asm-offsets.h:generated/asm-offsets.h:g' 
> > > thing too? And then get rid of the include/asm symlink?
> > > 
> > > That asm-offsets.h mess is scary. I don't quite know why kvm on ia64 seems 
> > > to do it's own asm-offsets.h file, for example. And arch/blackfin/Makefile 
> > > mentions arch/$(ARCH)/include/asm/asm-offsets.h (but does it actually do 
> > > one?).
> > 
> > We'll need to update uml as well (contents of shared/kern_constants.h)
> 
> BTW, while we are at it...  There's a way to deal with arch/um without
> that kind of contortions, provided that we are willing to use -idirafter.
For kernel proper the use of -idirafter would be confusing.
But for um alone we should be safe provided it is properly commented.

I have already fixed um the obvious way for asm-offsets in my local tree.
But if you prefer I can add a -dirafter based patch before the "move
asm-offsets.h to incldue/generated" patch.

	Sam
