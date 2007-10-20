Return-Path: <linux-kernel-owner+w=401wt.eu-S1751668AbXJUCYw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751668AbXJUCYw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Oct 2007 22:24:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750971AbXJUCYp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Oct 2007 22:24:45 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:59369 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750817AbXJUCYp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Oct 2007 22:24:45 -0400
Date: Sat, 20 Oct 2007 22:10:22 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>, Andi Kleen <ak@suse.de>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: git/cscope with x86 merge
Message-ID: <20071020201022.GA9134@uranus.ravnborg.org>
References: <86802c440710151245s7d12a45fpfdaa041546d965e@mail.gmail.com> <alpine.LFD.0.999.0710151256260.6887@woody.linux-foundation.org> <86802c440710200240o7aae2760o5fa9c70e3b327097@mail.gmail.com> <alpine.LFD.0.999.0710200854550.3794@woody.linux-foundation.org> <20071020164752.GB6855@uranus.ravnborg.org> <alpine.LFD.0.999.0710201058300.3794@woody.linux-foundation.org> <alpine.LFD.0.999.0710201140550.3794@woody.linux-foundation.org> <20071020191534.GA8774@uranus.ravnborg.org> <alpine.LFD.0.999.0710201232100.10525@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.999.0710201232100.10525@woody.linux-foundation.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 20, 2007 at 12:36:17PM -0700, Linus Torvalds wrote:
> 
> 
> On Sat, 20 Oct 2007, Sam Ravnborg wrote:
> > 
> > I pulled next branch of git and applied your patch.
> > 
> > When running
> >  	git log --follow -B arch/x86/kernel/vmlinux_64.lds.S
> > 
> > I got no output at all (in a newly pulled linux kernel dir).
> 
> Try with "-p".
> 
> It's possible (nay, likely) that "next" has the bug where "--follow" 
> without a patch generating thing (-p or --stat or one of the other flags 
> that enable diffs) doesn't work at all.

Yep - that did the trick, thanks.

	Sam
