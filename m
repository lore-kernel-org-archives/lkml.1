Return-Path: <linux-kernel-owner+w=401wt.eu-S1756960AbZDHOjv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756960AbZDHOjv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 10:39:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754856AbZDHOjl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 10:39:41 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:47185 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753754AbZDHOjk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 10:39:40 -0400
Date: Wed, 8 Apr 2009 16:38:37 +0200
From: Ingo Molnar <mingo@elte.hu>
To: William Pitcock <nenolod@dereferenced.org>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
       the arch/x86 maintainers <x86@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] Re: [GIT PULL] Xen for 2.6.30 #2
Message-ID: <20090408143837.GG12931@elte.hu>
References: <49D1209A.9000800@goop.org> <49D25A42.7060300@goop.org> <20090331185541.GA17807@elte.hu> <49D2713D.6090401@goop.org> <20090403173623.GB6295@elte.hu> <1238899134.5814.172.camel@petrie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1238899134.5814.172.camel@petrie>
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


* William Pitcock <nenolod@dereferenced.org> wrote:

> Hi,
> 
> On Fri, 2009-04-03 at 19:36 +0200, Ingo Molnar wrote:
> > * Jeremy Fitzhardinge <jeremy@goop.org> wrote:
> > 
> > >> You know our stance which is very simple: dont put in Xen-only 
> > >> hooks that slow down native, and get rid of the existing Xen-only 
> > >> hooks.
> > >
> > > Yes, I understand that.  Unlike the pvops stuff, the dom0 changes 
> > > are largely all init-time and setup, and so have no performance 
> > > impact.
> > 
> > Yes, but once dom0 goes in your incentive to fix the native 
> > kernel performance drain we accumulated along the years of 
> > paravirt layers will be strongly weakened, right? :)
> 
> There's plenty of incentive for everyone who has a stake in this 
> thing to ensure that paravirt performs equally to native. I do not 
> see how you could be legitimately concerned about that.

Well, instead of supposedly plenty of speculative incentives in the 
future i'd like to see the existing performance impact of paravirt 
features to be fixed here and now, before piling up new features. 
Which did not get fixed in the past two years, despite those plenty 
of incentives you claim.

This is a basic engineering principle: fix up existing performance 
impact before piling up more overhead.

	Ingo
