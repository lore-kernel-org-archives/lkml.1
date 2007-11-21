Return-Path: <linux-kernel-owner+w=401wt.eu-S1754255AbXKUDEw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754255AbXKUDEw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 22:04:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751892AbXKUDEn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 22:04:43 -0500
Received: from terminus.zytor.com ([198.137.202.10]:51779 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751555AbXKUDEm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 22:04:42 -0500
Message-ID: <47439EF8.9080600@zytor.com>
Date: Tue, 20 Nov 2007 18:59:04 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>
CC: Ingo Molnar <mingo@elte.hu>, Mark Lord <lkml@rtr.ca>,
       Arjan van de Ven <arjan@infradead.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@osdl.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: CONFIG_IRQBALANCE for 64-bit x86 ?
References: <200711201837.39664.nickpiggin@yahoo.com.au> <20071120064747.2a8036cd@laptopd505.fenrus.org> <20071120220110.GF24156@elte.hu> <47436C43.6010200@rtr.ca> <20071120232723.GB23667@elte.hu> <47436ECD.3050004@zytor.com> <20071120234725.GH23667@elte.hu> <474372BC.2000609@zytor.com> <20071121000742.GN23667@elte.hu> <474379C1.2040703@zytor.com> <20071121003629.GA20765@elte.hu> <47439C77.7070805@garzik.org>
In-Reply-To: <47439C77.7070805@garzik.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik wrote:
> 
> Take a look at usr/Makefile for how initramfs is automatically included 
> in the image, right now.
> 
> The intention at the time was to quickly follow up this stub (generated 
> by gen_init_cpio) with a full inclusion of klibc + some basics like 
> nfsroot.  It should be a very straightforward step to go from what we 
> have today to including klibc initramfs into the kernel image.
> 

http://git.kernel.org/?p=linux/kernel/git/hpa/linux-2.6-klibc.git;a=summary

	-hpa
