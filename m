Return-Path: <linux-kernel-owner+w=401wt.eu-S1764934AbYBLVCK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764934AbYBLVCK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 16:02:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760852AbYBLVB4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 16:01:56 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:42508 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752806AbYBLVBz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 16:01:55 -0500
Date: Tue, 12 Feb 2008 22:01:09 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <andi@firstfloor.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, "Frank Ch. Eigler" <fche@redhat.com>,
       Roland McGrath <roland@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [git pull] kgdb-light -v10
Message-ID: <20080212210109.GA15365@elte.hu>
References: <20080212100327.GA30873@one.firstfloor.org> <20080212112747.GA1569@elte.hu> <20080212121903.GA419@one.firstfloor.org> <20080212123839.GA15360@elte.hu> <20080212135027.GA1343@one.firstfloor.org> <20080212152846.GC3078@elte.hu> <alpine.LFD.1.00.0802120829410.2920@woody.linux-foundation.org> <20080212182024.GA4940@one.firstfloor.org> <20080212102010.d88886f3.akpm@linux-foundation.org> <20080212191659.GA6458@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080212191659.GA6458@one.firstfloor.org>
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


* Andi Kleen <andi@firstfloor.org> wrote:

> I agree with you in principle, but what do you do if one of the CPUs 
> doesn't answer?
> 
> Ingo seems to think it's ok for the debugger then to just hang too, I 
> think it should eventually time out and debug anyways.

Andi, please refrain from misrepresenting my position, i can speak for 
myself.

As i stated it before, i'm not against adding some configuration on 
roundup behavior as long as it's clearly add-on optional system policy. 
In fact i already implemented that in the kgdb-light tree.

But if your goal is to create smoke where there is none, then feel free 
to continue to beat down on this poor strawman, ok? ;-) Meanwhile we'll 
continue to clean up kgdb to make it ready for an eventual (and IMO well 
deserved) .26 merge. All the useful bits of your comments have made kgdb 
cleaner - thanks for that. But please lets keep this constructive. 
Thanks,

	Ingo
