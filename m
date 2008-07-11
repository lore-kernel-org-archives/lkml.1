Return-Path: <linux-kernel-owner+w=401wt.eu-S1758943AbYGKPIn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758943AbYGKPIn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 11:08:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752819AbYGKPIe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 11:08:34 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:59022 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751031AbYGKPId convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 11:08:33 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: today's linux-next fails to boot
Date: Fri, 11 Jul 2008 17:10:41 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Ingo Molnar <mingo@elte.hu>,
       =?iso-8859-1?q?T=F6r=F6k_Edwin?= <edwintorok@gmail.com>,
       Takashi Iwai <tiwai@suse.de>, linux-next@vger.kernel.org,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Vegard Nossum <vegard.nossum@gmail.com>
References: <4877400B.1000400@gmail.com> <487772B6.4090100@gmail.com> <20080711145322.GA25698@elte.hu>
In-Reply-To: <20080711145322.GA25698@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200807111710.42826.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, 11 of July 2008, Ingo Molnar wrote:
> 
> * Török Edwin <edwintorok@gmail.com> wrote:
> 
> > On 2008-07-11 16:59, Ingo Molnar wrote:
> > > * Török Edwin <edwintorok@gmail.com> wrote:
> > >
> > >   
> > >>> [Added Ingo to Cc]
> > >>>
> > >>> I get the boot problem on i386 with 2008-07-11 linux-next tree, too.
> > >>> In my case, no error appears on the screen, just staying blank and
> > >>> dead.  It seems stopping at the very beginning, soon after GRUB, so
> > >>> could be the same reason.
> > >>>   
> > >>>       
> > >> I don't see any boot messages on the screen, I get that BUG message as
> > >> soon as grub's menu dissapears.
> > >> I have bisected it to this range so far:
> > >> git-bisect good aa03060a78c1aec53075a0c8ca7be19cedfbea8f
> > >> git-bisect bad b1611c0058bc6635e7257e755c3f194933a7a6df
> > >>
> > >> Should I continue to bisect?
> > >>     
> > >
> > > could you check latest tip/master, does it boot fine with the same 
> > > config?
> > 
> > tip/master boots fine.
> 
> to update linux-next to the latest bits in -tip, you can perhaps do 
> something like this:
> 
>  git-merge tip/auto-x86-next
>  git-merge tip/auto-core-next
>  git-merge tip/auto-cpus4096-next
>  git-merge tip/auto-ftrace-next
>  git-merge tip/auto-generic-ipi-next
>  git-merge tip/auto-genirq-next
>  git-merge tip/auto-latest
>  git-merge tip/auto-safe-poison-pointers-next
>  git-merge tip/auto-sched-next
>  git-merge tip/auto-stackprotector-next
>  git-merge tip/auto-timers-next
> 
> but it's easily possible that the bug is in some other portion of 
> linux-next.

Hm, I haven't tested the linux-next from today myself yet, but I have a related
question.  Namely, is there a way to get a log of commits that have been
added since the previous linux-next?

That may help to find a guilty patch if the yesterday's linux-next works.

Thanks,
Rafael
