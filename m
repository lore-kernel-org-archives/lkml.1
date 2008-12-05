Return-Path: <linux-kernel-owner+w=401wt.eu-S1758625AbYLENxU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758625AbYLENxU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2008 08:53:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751552AbYLENxI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Dec 2008 08:53:08 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:49647 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751138AbYLENxH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2008 08:53:07 -0500
Date: Fri, 5 Dec 2008 14:52:53 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Ken Chen <kenchen@google.com>, Paul Menage <menage@google.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [patch] export percpu cpuacct cgroup stats
Message-ID: <20081205135253.GE27039@elte.hu>
References: <b040c32a0812032048x4a11dc26k184a4b279b509050@mail.gmail.com> <49376BE3.1040909@cn.fujitsu.com> <6599ad830812041502m15f54f0ckd8baa0a1792fc31e@mail.gmail.com> <b040c32a0812042344n75117b68x8de975d12dddf594@mail.gmail.com> <4938DE1C.6070608@cn.fujitsu.com> <b040c32a0812050030uff5ae65o417c599a792c800c@mail.gmail.com> <4938E7C1.9040102@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4938E7C1.9040102@cn.fujitsu.com>
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


* Li Zefan <lizf@cn.fujitsu.com> wrote:

> Ken Chen wrote:
> > On Thu, Dec 4, 2008 at 11:54 PM, Li Zefan <lizf@cn.fujitsu.com> wrote:
> >>> +             seq_printf(m, "%llu ", percpu);
> >> Should be:
> >> +               seq_printf(m, "%llu ", (unsigned long long)percpu);
> >>
> >> Otherwsise:
> >> kernel/sched.c: In function 'cpuacct_percpu_seq_read':
> >> kernel/sched.c:9359: warning: format '%llu' expects type 'long long unsigned int',
> >> but argument 3 has type 'u64'
> > 
> > huh, I was just wondering about the type case in cgroup_read_u64()
> > when I was looking at it earlier.  That explains it.  Diff patch
> > attached.
> > 
> 
> Reviewed-by: Li Zefan <lizf@cn.fujitsu.com>

Could someone please send the final patch with a final changelog, with 
all fixlets and tags in place please?

Thanks,

	Ingo
