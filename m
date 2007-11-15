Return-Path: <linux-kernel-owner+w=401wt.eu-S933546AbXKOWcQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933546AbXKOWcQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 17:32:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754913AbXKOWcA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 17:32:00 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38784 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754841AbXKOWb7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 17:31:59 -0500
Date: Thu, 15 Nov 2007 14:31:02 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Chris Friesen <cfriesen@nortel.com>
cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Bron Gondwana <brong@fastmail.fm>,
       Christian Kujau <lists@nerdbynature.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       robm@fastmail.fm, riel <riel@redhat.com>,
       Anton Altaparmakov <aia21@cam.ac.uk>
Subject: Re: mmap dirty limits on 32 bit kernels (Was: [BUG] New Kernel
 Bugs)
In-Reply-To: <473CC42C.2080601@nortel.com>
Message-ID: <alpine.LFD.0.9999.0711151426280.4260@woody.linux-foundation.org>
References: <20071113.043207.44732743.davem@davemloft.net> <alpine.DEB.0.9999.0711132055550.7865@sheep.housecafe.de> <20071113130411.26ccae12.akpm@linux-foundation.org> <alpine.DEB.0.99999.0711132239350.3960@sheep.housecafe.de> <20071115040708.GB15302@brong.net>
 <alpine.LFD.0.9999.0711142020220.2786@woody.linux-foundation.org> <20071115052538.GA21522@brong.net> <alpine.LFD.0.9999.0711142130090.2786@woody.linux-foundation.org> <alpine.LFD.0.9999.0711142148380.2786@woody.linux-foundation.org> <20071115115049.GA8297@brong.net>
 <alpine.LFD.0.9999.0711150818320.2786@woody.linux-foundation.org> <1195155601.22457.25.camel@lappy> <1195159457.22457.35.camel@lappy> <alpine.LFD.0.9999.0711151252340.4260@woody.linux-foundation.org> <alpine.LFD.0.9999.0711151300250.4260@woody.linux-foundation.org>
 <1195162015.22457.52.camel@lappy> <alpine.LFD.0.9999.0711151342100.4260@woody.linux-foundation.org> <473CC42C.2080601@nortel.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 15 Nov 2007, Chris Friesen wrote:
> 
> We've got some 32-bit 8GB boxes for which both of these would hold true.

Still not enough of a reason for me to care.

Remember - I'm the guy who refused to merge RH's 4G:4G patches because I 
thought they were an unsupportable nightmare.

I care a lot about future supportability, and HIGHMEM is there purely as a 
temporary wart and blip on the screen.

I did acknowledge that others may care more, but the fact is, I suspect 
that it's going to be cheaper to literally buy and ship a new machine to a 
customer than to really "suppport" it in any other form.

Side note: HIGHMEM64G works perfectly fine with 12GB of RAM under 
*limited*loads*. If your customer does certain well-defined and simple 
things that don't put huge and varied loads on the VFS or VM layer, then 
12GB+ is probably fine regardless.

			Linus
