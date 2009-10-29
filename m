Return-Path: <linux-kernel-owner+w=401wt.eu-S1755122AbZJ2PeJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755122AbZJ2PeJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Oct 2009 11:34:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754897AbZJ2PeJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Oct 2009 11:34:09 -0400
Received: from hera.kernel.org ([140.211.167.34]:45420 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754850AbZJ2PeI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Oct 2009 11:34:08 -0400
Message-ID: <4AE9B5E1.7030509@kernel.org>
Date: Thu, 29 Oct 2009 16:33:53 +0100
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Christoph Lameter <cl@linux-foundation.org>
CC: Jiri Kosina <jkosina@suse.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Jeff Mahoney <jeffm@suse.com>,
       "Luck, Tony" <tony.luck@intel.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [Bug #14467] Linker errors on ia64 with NR_CPUS=4096
References: <Sj-rRjx6TwF.A.djE.vqe5KB@chimera> <6dRYo8ss7vL.A.nnF.Cre5KB@chimera> <alpine.DEB.1.10.0910271623210.20363@V090114053VZO-1> <alpine.LSU.2.00.0910271922490.19847@wotan.suse.de> <alpine.DEB.1.10.0910291435420.18197@V090114053VZO-1> <4AE9AB23.8010207@kernel.org> <alpine.DEB.1.10.0910291455400.19555@V090114053VZO-1> <4AE9B090.9090107@kernel.org> <alpine.DEB.1.10.0910291517160.30265@V090114053VZO-1>
In-Reply-To: <alpine.DEB.1.10.0910291517160.30265@V090114053VZO-1>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Christoph Lameter wrote:
> As I have said repeately before: We need this for dynamic DMA slab
> creation in SLUB. Since you got it already halfway in: Complete it and I
> can get rid of the static percpu definitions that I had to add to be able
> to use the new percpu allocator.

I completely forgot about that.  The biggest cause of my reluctance is
that it's gonna make locking more complex as I really like the current
dumb locking in alloc path.  Oh well, I'm putting it on my todo list.

Thanks.

-- 
tejun
