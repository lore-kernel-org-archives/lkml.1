Return-Path: <linux-kernel-owner+w=401wt.eu-S1754715AbYI0TRZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754715AbYI0TRZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Sep 2008 15:17:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753582AbYI0TRS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Sep 2008 15:17:18 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:53781 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753346AbYI0TRR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Sep 2008 15:17:17 -0400
Date: Sat, 27 Sep 2008 21:16:53 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Mike Travis <travis@sgi.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Yinghai Lu <yhlu.kernel@gmail.com>, David Miller <davem@davemloft.net>,
       Alan.Brunelle@hp.com, tglx@linutronix.de, rjw@sisk.pl,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       kernel-testers@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, arjan@linux.intel.com,
       Jack Steiner <steiner@sgi.com>
Subject: Re: [Bug #11342] Linux 2.6.27-rc3: kernel BUG at mm/vmalloc.c -
	bisected
Message-ID: <20080927191653.GB18619@elte.hu>
References: <alpine.LFD.1.10.0808251344250.3363@nehalem.linux-foundation.org> <200809251150.26760.rusty@rustcorp.com.au> <alpine.LFD.1.10.0809250836270.3265@nehalem.linux-foundation.org> <200809261525.30258.rusty@rustcorp.com.au> <48DC78F2.8060400@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48DC78F2.8060400@sgi.com>
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


* Mike Travis <travis@sgi.com> wrote:

> Hi Rusty,
> 
> I've gotten some good traction on the changes in the following patch.  
> About 30% of the kernel is compiling right now and I'm picking up 
> errors and warnings as I'm going along.  I think it's doing most of 
> what we need.  Attempting to hide the cpumask struct definition caused 
> all kinds of problems with the inline functions and statically 
> declaring cpumask's.
> 
> (The following patch is a combination of all the changes to cpumask.h 
> with the header from the first patch.  I'll send you a complete copy 
> in separate email.)

could you please send whatever .c changes you have already, so that we 
can have a look at how the end result will look like? Doesnt have to 
build, i'm just curious about how it looks like in practice, 
semantically.

	Ingo
