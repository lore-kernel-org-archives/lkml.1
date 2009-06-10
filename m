Return-Path: <linux-kernel-owner+w=401wt.eu-S1760121AbZFJXBR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760121AbZFJXBR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 19:01:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757305AbZFJXBH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 19:01:07 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:36797 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757231AbZFJXBG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 19:01:06 -0400
Date: Thu, 11 Jun 2009 01:00:56 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL] x86/cpufeature for v2.6.31
Message-ID: <20090610230056.GA13641@elte.hu>
References: <20090610211629.GA11105@elte.hu> <alpine.LFD.2.01.0906101554320.6847@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.01.0906101554320.6847@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> 
> 
> On Wed, 10 Jun 2009, Ingo Molnar wrote:
> > 
> > Please pull the latest x86-cpufeature-for-linus git tree from:
> > 
> >    git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-cpufeature-for-linus
> 
> Hmm. This was already part of the irq-tree.

Ah, sorry - due to:

 commit ee4c24a5c9b530481394132c8dbc10572d57c075
 Merge: 3d58f48... 3e0c373...
 Author: Ingo Molnar <mingo@elte.hu>
 Date:   Mon Jun 1 22:29:35 2009 +0200

    Merge branch 'x86/cpufeature' into irq/numa
    
    Merge reason: irq/numa didnt build because this commit:
    
      2759c32: x86: don't call read_apic_id if !cpu_has_apic
    
    Had a dependency on x86/cpufeature changes. Pull in that
    (small) branch to fix the dependency.
    
    Signed-off-by: Ingo Molnar <mingo@elte.hu>

This seemed like one of the exceptions to do that merge - 
x86/cpufeature is a narrow 'infrastructure' topic we keep around 
during the development window, because we found it in the past that 
cpufeature changes frequently cause conflicts and merge 
dependencies. The cpufeatres commits are always kept uninteresting 
and non-controversial.

So technically it's a cross-tree merge, but of the good and 
exceptional kind ... i hope :-/

> (But at least so far, this merge window looks much cleaner wrt x86 
> merges.

Thanks :)

> [...] I'm hoping there are no nasty surprises down the line ;)

There are none planned! :-)

	Ingo
