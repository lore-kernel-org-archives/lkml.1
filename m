Return-Path: <linux-kernel-owner+w=401wt.eu-S1759161AbXJLD3Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759161AbXJLD3Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2007 23:29:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758957AbXJLD3A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Oct 2007 23:29:00 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:55137
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1758952AbXJLD27 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2007 23:28:59 -0400
Date: Thu, 11 Oct 2007 20:28:57 -0700 (PDT)
Message-Id: <20071011.202857.74752210.davem@davemloft.net>
To: torvalds@linux-foundation.org
Cc: rdreier@cisco.com, general@lists.openfabrics.org,
       linux-kernel@vger.kernel.org, jeff@garzik.org, gregkh@suse.de
Subject: Re: [GIT PULL] please pull infiniband.git for-linus
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.LFD.0.999.0710111944120.6887@woody.linux-foundation.org>
References: <aday7e9b0m3.fsf@cisco.com>
	<20071011.181719.78707713.davem@davemloft.net>
	<alpine.LFD.0.999.0710111944120.6887@woody.linux-foundation.org>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 11 Oct 2007 19:58:04 -0700 (PDT)

> 
> 
> On Thu, 11 Oct 2007, David Miller wrote:
> > 
> > Even if you're confident there won't be merge issues, could you just
> > wait for the net-2.6 stuff to go in first?
> 
> I pulled the net stuff first, and merged the IB stuff afterwards. No 
> conflicts in IB, but there *were* conflicts with the networking pull for 
> other reasons.
> 
> That horrid, horrid mess that is called include/linux/mod_devicetable.h 
> and scripts/mod/file2alias.c must go at some point. The thing is 
> unmaintainable. Different maintainers add their own structures to both, 
> and functions to both, and it's just messy. That's not how maintainable 
> and modularized code should be written.
> 
> Now it broke on sdio vs ssb, but there was actually a conflict earlier 
> with the Kbuild merge (which I aborted for other reasons), so this file 
> really is starting to be a problem.
> 
> The merge was fairly straightforward and stupid - it's not like the code 
> added is *complicated*, but all those small functions and structrues are 
> set up to be a maze of very similar lines, so the merge is actually much 
> worse than it should be - because there is inherent similarity, some lines 
> are automatically auto-merged, making the result just harder to visualize.
> 
> So I merged it all, and I don't expect any problems, but I'm hoping 
> somebody is thinking about that mod_devicetable.h/file2alias.c mess.

It all looks good from here.
