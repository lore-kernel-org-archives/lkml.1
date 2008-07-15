Return-Path: <linux-kernel-owner+w=401wt.eu-S1756817AbYGOIdA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756817AbYGOIdA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 04:33:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754710AbYGOIcx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 04:32:53 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:53454 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754669AbYGOIcw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 04:32:52 -0400
Date: Tue, 15 Jul 2008 10:32:23 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Max Krasnyansky <maxk@qualcomm.com>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Vegard Nossum <vegard.nossum@gmail.com>,
       Paul Menage <menage@google.com>, Paul Jackson <pj@sgi.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, miaox@cn.fujitsu.com,
       rostedt@goodmis.org, Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: current linux-2.6.git: cpusets completely broken
Message-ID: <20080715083223.GA2600@elte.hu>
References: <b647ffbd0807120304o7a500dc9oce761e51c9dce908@mail.gmail.com> <alpine.LFD.1.10.0807121254490.2875@woody.linux-foundation.org> <alpine.LFD.1.10.0807121411350.2875@woody.linux-foundation.org> <b647ffbd0807141538g2004f245m5f54ec962f475ba5@mail.gmail.com> <alpine.LFD.1.10.0807141602250.3017@woody.linux-foundation.org> <b647ffbd0807141700s20e54fbewafb3d3e296e57f53@mail.gmail.com> <alpine.LFD.1.10.0807141707410.3017@woody.linux-foundation.org> <b647ffbd0807141921n13ffa59x416fc024c734ef02@mail.gmail.com> <487C1374.8020404@qualcomm.com> <alpine.LFD.1.10.0807142104250.3017@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0807142104250.3017@woody.linux-foundation.org>
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


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Mon, 14 Jul 2008, Max Krasnyansky wrote:
> > 
> > Did you guys an updated patch ? Dmitry pointed out several things that Linus
> > missed in his original version. I guess I can go through the thread and
> > reconstruct that but if you have a patch I can try let me know.
> 
> I didn't update it, and right now I'm just merging too much (and 
> discussing the merges) to have time.
> 
> The patch really needs to have some scheduler person look at the use 
> fo cpu_active_map - I was kind of hoping that Ingo would.

yeah - it's very high on our TODO list :-) Peter, Dmitry and me are 
looking into it.

I didnt touch most of -tip in the past few days to get a rock solid QA 
track record for all items we have.

	Ingo
