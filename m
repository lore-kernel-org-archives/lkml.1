Return-Path: <linux-kernel-owner+w=401wt.eu-S1757317AbYJXR7Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757317AbYJXR7Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 13:59:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751011AbYJXR7A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 13:59:00 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:36821 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750854AbYJXR67 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 13:58:59 -0400
Message-ID: <49020C99.8090108@oracle.com>
Date: Fri, 24 Oct 2008 10:57:45 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080914)
MIME-Version: 1.0
To: Matt Mackall <mpm@selenic.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Fenghua Yu <fenghua.yu@intel.com>,
       David Woodhouse <dwmw2@infradead.org>
Subject: Re: Linux 2.6.28-rc1
References: <alpine.LFD.2.00.0810232028500.3287@nehalem.linux-foundation.org>	 <1224868194.3248.13.camel@calx> <1224870872.3248.20.camel@calx>
In-Reply-To: <1224870872.3248.20.camel@calx>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matt Mackall wrote:
> On Fri, 2008-10-24 at 12:10 -0500, Matt Mackall wrote:
>> On Thu, 2008-10-23 at 21:10 -0700, Linus Torvalds wrote:
>>> It's been two weeks, so it's time to close the merge window. A 2.6.28-rc1 
>>> is out there, and it's hopefully all good.
>> This fails building on allnoconfig on at least x86-64 because forbid_dac
>> used by arch/x86/kernel/pci-dma.c is defined off in
>> drivers/pci/quirks.c, which isn't built if CONFIG_PCI isn't set.
> 
> (Also fails on x86-32)
> 
> Bisection points to: 
> 
> 5b6985ce8ec7127b4d60ad450b64ca8b82748a3b
> intel-iommu: IA64 support

Patch for this has been posted.  I don't have it handy ATM.

~Randy
