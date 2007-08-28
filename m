Return-Path: <linux-kernel-owner+w=401wt.eu-S1753993AbXH1Ozh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753993AbXH1Ozh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 10:55:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752655AbXH1OzH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 10:55:07 -0400
Received: from mail.gmx.net ([213.165.64.20]:38929 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752524AbXH1OzE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 10:55:04 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/UyHF1XaTUkCgJc6Nnlk9UnobetNOyoJtjOdn1yZ
	QiYFuRRmsYa/y4
Subject: Re: [git pull request] scheduler updates
From: Mike Galbraith <efault@gmx.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
In-Reply-To: <20070828144604.GA13875@elte.hu>
References: <20070828113259.GA7922@elte.hu>
	 <1188310265.6336.5.camel@Homer.simpson.net>
	 <20070828144604.GA13875@elte.hu>
Content-Type: text/plain
Date: Tue, 28 Aug 2007 16:55:00 +0200
Message-Id: <1188312900.25496.1.camel@Homer.simpson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-08-28 at 16:46 +0200, Ingo Molnar wrote:
> * Mike Galbraith <efault@gmx.de> wrote:
> 
> > On Tue, 2007-08-28 at 13:32 +0200, Ingo Molnar wrote:
> > > Linus, please pull the latest scheduler git tree from:
> > > 
> > >   git://git.kernel.org/pub/scm/linux/kernel/git/mingo/linux-2.6-sched.git
> > > 
> > > no big changes - 5 small fixes and 1 small cleanup:
> > 
> > FWIW, I spent a few hours testing these patches with various loads, 
> > and all was peachy here.  No multimedia or interactivity aberrations 
> > noted.
> 
> great! Btw., there's another refinement Peter and me are working on (see 
> the patch below): to place new tasks into the existing 'scheduling flow' 
> in a more seemless way. In practice this should mean less firefox spikes 
> during a kbuild workload. If you have some time to try it, could you add 
> the patch below to your tree too, and see what happens during fork-happy 
> workloads? It does not seem to be overly urgent to apply at the moment, 
> but it is a nice touch i think.

Sure, I'll give it a try.  (i was just adding likely post 24 merge
candidates to give them some runtime anyway, one more to the queue)

	-Mike

