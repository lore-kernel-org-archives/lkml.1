Return-Path: <linux-kernel-owner+w=401wt.eu-S1753927AbXKUCt2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753927AbXKUCt2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 21:49:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751555AbXKUCtU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 21:49:20 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:37461 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751548AbXKUCtT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 21:49:19 -0500
Message-ID: <47439C77.7070805@garzik.org>
Date: Tue, 20 Nov 2007 21:48:23 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: "H. Peter Anvin" <hpa@zytor.com>, Mark Lord <lkml@rtr.ca>,
       Arjan van de Ven <arjan@infradead.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@osdl.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: CONFIG_IRQBALANCE for 64-bit x86 ?
References: <200711201837.39664.nickpiggin@yahoo.com.au> <20071120064747.2a8036cd@laptopd505.fenrus.org> <20071120220110.GF24156@elte.hu> <47436C43.6010200@rtr.ca> <20071120232723.GB23667@elte.hu> <47436ECD.3050004@zytor.com> <20071120234725.GH23667@elte.hu> <474372BC.2000609@zytor.com> <20071121000742.GN23667@elte.hu> <474379C1.2040703@zytor.com> <20071121003629.GA20765@elte.hu>
In-Reply-To: <20071121003629.GA20765@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> single-bzImage initrd 
> was and is possible,

Correct (though s/initrd/initramfs/).

Take a look at usr/Makefile for how initramfs is automatically included 
in the image, right now.

The intention at the time was to quickly follow up this stub (generated 
by gen_init_cpio) with a full inclusion of klibc + some basics like 
nfsroot.  It should be a very straightforward step to go from what we 
have today to including klibc initramfs into the kernel image.


>  so we could in fact move chunks of system-related 
> userland (such as irqbalanced) into the kernel proper?

s/kernel/kernel tree/ I presume you mean...

With regards to irqbalanced, if you are thinking about including it in 
initramfs, you would need to work out the details of how 
userland/distros modify the default policy configurations.

	Jeff



