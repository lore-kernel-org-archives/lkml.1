Return-Path: <linux-kernel-owner+w=401wt.eu-S1754031AbZBTRxK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754031AbZBTRxK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 12:53:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751739AbZBTRwy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 12:52:54 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:38593 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752523AbZBTRwx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 12:52:53 -0500
Date: Fri, 20 Feb 2009 18:52:39 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [git pull v2] x86 page fault checker
Message-ID: <20090220175239.GM24538@elte.hu>
References: <alpine.DEB.2.00.0902201012220.29217@gandalf.stny.rr.com> <20090220155036.GA3225@elte.hu> <alpine.DEB.2.00.0902201232510.13747@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0902201232510.13747@gandalf.stny.rr.com>
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


* Steven Rostedt <rostedt@goodmis.org> wrote:

> Ingo,
> 
> I added your suggestion, and even tested it out. I cherry picked
> a branch to remove your split_large fix, added this output, and then
> added the changes that triggered the original bug. I got a very nasty 
> warning, but the kernel resumed fine.

Pulled into tip:x86/mm. It's not urgent in terms of .29 
material, agreed?

> ------------[ cut here ]------------
> WARNING: at arch/x86/mm/fault.c:495 do_page_fault+0x2aa/0x890()
> Hardware name: Precision WorkStation 470   
> PMD has incorrect permission bits
> [...]

Tested trees are much apprecitated! :-)

	Ingo
