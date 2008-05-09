Return-Path: <linux-kernel-owner+w=401wt.eu-S1755538AbYEIKIs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755538AbYEIKIs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 06:08:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750896AbYEIKIj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 06:08:39 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:49798 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750774AbYEIKIi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 06:08:38 -0400
Date: Fri, 9 May 2008 12:08:18 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Venki Pallipadi <venkatesh.pallipadi@intel.com>
Cc: Hugh Dickins <hugh@veritas.com>, Frans Pop <elendil@planet.nl>,
       Jesse Barnes <jesse.barnes@intel.com>, linux-kernel@vger.kernel.org,
       "Packard, Keith" <keith.packard@intel.com>,
       Yinghai Lu <yhlu.kernel@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Nick Piggin <npiggin@suse.de>
Subject: Re: [git head] X86_PAT & mprotect
Message-ID: <20080509100818.GD19617@elte.hu>
References: <200805022122.03576.elendil@planet.nl> <200805040910.57088.elendil@planet.nl> <200805050857.57661.jesse.barnes@intel.com> <200805051932.41827.elendil@planet.nl> <20080506224240.GA18706@linux-os.sc.intel.com> <20080507070217.GD32195@elte.hu> <Pine.LNX.4.64.0805071941140.18916@blonde.site> <20080507232326.GB10757@linux-os.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080507232326.GB10757@linux-os.sc.intel.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Venki Pallipadi <venkatesh.pallipadi@intel.com> wrote:

> > I've tried doing it slightly differently below, don't know whether 
> > you'll consider it an improvement or not.
> 
> Hugh: Thanks for looking into this. Yes. I like your modified patch. 
> Simpler and smaller.

i have stuck your original patch into testing and nothing blew up so 
far. Due to the mm/ bits this is not for the scope of x86.git, but 
obviously it all looks good and is .26-worthy to me:

 Acked-by: Ingo Molnar <mingo@elte.hu>
 Tested-by: Ingo Molnar <mingo@elte.hu>

Venki, could you please send a full patch against -git that has 
everything from Hugh included, with an updated changelog, for 
Linus/Andrew to ack/apply?

	Ingo
