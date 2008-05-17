Return-Path: <linux-kernel-owner+w=401wt.eu-S1758664AbYEQUFt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758664AbYEQUFt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2008 16:05:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757945AbYEQUFk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 May 2008 16:05:40 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48223 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756839AbYEQUFk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2008 16:05:40 -0400
Date: Sat, 17 May 2008 13:00:00 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
cc: David Miller <davem@davemloft.net>, tglx@linutronix.de,
       linux-kernel@vger.kernel.org, hpa@zytor.com
Subject: Re: [GIT pull] x86 fixes for 2.6.26
In-Reply-To: <20080517193928.GA29722@elte.hu>
Message-ID: <alpine.LFD.1.10.0805171256430.3020@woody.linux-foundation.org>
References: <alpine.LFD.1.10.0805161544080.3020@woody.linux-foundation.org> <alpine.LFD.1.10.0805170116490.3255@apollo.tec.linutronix.de> <alpine.LFD.1.10.0805161658450.3020@woody.linux-foundation.org> <20080516.172835.260358594.davem@davemloft.net>
 <alpine.LFD.1.10.0805161831380.3020@woody.linux-foundation.org> <20080517193928.GA29722@elte.hu>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 17 May 2008, Ingo Molnar wrote:
> 
> We've solved it by still doing the merges (we _need_ the information 
> about potential upcoming merge trouble), but we dont commit them to the 
> topic branches - we throw them away.

And that is *absolutely* the right thing to do.

Poeple need to test the different topic branches together some way anyway, 
regardless of upcoming merge trouble, so yes, when you have more than one 
branch, you inevitably need to have a "test branch" that ties them all 
together for testing the end result (and that test branch generally would 
be a throw-away one, like linux-next. In fact, it could *be* linux-next, 
but there's good reason for you to test your own branches together rather 
than waiting for an external entity to notice that your branches don't 
work together).

So yes, sounds good.

			Linus
