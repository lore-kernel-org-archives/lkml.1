Return-Path: <linux-kernel-owner+w=401wt.eu-S1753509AbYLRVrS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753509AbYLRVrS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2008 16:47:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751796AbYLRVrF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 16:47:05 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:53026 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751790AbYLRVrD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 16:47:03 -0500
Date: Thu, 18 Dec 2008 22:46:22 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Nick Piggin <npiggin@suse.de>, venkatesh.pallipadi@intel.com,
       tglx@linutronix.de, akpm@linux-foundation.org, hugh@veritas.com,
       arjan@infradead.org, jbarnes@virtuousgeek.org, rdreier@cisco.com,
       jeremy@goop.org, linux-kernel@vger.kernel.org,
       Suresh Siddha <suresh.b.siddha@intel.com>
Subject: Re: [patch 4/7] x86 PAT: Implement track/untrack of pfnmap regions
	for x86 - v3
Message-ID: <20081218214622.GB30834@elte.hu>
References: <20081218194126.963894000@intel.com> <20081218194617.533039000@intel.com> <20081218213806.GG10681@wotan.suse.de> <494AC358.6000103@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <494AC358.6000103@zytor.com>
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


* H. Peter Anvin <hpa@zytor.com> wrote:

> Nick Piggin wrote:
> > And that's the end of the mm/ code... yeah the mm/ parts seem OK to me,
> > with my minor comments addressed I would ack them all.
> 
> Great!
> 
> Venki, can this be done with incremental patches, or would that be too 
> messy?

would be nice to have them as deltas. The patches are pushed out into 
tip/master already - and we'll push it towards linux-next once Nick's 
concerns have been addressed.

	Ingo
