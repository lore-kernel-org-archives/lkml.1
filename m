Return-Path: <linux-kernel-owner+w=401wt.eu-S1755815AbXJBHhx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755815AbXJBHhx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 03:37:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754830AbXJBHhm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 03:37:42 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:55281 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755583AbXJBHhk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 03:37:40 -0400
Date: Tue, 2 Oct 2007 09:37:03 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       mpm@selenic.com, "Huang, Ying" <ying.huang@intel.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Christoph Lameter <clameter@sgi.com>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: x86 patches was Re: -mm merge plans for 2.6.24
Message-ID: <20071002073703.GA31108@elte.hu>
References: <20071001142222.fcaa8d57.akpm@linux-foundation.org> <p733awu6nva.fsf@bingen.suse.de> <20071001233225.88c67e8b.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071001233225.88c67e8b.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Andrew Morton <akpm@linux-foundation.org> wrote:

> On 02 Oct 2007 08:18:17 +0200 Andi Kleen <andi@firstfloor.org> wrote:
>
> > The clockevents patches are not included in this; but given the 
> > recent trouble i'm not 100% sure they are even ready yet.

i'm curious, which "recent trouble" do you refer to? (The NMI watchdog 
bug [which is off by default] was fixed quickly. The C1E bug was found 
and fixed quickly. Anything else i missed?)

> hm, well, I hope you and Thomas are on the same page regarding 
> precisely what the remaining issues are.

i'd like to see the 64-bit clockevents (& dynticks) patches merged. 
Demand from users and distros is high: the 64-bit CE patches are merged 
into the Fedora 8 and Ubuntu kernels already, it's been in -mm and in 
-rt too for a long time and powertop users demand it as well. It also 
makes it obviously easier to unify the 64-bit and 32-bit code. So 
there's multiple good reasons to do it.

	Ingo
