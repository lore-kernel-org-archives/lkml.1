Return-Path: <linux-kernel-owner+w=401wt.eu-S1762709AbYBLNpU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762709AbYBLNpU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 08:45:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761638AbYBLNpE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 08:45:04 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:41758 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761561AbYBLNpC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 08:45:02 -0500
Subject: Re: 2.6.24-git2: Oracle 11g VKTM process enters R state on startup
	and is unkillable [still broken in 2.6.25-rc1]
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Alessandro Suardi <alessandro.suardi@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <200802120012.35314.rjw@sisk.pl>
References: <5a4c581d0802110820l1fcbb1ffib874f268b4ab7eae@mail.gmail.com>
	 <20080211204921.GA24806@elte.hu> <20080211221034.GA2587@elte.hu>
	 <200802120012.35314.rjw@sisk.pl>
Content-Type: text/plain
Date: Tue, 12 Feb 2008 14:44:18 +0100
Message-Id: <1202823858.6247.26.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.90 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2008-02-12 at 00:12 +0100, Rafael J. Wysocki wrote:
> On Monday, 11 of February 2008, Ingo Molnar wrote:
> > 
> > * Ingo Molnar <mingo@elte.hu> wrote:
> > 
> > > no, they were not lost, they just didnt pass QA here (they crashed on 
> > > a particularly hard to debug 8-way box i have) and Peter worked on 
> > > that queue of fixes up until today to get it really correct. Could you 
> > > check:
> > > 
> > >    git://git.kernel.org/pub/scm/linux/kernel/git/mingo/linux-2.6-sched.git
> > > 
> > > combo patch below as well - whichever you prefer. The shortlog can be 
> > > found below as well - but i dont yet consider this pullable, i'd like 
> > > it to see pass a full night of randconfig tests on my test-systems.
> > 
> > ok, we just found the reason for the 8-way crash, the delta fix from 
> > Peter is below if any of you have tried the previous combo patch. 
> > Updated sched.git as well, new HEAD is 
> > fec13e45305d69fd0bd23b30bd05a0a42cf341f8.
> 
> With the previous patch and this patch applied, the issue is not reproducible
> here.

Did you enable CONFIG_RT_GROUP_SCHED (it defaults to n)?

If you didn't, could you try with it set to y?

