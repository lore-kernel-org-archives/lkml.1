Return-Path: <linux-kernel-owner+w=401wt.eu-S1757383AbYJXRzW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757383AbYJXRzW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 13:55:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752240AbYJXRzK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 13:55:10 -0400
Received: from waste.org ([66.93.16.53]:51739 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751864AbYJXRzJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 13:55:09 -0400
Subject: Re: Linux 2.6.28-rc1
From: Matt Mackall <mpm@selenic.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Fenghua Yu <fenghua.yu@intel.com>,
       David Woodhouse <dwmw2@infradead.org>
In-Reply-To: <1224868194.3248.13.camel@calx>
References: <alpine.LFD.2.00.0810232028500.3287@nehalem.linux-foundation.org>
	 <1224868194.3248.13.camel@calx>
Content-Type: text/plain
Date: Fri, 24 Oct 2008 12:54:32 -0500
Message-Id: <1224870872.3248.20.camel@calx>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-10-24 at 12:10 -0500, Matt Mackall wrote:
> On Thu, 2008-10-23 at 21:10 -0700, Linus Torvalds wrote:
> > It's been two weeks, so it's time to close the merge window. A 2.6.28-rc1 
> > is out there, and it's hopefully all good.
> 
> This fails building on allnoconfig on at least x86-64 because forbid_dac
> used by arch/x86/kernel/pci-dma.c is defined off in
> drivers/pci/quirks.c, which isn't built if CONFIG_PCI isn't set.

(Also fails on x86-32)

Bisection points to: 

5b6985ce8ec7127b4d60ad450b64ca8b82748a3b
intel-iommu: IA64 support

-- 
Mathematics is the supreme nostalgia of our time.

