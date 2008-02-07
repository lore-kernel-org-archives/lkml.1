Return-Path: <linux-kernel-owner+w=401wt.eu-S965223AbYBGVmb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965223AbYBGVmb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 16:42:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965211AbYBGVkz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 16:40:55 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60221 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965204AbYBGVky (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 16:40:54 -0500
Date: Thu, 7 Feb 2008 13:40:45 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Grant Likely <grant.likely@secretlab.ca>, jirislaby@gmail.com,
       stephen.neuendorffer@xilinx.com, linux-kernel@vger.kernel.org,
       paulus@samba.org, galak@gate.crashing.org, benh@kernel.crashing.org
Subject: Re: Xilinx: hwicap driver comments
In-Reply-To: <20080207132106.ec5ebf1d.akpm@linux-foundation.org>
Message-ID: <alpine.LFD.1.00.0802071332480.2896@woody.linux-foundation.org>
References: <47AB6552.7040503@gmail.com> <20080207124203.147ce300.akpm@linux-foundation.org> <fa686aa40802071254p172103f0w423f4591583ca3ef@mail.gmail.com> <20080207132106.ec5ebf1d.akpm@linux-foundation.org>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 7 Feb 2008, Andrew Morton wrote:
> 
> It seems wrong that the signoff trail for that patch didn't actually
> reflect reality - it should have had both Josh's and Paul's signoffs.

No, it's correct.

If you look deeper, you'll see (in gitk, or using "--pretty=fuller") that 
it has:

	Author:     Stephen Neuendorffer <stephen.neuendorffer@xilinx.com>
	Commit:     Grant Likely <grant.likely@secretlab.ca>

which means that the sign-off chain is complete and matches:

    Signed-off-by: Stephen Neuendorffer <stephen.neuendorffer@xilinx.com>
    Signed-off-by: Grant Likely <grant.likely@secretlab.ca>

ie it was written by Stephen, and then committed by Grant, and that's the 
whole sequence.

Then, of course, that commit was merged into another tree entirely (by 
Josh) in 256ae6a720618cbbfacc5e62ea1fe7c129d1b644, and by Paul in 
5ab3e84f66321579ca36b63a13bf78decba65121 and then finally by me in 
37969581301e50872a1ae84dc73962b5f7ee6b76, but those merge commits only 
show up because there was other development too (ie those things would not 
have showed up at all if the merges had been just fast-forwards).

So in general, the rule is that the sign-off chain should take you from 
the author to the committer.

You can't really go any further: we could have some "forced sign-off on 
merge between trees", but that would not just be inconvenient, it is 
fundamentally questionable in a git environment: who is "upstream" is 
really just a matter of opinion (ie I may be "obviously upstream", but if 
I have merge problems I'll actually ask the downstream person to do the 
merge, because he's the one who has the knowledge about that particular 
merge!)

		Linus
