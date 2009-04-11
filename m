Return-Path: <linux-kernel-owner+w=401wt.eu-S1755697AbZDKHBH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755697AbZDKHBH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Apr 2009 03:01:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752776AbZDKHAz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Apr 2009 03:00:55 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:53872 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752600AbZDKHAy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Apr 2009 03:00:54 -0400
Date: Sat, 11 Apr 2009 09:00:35 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Eric Anholt <eric@anholt.net>
Cc: venkatesh.pallipadi@intel.com, tglx@linutronix.de, hpa@zytor.com,
       linux-kernel@vger.kernel.org, Suresh Siddha <suresh.b.siddha@intel.com>
Subject: Re: [patch 0/6] x86, PAT, CPA: Cleanups and minor bug fixes
Message-ID: <20090411070035.GB11799@elte.hu>
References: <20090409212646.511925000@intel.com> <1239396112.6356.10.camel@gaiman.anholt.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1239396112.6356.10.camel@gaiman.anholt.net>
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


* Eric Anholt <eric@anholt.net> wrote:

> On Thu, 2009-04-09 at 14:26 -0700, venkatesh.pallipadi@intel.com wrote:
> > This patchset contains cleanups and minor bug fixes in x86 PAT and CPA
> > related code. The bugs were mostly found by code inspection. There
> > should not be any functionality changes with this patchset.
> 
> I've been curious, what are you using to test PAT changes for 
> regressions?  I've got some regression tests at:
> 
> http://cgit.freedesktop.org/xorg/app/intel-gpu-tools/
> 
> Requires KMS enabled and master of libdrm, but after that you can 
> sudo make check, and it tests execution of several DRM paths 
> without requiring X.  In benchmarks/ there are a few 
> microbenchmarks of various mapping types, which has been useful in 
> making sure that we're ending up with the right PTEs.

Looks really nice! Regarding libdrm, is there a version cutoff from 
where it is expected to work just fine? I've got this version: 
libdrm-2.4.6-3.fc11.x86_64.

	Ingo
