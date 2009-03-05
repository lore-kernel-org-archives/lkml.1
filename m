Return-Path: <linux-kernel-owner+w=401wt.eu-S1754737AbZCENcc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754737AbZCENcc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 08:32:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753062AbZCENcY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 08:32:24 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:45998 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752721AbZCENcX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 08:32:23 -0500
Date: Thu, 5 Mar 2009 14:32:08 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andreas Herrmann <andreas.herrmann3@amd.com>
Cc: Jaswinder Singh Rajput <jaswinder@kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [git-pull -tip V2] x86: msr architecture debug code
Message-ID: <20090305133208.GC4322@elte.hu>
References: <1236008575.3332.2.camel@localhost.localdomain> <20090302205437.GB14471@elte.hu> <1236194183.4994.9.camel@localhost.localdomain> <1236199796.3130.3.camel@localhost.localdomain> <20090305122157.GA7347@alberich.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090305122157.GA7347@alberich.amd.com>
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


* Andreas Herrmann <andreas.herrmann3@amd.com> wrote:

> On Thu, Mar 05, 2009 at 02:19:56AM +0530, Jaswinder Singh Rajput wrote:
> > On Thu, 2009-03-05 at 00:46 +0530, Jaswinder Singh Rajput wrote:
> > 
> > > The following changes since commit 1d10914bf2c8a1164aef6c341e6c3518a91b8374:
> > >   Ingo Molnar (1):
> > >         Merge branch 'core/percpu'
> > > 
> > > are available in the git repository at:
> > > 
> > >   git://git.kernel.org/pub/scm/linux/kernel/git/jaswinder/linux-2.6-tip-cpu.git master
> > > 
> > > Jaswinder Singh Rajput (1):
> > >       x86: msr architecture debug code
> 
> Hi,
> 
> Why do we need this in-kernel?
> We have already access to MSRs via /dev/cpu/*/msr
> 
> Did you have a look at x86info.  (see
> http://www.codemonkey.org.uk/projects/x86info/)
> Recent versions contain a tool called lsmsr -- which shows you MSRs
> and also decodes some bits, e.g.

Having debugfs access and a topical splitup of all MSRs (and 
possibly other CPU data - not necessarily MSR accessible - such 
as the CR bits, etc.) is a nice touch i think and allows the 
quick inspection of various properties of a CPU.
 
> - I've just one directory in debugfs
>   x86/cpu/msr/cpu0
>   The system has a quad-core CPU. So I guess there should be 4
>   directories -- one for each core.

Correct, most MSRs are per core - that needs to be fixed.

	Ingo
