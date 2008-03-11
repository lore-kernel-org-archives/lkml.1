Return-Path: <linux-kernel-owner+w=401wt.eu-S1752310AbYCKJcf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752310AbYCKJcf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 05:32:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752180AbYCKJc0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 05:32:26 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:56460 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751973AbYCKJcZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 05:32:25 -0400
Date: Tue, 11 Mar 2008 10:32:00 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Roland McGrath <roland@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Chuck Ebbert <cebbert@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86_64 ptrace orig_ax on ia32 task
Message-ID: <20080311093200.GP25110@elte.hu>
References: <20080229035707.EAE862700FD@magilla.localdomain> <20080307225602.6491B26F990@magilla.localdomain> <47D589B9.1080109@redhat.com> <alpine.LFD.1.00.0803101247250.5896@woody.linux-foundation.org> <20080310200111.4560226F991@magilla.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080310200111.4560226F991@magilla.localdomain>
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


* Roland McGrath <roland@redhat.com> wrote:

> > On Mon, 10 Mar 2008, Chuck Ebbert wrote:
> > > 
> > > That original patch is still unmerged as of -rc5.
> > 
> > The original is, but the modified one that just does this unconditionally 
> > for x86-64 isn't. See commit 84c6f6046c5a2189160a8f0dca8b90427bf690ea.
> 
> Chuck was not referring to my original version of that patch.
> As that patch's log says:
>     
>     This follows on my "x86_64 ia32 syscall restart fix".  This didn't
>     matter until that was fixed.
>     
> The "x86_64 ia32 syscall restart fix" patch was not merged before the follow-on.
> It's in Ingo's x86/for-linux as commit 5813a19cba5735b629cdeb156863dab814759128.

yes, it's lined up for the next batch of fixes.

	Ingo
