Return-Path: <linux-kernel-owner+w=401wt.eu-S1764025AbYEFNL0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764025AbYEFNL0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 09:11:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756772AbYEFNLO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 09:11:14 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:54244 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756511AbYEFNLN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 09:11:13 -0400
Date: Tue, 6 May 2008 15:11:00 +0200
From: Ingo Molnar <mingo@elte.hu>
To: =?iso-8859-1?Q?J=2EA=2E_Magall=F3n?= <jamagallon@ono.com>
Cc: Linux-Kernel <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Scheduling problems ? [ Was: Linux 2.6.26-rc1 ]
Message-ID: <20080506131100.GC2146@elte.hu>
References: <alpine.LFD.1.10.0805031205330.2971@woody.linux-foundation.org> <20080506080712.5aab6d97@werewolf.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080506080712.5aab6d97@werewolf.home>
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


* J.A. Magallón <jamagallon@ono.com> wrote:

> Hi...
> 
> I have installed this kernel, and it behaves a bit strange.
> 
> If I launch a movie under totem, it plays nicely (no HD, just 
> 512x384). If then I start deluge with some torrents downloading, the 
> video begins to loose frames and jump, like loosing 1 or 2 frames per 
> second. There is not much bandwidth used, just 15-20 Kb.
> 
> I have tried the same copying a kernel source tree and the video plays 
> fine. So can it be something network related, os network+io to disk ?
> 
> No group scheduling, 1000Hz, fully preemptive kernel. If you smell 
> something and need my .config I will post it.

could you try latest -git (head v2.6.26-rc1-110-ga153063 or later). 

There's scheduler interactivity fixes in it: in particular the 
fair-sleepers latency bug was finally tracked down and fixed via 
v2.6.26-rc1-66-ga992241 ("sched: fix normalized sleeper").

In v2.6.25 we didnt find that bug in time - see v2.6.25-rc9-1-ge2df9e0 
('revert "sched: fix fair sleepers"').

	Ingo
