Return-Path: <linux-kernel-owner+w=401wt.eu-S1758639AbYGUHBW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758639AbYGUHBW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 03:01:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755739AbYGUHBO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 03:01:14 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:38579 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750825AbYGUHBN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 03:01:13 -0400
Subject: Re: [PATCH 0/22] Introducing asm/syscalls.h
From: Jaswinder Singh <jaswinder@infradead.org>
To: Matthew Wilcox <matthew@wil.cx>
Cc: Alexey Dobriyan <adobriyan@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, kernelnewbies <kernelnewbies@nl.linux.org>,
       David Woodhouse <dwmw2@infradead.org>, rth@twiddle.net,
       rmk@arm.linux.org.uk, hskinnemoen@atmel.com, cooloney@kernel.org,
       starvik@axis.com, dhowells@redhat.com, ysato@users.sourceforge.jp,
       tony.luck@intel.com, takata@linux-m32r.org, geert@linux-m68k.org,
       ralf@linux-mips.org, schwidefsky@de.ibm.com, lethal@linux-sh.org,
       chris@zankel.net
In-Reply-To: <20080721061655.GE24246@parisc-linux.org>
References: <1216592500.3679.14.camel@jaswinder.satnam>
	 <20080721002837.GA3851@martell.zuzino.mipt.ru>
	 <1216619100.2705.27.camel@jaswinder.satnam>
	 <20080721055459.GD24246@parisc-linux.org>
	 <1216620434.2705.38.camel@jaswinder.satnam>
	 <20080721061655.GE24246@parisc-linux.org>
Content-Type: text/plain
Date: Mon, 21 Jul 2008 12:29:59 +0530
Message-Id: <1216623599.2744.9.camel@jaswinder.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Matthew,

On Mon, 2008-07-21 at 00:16 -0600, Matthew Wilcox wrote:

> sys_fork() does seem to be the worst case scenario.  I suspect there's
> similar ones (clone?).  I still think it's worth adding them all to
> linux/syscalls.h.
> 

I tried my best to make things simpler. I also tried this in :- 
[PATCH 17/22] sh: Introducing asm/syscalls.h
[PATCH 21/22] x86: Introducing asm/syscalls.h

For same architecture it looks complex for 32 and 64 bit.

You can Imagine how linux/syscalls.h will look if we add all
architectures in it.

And you can imagine what will be size of linux/syscalls.h. As more than
60% of arch dependent syscalls have totally different prototypes.

Thank you,

Jaswinder Singh.




