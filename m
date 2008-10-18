Return-Path: <linux-kernel-owner+w=401wt.eu-S1752036AbYJRONZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752036AbYJRONZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Oct 2008 10:13:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750910AbYJRONR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Oct 2008 10:13:17 -0400
Received: from 1wt.eu ([62.212.114.60]:4831 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750819AbYJRONQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Oct 2008 10:13:16 -0400
Date: Sat, 18 Oct 2008 16:13:03 +0200
From: Willy Tarreau <w@1wt.eu>
To: Adrian Bunk <bunk@kernel.org>
Cc: Greg KH <greg@kroah.com>, Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC] Kernel version numbering scheme change
Message-ID: <20081018141303.GA28393@1wt.eu>
References: <20081017034717.GA28188@kroah.com> <20081017064751.GE22554@cs181140183.pp.htv.fi> <20081017075544.GB4850@kroah.com> <20081017085604.GA20986@cs181140183.pp.htv.fi> <20081018090117.GR24654@1wt.eu> <20081018100401.GA6535@cs181140183.pp.htv.fi> <20081018110826.GA25503@1wt.eu> <20081018115038.GB6535@cs181140183.pp.htv.fi> <20081018122851.GB25503@1wt.eu> <20081018134832.GC6535@cs181140183.pp.htv.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081018134832.GC6535@cs181140183.pp.htv.fi>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 18, 2008 at 04:48:33PM +0300, Adrian Bunk wrote:
> 10 years ago someone wrote his own version of config.guess, and assumed 
> kernel developers would always use sane versions.

And versions are not sane anymore. 1.0, 1.2, 2.0, 2.2 and 2.4 were branches
where the 3rd digit indicated a patch level or a minor feature enhancement.
Yes there were exceptions to that. 2.2.18 brought USB. 2.4.10 changed the
VM, the list can be extended. But the principle was that $MAJOR.$MINOR
could be relied on. It's not the case anymore. You have to check 3 numbers
now if you want to check for some specific feature. I think that only /sys
existence and the module loading method are constants across all 2.6.

Getting back to something like $MAJOR.$MINOR would not change the original
checks. New versions would have to be updated once in a while if needed,
just like we'd have to if 2.6.29 brought a great change.

I'm clearly not for anything depending on the date. But having 3.0 instead
of 2.6.30, then 3.1, 3.2, ... would have no reason to break a model which
has worked well for the last 15 years.

> A "just for fun" change of the version number will break existing 
> programs, and that will cause various problems for various people.

It's not "just for fun". You know I'm often more reluctant to changing than
you are. But as Linus already pointed it out, numbers are becoming completely
meaningless and it's a pain to enumerate them. You and I are both playing
with 4-digit versions once in a while. Greg releases two such versions at
once far more often than any of us. This versionning is already confusing.
It's certainly not for fun that Greg brought that subject back.

> > Quite cool stuff, but I'm really not interested. Having been beat by
> > a number of packages which try to run target environment commands
> > during the build when not set for cross-compile, I'd expect pretty
> > random results.
> 
> The build system of the package thinks it gets compiled natively - that 
> avoids exactly the problems you describe.

Well, the way you describe it with all the magics ("thinks", "transparent",
...) is precisely what incites me to stay away from that. Autoconf is also
made to make things more transparent, and what a mess... But I know you're
attached to clean and reliable things, so I'll take a look at it to get my
own opinion on the solution (not right now though).

Willy

