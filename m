Return-Path: <linux-kernel-owner+w=401wt.eu-S1758046AbYEACBo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758046AbYEACBo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 22:01:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752585AbYEACBg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 22:01:36 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39403 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750875AbYEACBf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 22:01:35 -0400
Date: Wed, 30 Apr 2008 19:01:12 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: David Miller <davem@davemloft.net>
cc: rjw@sisk.pl, w@1wt.eu, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, jirislaby@gmail.com
Subject: Re: Slow DOWN, please!!!
In-Reply-To: <20080430.185142.219463829.davem@davemloft.net>
Message-ID: <alpine.LFD.1.10.0804301855390.5994@woody.linux-foundation.org>
References: <200805010242.36775.rjw@sisk.pl> <alpine.LFD.1.10.0804301811051.5994@woody.linux-foundation.org> <alpine.LFD.1.10.0804301831330.5994@woody.linux-foundation.org> <20080430.185142.219463829.davem@davemloft.net>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 30 Apr 2008, David Miller wrote:
> From: Linus Torvalds <torvalds@linux-foundation.org>
> Date: Wed, 30 Apr 2008 18:40:39 -0700 (PDT)
> 
> > IOW, I argue that the high speed of merging very much is a big part of 
> > what gives us quality in the end. It may result in bugs along the way, but 
> > it also results in fixes, and lots of people looking at the result (and 
> > looking at it in *context*, not just as a patch flying around).
> 
> This is a huge burdon to put on people.
> 
> The more broken stuff you merge, the more people are forced to track
> these problems down so that they can get their own work done.

I'm not saying we should merge crap.

You can take any argument too far, and clearly it doesn't mean that we 
should just accept *anything*, because it will magically be gilded by its 
mere inclusion into the kernel. No, I'm not going to argue that.

But I do want to argue against the notion that the only way to raise 
quality is to do it before it gets merged. It's often better to merge 
early, and fix the issues the merge brings up early too!

Release early, release often. That was the watch-word early in Linux 
kernel development, and there was a reason for it. And it _worked_. Did it 
mean "release crap, release anything"? No. But it did mean that things got 
lots more exposure - even if those "things" were sometimes bugs.

			Linus
