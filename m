Return-Path: <linux-kernel-owner+w=401wt.eu-S1760148AbYEQVIP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760148AbYEQVIP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2008 17:08:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758739AbYEQVIA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 May 2008 17:08:00 -0400
Received: from www.tglx.de ([62.245.132.106]:52294 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756958AbYEQVH7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2008 17:07:59 -0400
Date: Sat, 17 May 2008 23:02:03 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Ingo Molnar <mingo@elte.hu>, David Miller <davem@davemloft.net>,
       linux-kernel@vger.kernel.org, hpa@zytor.com
Subject: Re: [GIT pull] x86 fixes for 2.6.26
In-Reply-To: <alpine.LFD.1.10.0805171256430.3020@woody.linux-foundation.org>
Message-ID: <alpine.LFD.1.10.0805172258110.18798@apollo.tec.linutronix.de>
References: <alpine.LFD.1.10.0805161544080.3020@woody.linux-foundation.org> <alpine.LFD.1.10.0805170116490.3255@apollo.tec.linutronix.de> <alpine.LFD.1.10.0805161658450.3020@woody.linux-foundation.org> <20080516.172835.260358594.davem@davemloft.net>
 <alpine.LFD.1.10.0805161831380.3020@woody.linux-foundation.org> <20080517193928.GA29722@elte.hu> <alpine.LFD.1.10.0805171256430.3020@woody.linux-foundation.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 17 May 2008, Linus Torvalds wrote:
> On Sat, 17 May 2008, Ingo Molnar wrote:
> > 
> > We've solved it by still doing the merges (we _need_ the information 
> > about potential upcoming merge trouble), but we dont commit them to the 
> > topic branches - we throw them away.
> 
> And that is *absolutely* the right thing to do.
> 
> Poeple need to test the different topic branches together some way anyway, 
> regardless of upcoming merge trouble, so yes, when you have more than one 
> branch, you inevitably need to have a "test branch" that ties them all 
> together for testing the end result (and that test branch generally would 
> be a throw-away one, like linux-next. In fact, it could *be* linux-next, 
> but there's good reason for you to test your own branches together rather 
> than waiting for an external entity to notice that your branches don't 
> work together).
> 
> So yes, sounds good.

In meantime - until we sorted out our new git life - can you please
pull the fixes without the noisy merge commits (resolved by rebasing
to keep thing rolling) from:

 ssh://master.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-fixes-for-linus 

Thanks,
	tglx
