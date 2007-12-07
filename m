Return-Path: <linux-kernel-owner+w=401wt.eu-S1756970AbXLGS77@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756970AbXLGS77 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2007 13:59:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751336AbXLGS7v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Dec 2007 13:59:51 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:38316 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750901AbXLGS7u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2007 13:59:50 -0500
Date: Fri, 7 Dec 2007 19:59:20 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Fernando Lopez-Lezcano <nando@ccrma.Stanford.EDU>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, Len Brown <lenb@kernel.org>,
       Venki Pallipadi <venkatesh.pallipadi@intel.com>
Subject: Re: [git pull] x86/hrtimer/acpi fixes
Message-ID: <20071207185920.GA3006@elte.hu>
References: <20071207183633.GC26778@elte.hu> <1197053386.32023.13.camel@cmn3.stanford.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1197053386.32023.13.camel@cmn3.stanford.edu>
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


* Fernando Lopez-Lezcano <nando@ccrma.Stanford.EDU> wrote:

> Ingo, I was about to post about timer problems in 2.6.23.9+rt12 when I 
> saw this. Would this be related / should I test / will this solve 
> everything? :-)
> 
> What I'm seeing is jack "delays" that go away if I boot with 
> "idle=poll", just like it was happening a long time ago. Smells like 
> 'time of day' glitches when the process switches cpus (this is on a 
> dual core intel laptop).

does it go away with hpet=disable as well? If yes then there could be a 
relation. If not then it's something else and we need to debug it.

	Ingo
