Return-Path: <linux-kernel-owner+w=401wt.eu-S1756437AbYCTN0X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756437AbYCTN0X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2008 09:26:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754079AbYCTN0O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Mar 2008 09:26:14 -0400
Received: from verein.lst.de ([213.95.11.210]:45923 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754137AbYCTN0N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2008 09:26:13 -0400
Date: Thu, 20 Mar 2008 14:25:43 +0100
From: Christoph Hellwig <hch@lst.de>
To: rae l <crquan@gmail.com>
Cc: Pavel Machek <pavel@suse.cz>, David Miller <davem@davemloft.net>,
       Christoph Hellwig <hch@lst.de>, Dominik Brodowski <linux@brodo.de>,
       Adrian Bunk <bunk@stusta.de>, Arjan van de Ven <arjan@linux.intel.com>,
       Nick Piggin <npiggin@suse.de>, Len Brown <len.brown@intel.com>,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: many items in Documentation/feature-removal-schedule.txt have expired, please update
Message-ID: <20080320132543.GA11149@lst.de>
References: <91b13c310803200622k6a302851nc97774615f2ef3ee@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <91b13c310803200622k6a302851nc97774615f2ef3ee@mail.gmail.com>
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0 () 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 20, 2008 at 09:22:29PM +0800, rae l wrote:
> What:	old NCR53C9x driver
> When:	October 2007
> Why:	Replaced by the much better esp_scsi driver.  Actual low-level
> 	driver can be ported over almost trivially.
> Who:	David Miller <davem@davemloft.net>
> 	Christoph Hellwig <hch@lst.de>

This one is long gone, probably just needs a doc patch.

> 
> What:	remove EXPORT_SYMBOL(kernel_thread)
> When:	August 2006
> Files:	arch/*/kernel/*_ksyms.c
> Check:	kernel_thread
> Why:	kernel_thread is a low-level implementation detail.  Drivers should
>         use the <linux/kthread.h> API instead which shields them from
> 	implementation details and provides a higherlevel interface that
> 	prevents bugs and code duplication
> Who:	Christoph Hellwig <hch@lst.de>

We still have in-kernel users of this one.  Feel free to send a patch
to change it to "once the last in-tree user is gone"

