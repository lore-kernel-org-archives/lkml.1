Return-Path: <linux-kernel-owner+w=401wt.eu-S1753945AbYGEPRl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753945AbYGEPRl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2008 11:17:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751400AbYGEPRe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jul 2008 11:17:34 -0400
Received: from casper.infradead.org ([85.118.1.10]:56550 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751187AbYGEPRe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2008 11:17:34 -0400
Date: Sat, 5 Jul 2008 08:17:37 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: "Gavin Shan" <gshan@alcatel-lucent.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: Re: Tough Issue: kernel instruction corruption
Message-ID: <20080705081737.5bc17450@infradead.org>
In-Reply-To: <008101c8deaa$52cf19d0$01fca8c0@microsof60b8d6>
References: <008101c8deaa$52cf19d0$01fca8c0@microsof60b8d6>
Organization: Intel
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.10; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 5 Jul 2008 22:20:46 +0800
"Gavin Shan" <gshan@alcatel-lucent.com> wrote:

> Hello, I'm faced a tough issue recently: instructions of kernel
> were corrupted. There has 2 PCI buses on my board and lots
> of PCI devices with DMA capabality involved. I'm suspecting
> the kernel instructions were corrupted by DMA operations driving
> by those PCI devices with DMA capabality. 
> 
> Anybody have tried to protect kernel instructions from this case
> or have any ideas to protect kernel text section?

if you have a modern Intel board, you can enable the IOMMU on it that
will protect the kernel text (well, all of memory) from rogue DMA.
PPC generally has similar capabilities, as do some IBM x86 chipsets.

Without an IOMMU it's basically impossible to protect against such DMA.

-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
