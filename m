Return-Path: <linux-kernel-owner+w=401wt.eu-S932954AbXKOVsf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932954AbXKOVsf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 16:48:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764048AbXKOVs1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 16:48:27 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33499 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763777AbXKOVs0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 16:48:26 -0500
Date: Thu, 15 Nov 2007 13:47:54 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
cc: Bron Gondwana <brong@fastmail.fm>, Christian Kujau <lists@nerdbynature.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       robm@fastmail.fm, riel <riel@redhat.com>,
       Anton Altaparmakov <aia21@cam.ac.uk>
Subject: Re: mmap dirty limits on 32 bit kernels (Was: [BUG] New Kernel
 Bugs)
In-Reply-To: <1195162015.22457.52.camel@lappy>
Message-ID: <alpine.LFD.0.9999.0711151342100.4260@woody.linux-foundation.org>
References: <20071113.043207.44732743.davem@davemloft.net>  <20071113110259.44c56d42.akpm@linux-foundation.org>  <alpine.DEB.0.9999.0711132055550.7865@sheep.housecafe.de>  <20071113130411.26ccae12.akpm@linux-foundation.org>  <alpine.DEB.0.99999.0711132239350.3960@sheep.housecafe.de>
  <20071115040708.GB15302@brong.net>  <alpine.LFD.0.9999.0711142020220.2786@woody.linux-foundation.org>  <20071115052538.GA21522@brong.net>  <alpine.LFD.0.9999.0711142130090.2786@woody.linux-foundation.org>  <alpine.LFD.0.9999.0711142148380.2786@woody.linux-foundation.org>
  <20071115115049.GA8297@brong.net>  <alpine.LFD.0.9999.0711150818320.2786@woody.linux-foundation.org>  <1195155601.22457.25.camel@lappy> <1195159457.22457.35.camel@lappy>  <alpine.LFD.0.9999.0711151252340.4260@woody.linux-foundation.org> 
 <alpine.LFD.0.9999.0711151300250.4260@woody.linux-foundation.org> <1195162015.22457.52.camel@lappy>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 15 Nov 2007, Peter Zijlstra wrote:
> 
> But this problem is already an issue, Anton recently had a case where a
> 12GB highmem box locked up due to NTFS running out of lowmem - or
> something like that.

Yeah. I always considered HIGHMEM to just be unusable. It's ok for 
extending to 2-4GB (ie HIGHMEM4G, not 64G), and it's probably borderline 
usable for 4-8G if you are careful.

But quite frankly, I refuse to even care about anything past that. If you 
have 12G (or heaven forbid, even more) in your machine, and you can't be 
bothered to just upgrade to a 64-bit CPU, then quite frankly, *I* 
personally can't be bothered to care.

That's my personal opinion, and I realize that some of the commercial 
vendors may care about their insane customers' satisfaction, but I'm 
simply not interested in insane users. If they have that much RAM (and 
bought it a few years ago when a 64-bit CPU wasn't an option), they can't 
be poor.

So the _only_ explanation today for 12GB on a 32-bit machine is
 (a) insanity
or 
 (b) being so lazy as to not bother to upgrade
and in either case, my personal reaction is "I'm *not* crazy, and yes, I'm 
lazy too, and I can't give a rats *ss about those problems".

HIGHMEM was a mistake in the first place. It's one that we can live with, 
but I refuse to support it more than it needs to be supported. And 12GB is 
*way* past the end of what is worth supporting.

			Linus
