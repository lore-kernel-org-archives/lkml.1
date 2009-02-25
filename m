Return-Path: <linux-kernel-owner+w=401wt.eu-S1760378AbZBYPmj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760378AbZBYPmj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 10:42:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753006AbZBYPma
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 10:42:30 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:38808 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750900AbZBYPm3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 10:42:29 -0500
Date: Wed, 25 Feb 2009 16:41:15 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Dave Airlie <airlied@redhat.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Eric Anholt <eric@anholt.net>,
       Thomas Gleixner <tglx@linutronix.de>, H Peter Anvin <hpa@zytor.com>,
       Keith Packard <keithp@keithp.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [patch 0/4] gpu/drm, x86, PAT: Add PAT support for io_mapping_*
	interface
Message-ID: <20090225154115.GA12050@elte.hu>
References: <20090225013510.010493000@intel.com> <20090225120839.GC14279@elte.hu> <7E82351C108FA840AB1866AC776AEC464A6A209C@orsmsx505.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7E82351C108FA840AB1866AC776AEC464A6A209C@orsmsx505.amr.corp.intel.com>
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


* Pallipadi, Venkatesh <venkatesh.pallipadi@intel.com> wrote:

> >They will probably fix a few regressions and are easy to 
> >revert, plus they affect the one driver whose authors wrote 
> >these facilities:
> >
> >  drivers/gpu/drm/i915/i915_dma.c
> >  drivers/gpu/drm/i915/i915_gem.c
> >
> >so maybe we should try it as it's all a clear step forward. 
> >I'll give them a spin in tip:x86/urgent. Dunno.
> 
> Actual PAT support (patch 3 and 4) can probably wait until 
> .30. As there is only one user of this interface. Patch 1 and 
> 2 are more in bugfix category and probably considered for .29.

ok, i've delayed #3/#4 to .30 and kept #1/#2 in tip:x86/urgent. 
No complications so far with any of them.

	Ingo
