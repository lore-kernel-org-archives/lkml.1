Return-Path: <linux-kernel-owner+w=401wt.eu-S1946213AbXBCCED@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946213AbXBCCED (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Feb 2007 21:04:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946216AbXBCCED
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Feb 2007 21:04:03 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:54202 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946213AbXBCCEB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Feb 2007 21:04:01 -0500
Message-ID: <45C3ED84.6010506@garzik.org>
Date: Fri, 02 Feb 2007 21:03:48 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20061219)
MIME-Version: 1.0
To: Andrew Morton <akpm@osdl.org>
CC: Adrian Bunk <bunk@stusta.de>, Linus Torvalds <torvalds@osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Eric Van Hensbergen <ericvh@gmail.com>,
       Trond Myklebust <trond.myklebust@fys.uio.no>,
       Neil Brown <neilb@suse.de>, Stephen Hemminger <shemminger@osdl.org>,
       Frederic Riss <frederic.riss@gmail.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Andi Kleen <ak@suse.de>, "Eric W. Biederman" <ebiederm@xmission.com>,
       Francois Romieu <romieu@fr.zoreil.com>
Subject: Re: 2.6.20-rc7: known regressions
References: <Pine.LNX.4.64.0701302019530.11095@woody.linux-foundation.org>	<20070202054916.GA3754@stusta.de> <20070202175504.a3bab5ac.akpm@linux-foundation.org>
In-Reply-To: <20070202175504.a3bab5ac.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.7 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Fri, 2 Feb 2007 06:49:16 +0100
> Adrian Bunk <bunk@stusta.de> wrote:
> 
>> This email lists some known regressions in 2.6.20-rc7 compared to 2.6.19
>> that are not yet fixed in Linus' tree.
> 
> There are still a few things hanging around.
> 
> I have these queued:
> 
> aio-fix-buggy-put_ioctx-call-in-aio_complete-v2.patch
> kexec-avoid-migration-of-already-disabled-irqs-ia64.patch
> net-smc911x-match-up-spin-lock-unlock.patch
> rtc-pcf8563-detect-polarity-of-century-bit-automatically.patch
> alpha-fix-epoll-syscall-enumerations.patch
> revert-blockdev-direct-io-back-to-2619-version.patch
> scsi-sd-udev-accessing-an-uninitialized-scsi_disk-results-in-a-crash.patch
> altix-more-acpi-prt-support.patch

Would you forward the x86-64 dma_noncoherent API build fix I posted? 
Anything that uses that API won't build on x86-64 without my [simple and 
obvious] patch.


> - I have r8169-fix-a-race-between-pci-probe-and-dev_open.patch floating
>   about, but I forget its status.  

I posted a preferred patch (which someone then noted need to use 
setup_timer), and am waiting for an "it works" response of some sort

	Jeff


