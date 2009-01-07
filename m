Return-Path: <linux-kernel-owner+w=401wt.eu-S1759846AbZAGPUn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759846AbZAGPUn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 10:20:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751081AbZAGPUe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 10:20:34 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:40878 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751311AbZAGPUd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 10:20:33 -0500
Date: Wed, 7 Jan 2009 16:19:58 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Mike Travis <travis@sgi.com>, Ingo Molnar <mingo@redhat.com>,
       Rusty Russell <rusty@rustcorp.com.au>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jack Steiner <steiner@sgi.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 03/11] cpumask: update pci_bus_show_cpuaffinity to use
	new cpumask API
Message-ID: <20090107151958.GB5771@elte.hu>
References: <20090104131759.865331000@polaris-admin.engr.sgi.com> <200901051127.03598.jbarnes@virtuousgeek.org> <4962602D.4070502@sgi.com> <200901051159.09278.jbarnes@virtuousgeek.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200901051159.09278.jbarnes@virtuousgeek.org>
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


* Jesse Barnes <jbarnes@virtuousgeek.org> wrote:

> On Monday, January 5, 2009 11:31 am Mike Travis wrote:
> > Jesse Barnes wrote:
> > > On Sunday, January 4, 2009 5:18 am Mike Travis wrote:
> > >> Impact: cleanup, reduce stack usage, use new cpumask API.
> > >>
> > >> Replace the local cpumask_t variable with a pointer to the
> > >> const cpumask that needs to be printed.
> > >>
> > >> Signed-off-by: Mike Travis <travis@sgi.com>
> > >> Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
> > >
> > > Can you resend these two against my linux-next branch?
> > >
> > > Thanks,
> >
> > Sure thing.  Would this be the latest .../sfr/linux-next.git master
> > tree or would I need to select some other branch?
> 
> That would probably work, but my actual tree is at 
> git://git.kernel.org/pub/scm/linux/kernel/git/jbarnes/pci-2.6.git; the linux-
> next branch is the one that I'll be sending to Linus soon.

hm, i already have it queued up in tip/cpus4096:

588235b: cpumask: update pci_bus_show_cpuaffinity to use new cpumask API

as you said that it would be fine to do it there. I guess it's not a 
problem to have it duplicate - the code changes one narrow area of code.

	Ingo
