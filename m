Return-Path: <linux-kernel-owner+w=401wt.eu-S1756761AbYBILVp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756761AbYBILVp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2008 06:21:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753160AbYBILVf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Feb 2008 06:21:35 -0500
Received: from www.tglx.de ([62.245.132.106]:56295 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751132AbYBILVe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2008 06:21:34 -0500
Date: Sat, 9 Feb 2008 12:21:13 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Alexey Dobriyan <adobriyan@gmail.com>
cc: mingo@elte.hu, arjan@infradead.org, linux-kernel@vger.kernel.org
Subject: Re: CPA spam in dmesg (no pte level 0)
In-Reply-To: <20080208213121.GC15571@martell.zuzino.mipt.ru>
Message-ID: <alpine.LFD.1.00.0802091217440.3145@apollo.tec.linutronix.de>
References: <20080208213121.GC15571@martell.zuzino.mipt.ru>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 9 Feb 2008, Alexey Dobriyan wrote:

> I enabled pretty much all debugging on
> 2.6.24-0cf975e16927fd70f34cee20d3856246c13bb4c8 and CPA code
> continuosly spams dmesg like this:
> 
> [   24.100000] CPA ffff810080000000 no pte level 0
> [   24.520000] PGD 8063 PUD 0
> [   24.520000] CPA ffff810080000000 no pte level 0
> [   24.540000] PGD 8063 PUD 0
> 
> This is E6400 box with 4G of RAM, x86_64 is used.
> dmesg and .config below:

Hmm, that's the self test code. The PUD is 0 (i guess it's a memory
hole) and it complains loudly about that. This printk is pretty
useless, will remove it.

Thanks,
	tglx


