Return-Path: <linux-kernel-owner+w=401wt.eu-S932453AbZFLEIN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932453AbZFLEIN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 00:08:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751310AbZFLEH7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 00:07:59 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:32922 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751242AbZFLEH7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 00:07:59 -0400
Date: Fri, 12 Jun 2009 00:07:51 -0400
From: Kyle McMartin <kyle@mcmartin.ca>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Christoph Hellwig <hch@infradead.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Al Viro <viro@ZenIV.linux.org.uk>, Ingo Molnar <mingo@elte.hu>,
       "David S. Miller" <davem@davemloft.net>,
       Stephane Eranian <eranian@googlemail.com>, linux-kernel@vger.kernel.org,
       Paul Mackerras <paulus@samba.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [GIT PULL] Performance Counters for Linux
Message-ID: <20090612040751.GA20922@bombadil.infradead.org>
References: <20090611160329.GA3366@elte.hu> <20090611161714.GA5008@infradead.org> <alpine.LFD.2.01.0906110922080.3573@localhost.localdomain> <20090611165226.GV8633@ZenIV.linux.org.uk> <1244739378.6691.540.camel@laptop> <20090611170015.GA3651@infradead.org> <alpine.LFD.2.01.0906111005020.3573@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.01.0906111005020.3573@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[With my Fedora on.]

On Thu, Jun 11, 2009 at 10:06:55AM -0700, Linus Torvalds wrote:
> 
> 
> On Thu, 11 Jun 2009, Christoph Hellwig wrote:
> > 
> > So what point is there in keeping it in-tree except making life hell for
> > packagers?
> 
> Give it up. Packagers can trivially generate their own sub-packages. They 
> do it all the time. They already do it for the user-mode header files, 
> extracted from the kernel - something you've worked on yourself.
> 
> So your point is clearly bogus, and dishonest.
> 
> You haven't actually looked the real problem in the eye, and acknowledged 
> the disaster that is oprofile. Let's give a _new_ approach a chance, and 
> see if we can avoid the mistakes of yesteryear this time.
> 

This is actually somewhat complicated for (at least, I can only speak
from experience for...) Fedora and Debian/Ubuntu. Having this in-kernel
means any bugfixes needed for the 'perf' tool, require patching the
kernel source, which will result in a whole new kernel rpm being built.
So in order to update their 'perf' tool, users will get a new kernel,
debuginfo, etc., with it.

So either we need to split it out into its own source tarball, or ship
the kernel source again in a seperate source package. I know which I'm
going to tend to favour...

Obviously, I understand the reasons for doing this, but I don't really
see it as a sensible long term option for a mature tool. But,
whatever, it's not my call. We'll just work around whatever happens.

regards, Kyle
