Return-Path: <linux-kernel-owner+w=401wt.eu-S1755332AbZJ2PUO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755332AbZJ2PUO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Oct 2009 11:20:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755299AbZJ2PUL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Oct 2009 11:20:11 -0400
Received: from smtp2.ultrahosting.com ([74.213.174.253]:51449 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755195AbZJ2PUI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Oct 2009 11:20:08 -0400
Date: Thu, 29 Oct 2009 15:18:24 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@V090114053VZO-1
To: Tejun Heo <tj@kernel.org>
cc: Jiri Kosina <jkosina@suse.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Jeff Mahoney <jeffm@suse.com>,
       "Luck, Tony" <tony.luck@intel.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [Bug #14467] Linker errors on ia64 with NR_CPUS=4096
In-Reply-To: <4AE9B090.9090107@kernel.org>
Message-ID: <alpine.DEB.1.10.0910291517160.30265@V090114053VZO-1>
References: <Sj-rRjx6TwF.A.djE.vqe5KB@chimera> <6dRYo8ss7vL.A.nnF.Cre5KB@chimera> <alpine.DEB.1.10.0910271623210.20363@V090114053VZO-1> <alpine.LSU.2.00.0910271922490.19847@wotan.suse.de> <alpine.DEB.1.10.0910291435420.18197@V090114053VZO-1>
 <4AE9AB23.8010207@kernel.org> <alpine.DEB.1.10.0910291455400.19555@V090114053VZO-1> <4AE9B090.9090107@kernel.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 Oct 2009, Tejun Heo wrote:

> That would be nice but currently, we have no user which needs anything
> other than GFP_KERNEL although lack of users could have been caused by
> the lack of the functionality and the non-atomic irq disabled state is
> an exception case which is handled differently by might_sleep() too.
> So, I'm not sure whether adding GFP_* parameter would worth the
> effort.  Also, adding that is a bit too late for 2.6.32 at this point.

As I have said repeately before: We need this for dynamic DMA slab
creation in SLUB. Since you got it already halfway in: Complete it and I
can get rid of the static percpu definitions that I had to add to be able
to use the new percpu allocator.

