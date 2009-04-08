Return-Path: <linux-kernel-owner+w=401wt.eu-S1756403AbZDHIXM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756403AbZDHIXM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 04:23:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763605AbZDHIR1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 04:17:27 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:48126 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761466AbZDHIRZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 04:17:25 -0400
Date: Wed, 8 Apr 2009 10:17:11 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>
Cc: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: 2.6.29 git master and PAT problems
Message-ID: <20090408081711.GA4938@elte.hu>
References: <200903302317.04515.a.miskiewicz@gmail.com> <200904071112.28949.a.miskiewicz@gmail.com> <20090408013008.GA6696@linux-os.sc.intel.com> <200904080928.34580.a.miskiewicz@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200904080928.34580.a.miskiewicz@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: 0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.5 required=5.9 tests=BAYES_00,URIBL_BLACK autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	2.0 URIBL_BLACK            Contains an URL listed in the URIBL blacklist
	[URIs: tremolous.net]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Arkadiusz Miskiewicz <a.miskiewicz@gmail.com> wrote:

> On Wednesday 08 of April 2009, Pallipadi, Venkatesh wrote:
> > On Tue, Apr 07, 2009 at 02:12:28AM -0700, Arkadiusz Miskiewicz wrote:
> > > On Tuesday 07 of April 2009, Pallipadi, Venkatesh wrote:
> > > > On Thu, 2009-04-02 at 00:12 -0700, Arkadiusz Miskiewicz wrote:
> > > >
> > > > I was finally able to reproduce the problem of "freeing invalid
> > > > memtype" with upstream git kernel (commit 0221c81b1b) + latest xf86
> > > > intel driver. But, with upstream + the patch I had sent you earlier in
> > > > this thread (http://marc.info/?l=linux-kernel&m=123863345520617&w=2) I
> > > > don't see those freeing invalid memtype errors anymore.
> > > >
> > > > Can you please double check with current git and that patch and let me
> > > > know if you are still seeing the problem.
> > >
> > > Latest linus tree + that patch (it's really applied here), xserver 1.6,
> > > libdrm from git master, intel driver from git master, previously mesa 7.4
> > > (and 7.5 snap currently), tremolous.net 1.1.0 game (tremolous-smp
> > > binary), GM45 gpu.
> > >
> > > To reproduce I just need to run tremolous-smp and connect to some map.
> > > When map finishes loading I instantly get:
> [...]
> 
> > OK. One more test patch below, applies over linus's git and you can ignore
> > the earlier patch. The patch below should get rid of the problem and
> > as it removes the track/untrack of vm_insert_pfn completely. This will
> > also eliminate the overhead of hundreds or thousands of entries in
> > pat_memtype_list. Can you please test it.
> 
> With this patch I'm no longer able to reproduce problem. Thanks!

Great, thanks!

Venki, mind sending a patch with a proper changelog, Reported-by, 
Tested-by tags, with Nick and Andrew Cc:-ed for the memory.c bits, 
etc.?

	Ingo
