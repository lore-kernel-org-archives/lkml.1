Return-Path: <linux-kernel-owner+w=401wt.eu-S1757167AbZAVW1q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757167AbZAVW1q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 17:27:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753421AbZAVW1f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 17:27:35 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:45774 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751103AbZAVW1e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 17:27:34 -0500
Date: Thu, 22 Jan 2009 23:26:48 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Greg KH <gregkh@suse.de>
Cc: Dave Jones <davej@redhat.com>, Geert Uytterhoeven <geert@linux-m68k.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       =?iso-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>,
       David Brown <lkml@davidb.org>, Phil Oester <kernel@linuxace.com>,
       Kay Sievers <kay.sievers@vrfy.org>,
       Phillip Lougher <phillip@lougher.demon.co.uk>,
       Christoph Hellwig <hch@infradead.org>, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [GIT PULL] Squashfs pull request for 2.6.29
Message-ID: <20090122222648.GC31487@elte.hu>
References: <20090109211937.GA14342@logfs.org> <20090110124335.GB30744@elte.hu> <20090110165033.GA23943@logfs.org> <20090110101235.7ca24c44.akpm@linux-foundation.org> <20090110221528.GA31774@elte.hu> <Pine.LNX.4.64.0901111022590.30201@anakin> <20090111153920.GC7401@elte.hu> <20090111163018.GA9300@suse.de> <20090122215041.GA29369@redhat.com> <20090122215817.GA27609@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090122215817.GA27609@suse.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Greg KH <gregkh@suse.de> wrote:

> > I don't mean to piss on your parade, but from my viewpoint, staging is 
> > a trainwreck so far, and I'd hate to see it get worse.
> 
> What is wrong with it?  Bugs are getting fixed, people are getting use 
> out of their hardware (hell, Linus is even using one of the drivers), 
> and lots of developers are cutting their teeth on helping out.
> 
> If you don't like it, just disable it in your kernel packages, or 
> instantly close out the bugs.  The drivers in staging has already helped 
> out some distros by virtue of including newer drivers than they were 
> mistakenly using at the time (Ubuntu, I'm looking at you...)
> 
> And again, it's helped out users, which is the most important thing 
> here.

yes.

Firstly, a distro can disable CONFIG_STAGING just fine and then there will 
be no 'crappy' drivers in that distro.

The thing is, the past decade has taught us that distros are willing to 
apply just about any crap if it helps out a significant proportion of 
users. Utrace crashes in Fedora dominated kerneloops.org stats for months. 
Special ACPI patches and hacks, experimental wireless and DRI drivers in 
Fedora, etc.

Why should the mainline kernel be any different? Treating it differently 
would be a double standard. If a distro can apply crappy patches in sake 
of utility, why shouldnt the upstream kernel have a staging area where 
useful but not fully upstream-worthy drivers can hang around?

For years the upstream kernel was a lot less useful to testers in practice 
because all the crappy but useful patches were in the distro kernels but 
not in the mainline kernel.

Now that the upstream kernel has such an area, exactly what has changed - 
besides making the kernel more useful, more testable, more hackable and 
more viable? In fact i claim that crap gets cleaned up much faster if it's 
out in the open for all to see - instead of hidden in distro SRPMs.

	Ingo
