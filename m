Return-Path: <linux-kernel-owner+w=401wt.eu-S1756030AbYCJUB4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756030AbYCJUB4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 16:01:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752916AbYCJUBs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 16:01:48 -0400
Received: from mx1.redhat.com ([66.187.233.31]:35769 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751250AbYCJUBr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 16:01:47 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
X-Fcc: ~/Mail/linus
Cc: Chuck Ebbert <cebbert@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86_64 ptrace orig_ax on ia32 task
In-Reply-To: Linus Torvalds's message of  Monday, 10 March 2008 12:48:46 -0700 <alpine.LFD.1.00.0803101247250.5896@woody.linux-foundation.org>
X-Fcc: ~/Mail/linus
References: <20080229035707.EAE862700FD@magilla.localdomain>
	<20080307225602.6491B26F990@magilla.localdomain>
	<47D589B9.1080109@redhat.com>
	<alpine.LFD.1.00.0803101247250.5896@woody.linux-foundation.org>
X-Zippy-Says: Remember, in 2039, MOUSSE & PASTA will be available ONLY by prescription!!
Message-Id: <20080310200111.4560226F991@magilla.localdomain>
Date: Mon, 10 Mar 2008 13:01:11 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Mon, 10 Mar 2008, Chuck Ebbert wrote:
> > 
> > That original patch is still unmerged as of -rc5.
> 
> The original is, but the modified one that just does this unconditionally 
> for x86-64 isn't. See commit 84c6f6046c5a2189160a8f0dca8b90427bf690ea.

Chuck was not referring to my original version of that patch.
As that patch's log says:
    
    This follows on my "x86_64 ia32 syscall restart fix".  This didn't
    matter until that was fixed.
    
The "x86_64 ia32 syscall restart fix" patch was not merged before the follow-on.
It's in Ingo's x86/for-linux as commit 5813a19cba5735b629cdeb156863dab814759128.


Thanks,
Roland
