Return-Path: <linux-kernel-owner+w=401wt.eu-S932438AbYDQKiY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932438AbYDQKiY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 06:38:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752966AbYDQKiP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 06:38:15 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:60615 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752840AbYDQKiP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 06:38:15 -0400
Date: Thu, 17 Apr 2008 12:38:00 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Vegard Nossum <vegard.nossum@gmail.com>
Subject: Re: [v2.6.26] what's brewing in x86.git for v2.6.26
Message-ID: <20080417103800.GA27250@elte.hu>
References: <20080416202338.GA6007@elte.hu> <20080417002552.5742ad65.akpm@linux-foundation.org> <20080417083000.GA4935@elte.hu> <20080417014054.ea788f1f.akpm@linux-foundation.org> <20080417090626.GA14383@elte.hu> <20080417021813.04df7912.akpm@linux-foundation.org> <20080417093025.GA17389@elte.hu> <20080417023603.672d1032.akpm@linux-foundation.org> <84144f020804170319g6e0b90ffq1c42179e084d18f@mail.gmail.com> <20080417033333.947dfcc9.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080417033333.947dfcc9.akpm@linux-foundation.org>
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


* Andrew Morton <akpm@linux-foundation.org> wrote:

> Thank you whoever wrote kmemcheck.txt
> 
> How come slub uses one byte to track the status of each byte when it 
> could use a single bit?
> 
> We (still!) have not made the decision whether to proceed with slab or 
> slub.  How hard would it be to port kmemcheck into slab?

i think slab is clearly out, unless some catastrophic regression is 
found. But Nick's SLQB might replace SLUB ;-)

	Ingo
