Return-Path: <linux-kernel-owner+w=401wt.eu-S1762755AbXKTXdT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762755AbXKTXdT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 18:33:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752507AbXKTXdL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 18:33:11 -0500
Received: from terminus.zytor.com ([198.137.202.10]:37059 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751905AbXKTXdK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 18:33:10 -0500
Message-ID: <47436DAD.1030109@zytor.com>
Date: Tue, 20 Nov 2007 15:28:45 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Mark Lord <lkml@rtr.ca>
CC: Ingo Molnar <mingo@elte.hu>, Arjan van de Ven <arjan@infradead.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@osdl.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: CONFIG_IRQBALANCE for 64-bit x86 ?
References: <47425EA5.7000607@rtr.ca> <200711201517.16171.nickpiggin@yahoo.com.au> <20071119213727.16d5917b@laptopd505.fenrus.org> <200711201837.39664.nickpiggin@yahoo.com.au> <20071120064747.2a8036cd@laptopd505.fenrus.org> <20071120220110.GF24156@elte.hu> <47436C43.6010200@rtr.ca>
In-Reply-To: <47436C43.6010200@rtr.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Lord wrote:
> 
> Perhaps, but this also violates the principle that the kernel
> should just *work* with sensible defaults.  I don't use an initrd,
> or an initramfs, and have no intention of ever doing so.
> 
> I *like* having a single boot image with no unneeded/unwanted complexity.
> It's only recently that I've even come round to using some loadable
> modules for things like network drivers -- I prefer a single image
> for as much as possible (like Linus there).
> 
> If putting a C-library and utilities "into the kernel" still leaves
> me with a single image file, then.. maybe.  Seems clumsy, though.
> 

That was the whole point of klibc, and in fact it was in -mm that way 
for a while.  Linus rejected it at the time on the grounds that it added 
no new features, only moved existing features to userspace.

The unified build tree has since then bitrotted slightly due to lack of 
time on my part, but it wouldn't be hard at all to bring it up to current.

	-hpa
