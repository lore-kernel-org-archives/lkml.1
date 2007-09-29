Return-Path: <linux-kernel-owner+w=401wt.eu-S1758033AbXI2SFZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758033AbXI2SFZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Sep 2007 14:05:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752832AbXI2SFP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Sep 2007 14:05:15 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:44975 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756203AbXI2SFO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Sep 2007 14:05:14 -0400
Date: Sat, 29 Sep 2007 18:59:40 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Dave Jones <davej@redhat.com>, Greg.Chandler@wellsfargo.com,
       cpufreq@lists.linux.org.uk, linux-kernel@vger.kernel.org,
       dan.j.williams@intel.com, Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <ak@suse.de>, Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 1/1] Kernel compile bug in 2.6.22.6/7 {maybe more} ARM/StrongARM
Message-ID: <20070929175940.GA14500@flint.arm.linux.org.uk>
References: <1E7A4807A136DF45AD33DB341D93C3BD1F0C19@msgswbmnmsp46.wellsfargo.com> <20070925073132.GA29127@flint.arm.linux.org.uk> <20070925143651.GA2769@redhat.com> <20070926205314.GB25747@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070926205314.GB25747@redhat.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 26, 2007 at 04:53:14PM -0400, Dave Jones wrote:
> Following up on this from yesterday, Linus please revert the above cset.
> It doesn't seem to be necessary (it was added to fix a miscompile in
> 'make allnoconfig' which doesn't seem to be repeatable with it reverted)
> and actively breaks the ARM SA1100 framebuffer driver.
> 
> (If you'd prefer a patch reverting it, I'll send one, but I'm
>  hoping that git-revert will just dtrt).

Dave,

Thanks for checking this out on x86, and getting it reverted.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
