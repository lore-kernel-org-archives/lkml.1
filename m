Return-Path: <linux-kernel-owner+w=401wt.eu-S1757966AbYJXSMg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757966AbYJXSMg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 14:12:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751904AbYJXSM2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 14:12:28 -0400
Received: from waste.org ([66.93.16.53]:46101 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751135AbYJXSM1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 14:12:27 -0400
Subject: Re: Linux 2.6.28-rc1
From: Matt Mackall <mpm@selenic.com>
To: Fenghua Yu <fenghua.yu@intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, David Woodhouse <dwmw2@infradead.org>
In-Reply-To: <20081024180541.GA13637@linux-os.sc.intel.com>
References: <alpine.LFD.2.00.0810232028500.3287@nehalem.linux-foundation.org>
	 <1224868194.3248.13.camel@calx> <1224870872.3248.20.camel@calx>
	 <49020C99.8090108@oracle.com>
	 <20081024180541.GA13637@linux-os.sc.intel.com>
Content-Type: text/plain
Date: Fri, 24 Oct 2008 13:11:19 -0500
Message-Id: <1224871879.3248.23.camel@calx>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-10-24 at 11:05 -0700, Fenghua Yu wrote:
> On Fri, Oct 24, 2008 at 10:57:45AM -0700, Randy Dunlap wrote:
> > Matt Mackall wrote:
> > > On Fri, 2008-10-24 at 12:10 -0500, Matt Mackall wrote:
> > >> On Thu, 2008-10-23 at 21:10 -0700, Linus Torvalds wrote:
> > >>> It's been two weeks, so it's time to close the merge window. A 2.6.28-rc1 
> > >>> is out there, and it's hopefully all good.
> > >> This fails building on allnoconfig on at least x86-64 because forbid_dac
> > >> used by arch/x86/kernel/pci-dma.c is defined off in
> > >> drivers/pci/quirks.c, which isn't built if CONFIG_PCI isn't set.
> > > 
> > > (Also fails on x86-32)
> > > 
> > > Bisection points to: 
> > > 
> > > 5b6985ce8ec7127b4d60ad450b64ca8b82748a3b
> > > intel-iommu: IA64 support
> > 
> > Patch for this has been posted.  I don't have it handy ATM.
> > 
> 
> Yes, the fix patch has been posted yesterday. And it has been merged into linux-next tree already. In case you need it, I post it here again.

Thanks, works for me.

-- 
Mathematics is the supreme nostalgia of our time.

