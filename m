Return-Path: <linux-kernel-owner+w=401wt.eu-S1756122AbYFLILE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756122AbYFLILE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 04:11:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751459AbYFLIKs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 04:10:48 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:43785 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751394AbYFLIKq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 04:10:46 -0400
Date: Thu, 12 Jun 2008 10:10:29 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andreas Herrmann <andreas.herrmann3@amd.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Suresh B Siddha <suresh.b.siddha@intel.com>
Subject: Re: [PATCH 0/5] x86: minor PAT adaptations
Message-ID: <20080612081029.GA1403@elte.hu>
References: <20080610140411.GD5024@alberich.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080610140411.GD5024@alberich.amd.com>
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

> Following some patches to slightly adapt the PAT code.
> 
> patch 1 - enable PAT for all AMD CPUs that have the PAT feature flag set
> patch 2 - fix up paranoia check in pat_init and fix the logic to
>           enable/disable PAT (IMHO the current code enables PAT on all
>           Transmeta and Centaur CPUs even if no PAT feature flag is set) 
>           (I admit I should have changed the sequence of patches 1 and 2.)
> patch 3 - fix some checkpatch errors
> patch 4 - variable renaming

applied to tip/x86/pat, thanks Andreas. (i presume you'll send a 
followup patch for the suggestions that came up in the discussion)

> patch 5 - slightly changing the code that is doing the intersection of
>           pat_type and mtrr_type to be more readable (from my point of view)
> 
> Patches are against x86/pat (as of version v2.6.26-rc3-6-g46dd98a).

#5 makes sense too, but it didnt apply cleanly:

 Applying patch 
 patches/pat-x86-pat-make-pat-x-mtrr-type-more-readable.patch
 patching file arch/x86/mm/pat.c
 Hunk #1 FAILED at 185.
 1 out of 1 hunk FAILED -- rejects in file arch/x86/mm/pat.c

(it didnt apply neither against tip/x86/pat or tip/master, nor against 
linus/master. I guess it's some mixup somewhere.)

	Ingo
