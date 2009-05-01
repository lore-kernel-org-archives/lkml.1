Return-Path: <linux-kernel-owner+w=401wt.eu-S1764733AbZEAVJU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764733AbZEAVJU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 17:09:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753054AbZEAVJD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 17:09:03 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:35658 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752255AbZEAVJB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 17:09:01 -0400
Date: Fri, 1 May 2009 23:07:24 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Christoph Lameter <cl@linux.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, thomas.pi@arcor.dea,
       Yuriy Lalym <ylalym@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       ltt-dev@lists.casi.polymtl.ca, Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] Fix dirty page accounting in
	redirty_page_for_writepage()
Message-ID: <20090501210724.GB11095@elte.hu>
References: <20090430150142.GC20580@elte.hu> <alpine.DEB.1.10.0904301114440.4028@qirst.com> <20090430154255.GA3714@elte.hu> <alpine.DEB.1.10.0904301142140.4028@qirst.com> <20090430160606.GA5913@elte.hu> <alpine.LFD.2.00.0904300914110.3395@localhost.localdomain> <20090430172341.GA11865@elte.hu> <alpine.DEB.1.10.0904301406210.11923@qirst.com> <20090501195941.GA28264@elte.hu> <alpine.DEB.1.10.0905011632440.16255@qirst.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0905011632440.16255@qirst.com>
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


* Christoph Lameter <cl@linux.com> wrote:

> On Fri, 1 May 2009, Ingo Molnar wrote:
> 
> > > Plus percpu_add_preemptsafe().
> >
> > Ok - that would be easy. Would you be interested in doing that 
> > and would you be interested in resurrecting your old patches? 
> > They are genuinely useful IMHO.
> 
> I see but it may take some time for me to get that finished 
> (probably 2 weeks or so). Dont feel that you have to merge my old 
> patches or a variant thereof.

it's your baby really and i dont want to interfere in any negative 
way. The patches look fairly complete and you did all the hard work 
with them already.

Can help out with review and testing (as always) but i suspect it's 
more appropriate for -mm to carry them in the end, because of the MM 
and tree-wide impact, and because the fine differences between those 
APIs will only be truly visible on non-x86.

( There's also Tejun's latest improvements of the dynamic allocator
  that he made based on your feedback - are those in any tree yet? )

	Ingo
