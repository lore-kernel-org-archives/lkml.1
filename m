Return-Path: <linux-kernel-owner+w=401wt.eu-S1753692AbYFRJwA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753692AbYFRJwA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 05:52:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752157AbYFRJvx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 05:51:53 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:44030 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750955AbYFRJvw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 05:51:52 -0400
Date: Wed, 18 Jun 2008 11:51:28 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Hugh Dickins <hugh@veritas.com>
Cc: Andreas Herrmann <andreas.herrmann3@amd.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Suresh B Siddha <suresh.b.siddha@intel.com>,
       the arch/x86 maintainers <x86@kernel.org>
Subject: Re: [PATCH 5/5 v2] x86: PAT: make pat_x_mtrr_type() more readable
Message-ID: <20080618095128.GB15255@elte.hu>
References: <20080610140755.GI5024@alberich.amd.com> <20080616125821.GA5213@alberich.amd.com> <Pine.LNX.4.64.0806161753060.13075@blonde.site>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0806161753060.13075@blonde.site>
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


* Hugh Dickins <hugh@veritas.com> wrote:

> Clean up over-complications in pat_x_mtrr_type(). And if 
> reserve_memtype() ignores stray req_type bits when pat_enabled, it's 
> better to mask them off when not also.

applied, to tip/x86/pat, thanks Hugh. Andreas, if there's any other 
clean up you can think of here please send a delta patch.

	Ingo
