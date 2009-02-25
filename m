Return-Path: <linux-kernel-owner+w=401wt.eu-S1758687AbZBYCmA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758687AbZBYCmA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 21:42:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753544AbZBYClv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 21:41:51 -0500
Received: from cmpxchg.org ([85.214.51.133]:55016 "EHLO cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752939AbZBYClv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 21:41:51 -0500
Date: Wed, 25 Feb 2009 03:43:16 +0100
From: Johannes Weiner <hannes@cmpxchg.org>
To: Tejun Heo <tj@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, hpa@zytor.com, mingo@redhat.com,
       tglx@linutronix.de, linux-kernel@vger.kernel.org,
       linux-tip-commits@vger.kernel.org
Subject: Re: [tip:core/percpu] bootmem: clean up arch-specific bootmem wrapping
Message-ID: <20090225024316.GA1738@cmpxchg.org>
References: <tip-c132937556f56ee4b831ef4b23f1846e05fde102@kernel.org> <20090224214638.GA2049@cmpxchg.org> <20090224214932.GC12601@elte.hu> <20090224234949.GA1778@cmpxchg.org> <49A4ACAE.4020104@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49A4ACAE.4020104@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 25, 2009 at 11:27:58AM +0900, Tejun Heo wrote:
> Hello,
> 
> Johannes Weiner wrote:
> > No, when the patch was submitted for review, I pointed out the change
> > in semantics and gathered from Tejun's reaction that this wasn't done
> > intentionally.  So the problem is the change itself, not the missing
> > declaration.
> 
> Yeah, I should have regenerated the tree.  Sorry about that.

Sorry about my rude way of commenting.

> >>>From the original mail:
> > 
> > 	Johannes Weiner wrote:
> > 	> This won't suffice as reserve_bootmem() doesn't use
> > 	> alloc_bootmem_core(), so now you effectively removed the
> > 	> node-0 restriction for reserve_bootmem() on this
> > 	> configuration.
> > 
> > 	Ah... right.  :-(
> > 
> > I just wrote again because I didn't understand why Tejun acknowledged
> > the error in the patch and then it went into -tip anyway.
> > 
> > The other part of my email was just suggestions for a cleanup, I
> > wasn't referring to that when I said 'broken' - sorry if that is how
> > it came over.
> 
> It seems that the wrapping thing was broken both before and after the
> patch and can lead to panic on free path.  I'll soon post a patch to
> fix it.

Ok, thanks for looking into it!

	Hannes
