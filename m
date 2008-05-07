Return-Path: <linux-kernel-owner+w=401wt.eu-S1762375AbYEGPDj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762375AbYEGPDj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 11:03:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757307AbYEGPDZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 11:03:25 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52014 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753893AbYEGPDX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 11:03:23 -0400
Date: Wed, 7 May 2008 08:02:23 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: Andi Kleen <andi@firstfloor.org>, Matthew Wilcox <matthew@wil.cx>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Alexander Viro <viro@ftp.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: AIM7 40% regression with 2.6.26-rc1
In-Reply-To: <alpine.LFD.1.10.0805070757170.32269@woody.linux-foundation.org>
Message-ID: <alpine.LFD.1.10.0805070800120.32269@woody.linux-foundation.org>
References: <1210052904.3453.30.camel@ymzhang> <20080506114449.GC32591@elte.hu> <1210126286.3453.37.camel@ymzhang> <1210131712.3453.43.camel@ymzhang> <87lk2mbcqp.fsf@basil.nowhere.org> <20080507114643.GR19219@parisc-linux.org> <87hcdab8zp.fsf@basil.nowhere.org>
 <alpine.LFD.1.10.0805070728280.32269@woody.linux-foundation.org> <20080507153538.446693af@core> <alpine.LFD.1.10.0805070757170.32269@woody.linux-foundation.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 7 May 2008, Linus Torvalds wrote:
> 
> Quite frankly, maybe we _need_ to have a bad BKL for those to ever get 
> fixed. As it was, people worked on trying to make the BKL behave better, 
> and it was a failure. Rather than spend the effort on trying to make it 
> work better (at a horrible cost), why not just say "Hell no - if you have 
> issues with it, you need to work with people to get rid of the BKL 
> rather than cluge around it".

Put another way: if we had introduced the BKL-as-semaphore with a known 
40% performance drop in AIM7, I would simply never ever have accepted the 
patch in the first place, regardless of _any_ excuses. 

Performance is a feature too.

Now, just because the code is already merged should not be an excuse for 
it then being shown to be bad. It's not a valid excuse to say "but we 
already merged it, so we can't unmerge it". We sure as hell _can_ unmerge 
it. 

			Linus
