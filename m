Return-Path: <linux-kernel-owner+w=401wt.eu-S1754091AbZGTUbJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754091AbZGTUbJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 16:31:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753521AbZGTUbI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 16:31:08 -0400
Received: from smtp-115-monday.nerim.net ([62.4.16.115]:59180 "EHLO
	maiev.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753266AbZGTUbH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 16:31:07 -0400
X-Greylist: delayed 8853 seconds by postgrey-1.27 at vger.kernel.org; Mon, 20 Jul 2009 16:31:07 EDT
Date: Mon, 20 Jul 2009 22:31:03 +0200
From: Damien Wyart <damien.wyart@free.fr>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Greg KH <gregkh@suse.de>, Wolfgang Walter <wolfgang.walter@stwm.de>,
       linux-kernel@vger.kernel.org
Subject: Re: Linux 2.6.30.2: does not boot
Message-ID: <20090720203103.GA3022@brouette>
References: <20090720040813.GC11940@kroah.com>
 <200907201613.22483.wolfgang.walter@stwm.de>
 <20090720150916.GB10015@suse.de>
 <20090720180333.GA2905@brouette>
 <alpine.LFD.2.01.0907201110390.13838@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.01.0907201110390.13838@localhost.localdomain>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > I am seeing a similar problem (no hang but an immediate reboot) on the
> > same distro. I tried to bisect but got no good kernel in the end.

> > To clarify things I recompiled again 2.6.30.1 with the orginial .config
> > and it also failed to boot (I was happy to have renamed it so the
> > working kernel was still available). I suspected a recent gcc 4.3
> > upgrade so downgraded gcc, but no luck, still getting the same problem.
> > So for now I am quite stuck, but there is clearly a bad problem
> > somewhere...

* Linus Torvalds <torvalds@linux-foundation.org> [2009-07-20 11:16]:
> Hmm. So you _had_ a working self-compiled 2.6.30 kernel at some point?

Yes, my case is very similar to the one described by Kiko Piris, and
I also think this is getting off topic.

> One thing to look out for is that a compiler upgrade/downgrade will be
> invisible to the kernel build system, so if you downgrade the compiler
> and recompile, you may not actually recompile things at all.

I tried the bisect with the same compiler and then for other tests
I recompiled from scratch each time on a tmpfs to make sure I was not
messing things up. On this machine, ccache is not used.

So I am suspecting a recent glibc or binutils upgrade (gcc downgrade did
not solve the problem) and even if some people noticed problems with
2.6.30.2, my issue seems different and only distro-related.

-- 
Damien Wyart
