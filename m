Return-Path: <linux-kernel-owner+w=401wt.eu-S1751025AbXJUBim@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751025AbXJUBim (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Oct 2007 21:38:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751603AbXJUBiG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Oct 2007 21:38:06 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45411 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750994AbXJUBiE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Oct 2007 21:38:04 -0400
Date: Sat, 20 Oct 2007 12:36:17 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Sam Ravnborg <sam@ravnborg.org>
cc: Yinghai Lu <yhlu.kernel@gmail.com>, Andi Kleen <ak@suse.de>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: git/cscope with x86 merge
In-Reply-To: <20071020191534.GA8774@uranus.ravnborg.org>
Message-ID: <alpine.LFD.0.999.0710201232100.10525@woody.linux-foundation.org>
References: <86802c440710151245s7d12a45fpfdaa041546d965e@mail.gmail.com>
 <alpine.LFD.0.999.0710151256260.6887@woody.linux-foundation.org>
 <86802c440710200240o7aae2760o5fa9c70e3b327097@mail.gmail.com>
 <alpine.LFD.0.999.0710200854550.3794@woody.linux-foundation.org>
 <20071020164752.GB6855@uranus.ravnborg.org>
 <alpine.LFD.0.999.0710201058300.3794@woody.linux-foundation.org>
 <alpine.LFD.0.999.0710201140550.3794@woody.linux-foundation.org>
 <20071020191534.GA8774@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 20 Oct 2007, Sam Ravnborg wrote:
> 
> I pulled next branch of git and applied your patch.
> 
> When running
>  	git log --follow -B arch/x86/kernel/vmlinux_64.lds.S
> 
> I got no output at all (in a newly pulled linux kernel dir).

Try with "-p".

It's possible (nay, likely) that "next" has the bug where "--follow" 
without a patch generating thing (-p or --stat or one of the other flags 
that enable diffs) doesn't work at all.

It should be fixed in "master".

Sadly, Junio has been away for personal reasons for two weeks, so we 
haven't had that known bug fixed in the regular git tree. Shawn Pearce 
maintains a repo with known fixes at "git://repo.or.cz/git/spearce.git" in 
the meantime.

			Linus
