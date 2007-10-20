Return-Path: <linux-kernel-owner+w=401wt.eu-S1764121AbXJTRkY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764121AbXJTRkY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Oct 2007 13:40:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756829AbXJTRkM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Oct 2007 13:40:12 -0400
Received: from www.tglx.de ([62.245.132.106]:45971 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756564AbXJTRkL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Oct 2007 13:40:11 -0400
Date: Sat, 20 Oct 2007 19:39:14 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Sam Ravnborg <sam@ravnborg.org>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Yinghai Lu <yhlu.kernel@gmail.com>, Andi Kleen <ak@suse.de>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: git/cscope with x86 merge
In-Reply-To: <20071020164752.GB6855@uranus.ravnborg.org>
Message-ID: <alpine.LFD.0.9999.0710201932470.22770@localhost.localdomain>
References: <86802c440710151245s7d12a45fpfdaa041546d965e@mail.gmail.com> <alpine.LFD.0.999.0710151256260.6887@woody.linux-foundation.org> <86802c440710200240o7aae2760o5fa9c70e3b327097@mail.gmail.com> <alpine.LFD.0.999.0710200854550.3794@woody.linux-foundation.org>
 <20071020164752.GB6855@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 20 Oct 2007, Sam Ravnborg wrote:
> On Sat, Oct 20, 2007 at 08:56:18AM -0700, Linus Torvalds wrote:
> > so it definitely works for me.
> 
> But you do not see the rename arch/x86_64/kernel/{vmlinux.lds.S => vmlinux.lds.S}
> And this is I thing the important step here.
> 
> For vmlinux.lds.S we have two renames.
> First the vmlinux.lds.S => vmlinux_64.lds.S
> But this may be a copy instead of a rename thus preventing us
> to see the old history of vmlinux.lds.S?

Yes, it's a copy. vmlinux.lds.S is one of the few source files, which
needed a stub, which includes the 32/64 bit one to avoid a complete
mess in tons of Kbuild/Makefiles.

     tglx
