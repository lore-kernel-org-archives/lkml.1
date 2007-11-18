Return-Path: <linux-kernel-owner+w=401wt.eu-S1755374AbXKRXNg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755374AbXKRXNg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Nov 2007 18:13:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752869AbXKRXN2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Nov 2007 18:13:28 -0500
Received: from phunq.net ([64.81.85.152]:34736 "EHLO moonbase.phunq.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752807AbXKRXN2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Nov 2007 18:13:28 -0500
From: Daniel Phillips <phillips@phunq.net>
To: "Rob Mueller" <robm@fastmail.fm>
Subject: Re: mmap dirty limits on 32 bit kernels (Was: [BUG] New Kernel Bugs)
Date: Sun, 18 Nov 2007 16:13:18 -0700
User-Agent: KMail/1.9.5
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
       "Bron Gondwana" <brong@fastmail.fm>,
       "Christian Kujau" <lists@nerdbynature.de>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "riel" <riel@redhat.com>, "Anton Altaparmakov" <aia21@cam.ac.uk>
References: <20071113.043207.44732743.davem@davemloft.net> <alpine.LFD.0.9999.0711151342100.4260@woody.linux-foundation.org> <1ddf01c827d6$40106500$0a01a8c0@robmhp>
In-Reply-To: <1ddf01c827d6$40106500$0a01a8c0@robmhp>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711181513.19559.phillips@phunq.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 15 November 2007 14:24, Rob Mueller wrote:
> > That's my personal opinion, and I realize that some of the
> > commercial vendors may care about their insane customers'
> > satisfaction, but I'm simply not interested in insane users. If
> > they have that much RAM (and bought it a few years ago when a
> > 64-bit CPU wasn't an option), they can't be poor.
>
> From our perspective, the main issue is that some of these machines
> we spent quite a bit of money on the big RAM (for it's day) + lots of
> 15k RPM SCSI drives + multi-year support contracts. They're highly IO
> bound, and barely use 10-20% of their old 2.4Ghz Prestonia Xeon CPUs.
> It's hard to justify junking those machines < 5 years.
>
> We have a couple of 6G machines and some 8G machines using PAE. On
> the whole, they actually have been working really well (hmmm, apart
> from the recent dirty pages issue + reiserfs data=journal leaks +
> inodes in lowmem limits)

Junk everything except the 15K drives, you will be glad you did.  Too 
bad about those multi-year support contracts, hopefully you got a deal 
on them.

Prediction: after these dirty pages issues are gone, there will be more 
dirty page issues because the notion of dirty page limit is 
fundamentally broken.  Your smartest recourse is to re-motherboard to a 
place where the dirty page limit borkage does not hurt as much, and in 
the process you will get a cheap hardware upgrade.  Everybody will be 
happy, the sun will come out, the birds will sing.

Regards,

Daniel
