Return-Path: <linux-kernel-owner+w=401wt.eu-S1757484AbYGUGId@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757484AbYGUGId (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 02:08:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750825AbYGUGIY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 02:08:24 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:52794 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750803AbYGUGIX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 02:08:23 -0400
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
In-Reply-To: <20080721055459.GD24246@parisc-linux.org>
References: <1216592500.3679.14.camel@jaswinder.satnam>
	 <20080721002837.GA3851@martell.zuzino.mipt.ru>
	 <1216619100.2705.27.camel@jaswinder.satnam>
	 <20080721055459.GD24246@parisc-linux.org>
Content-Type: text/plain; charset=utf8
Date: Mon, 21 Jul 2008 11:37:14 +0530
Message-Id: <1216620434.2705.38.camel@jaswinder.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Matthew,

On Sun, 2008-07-20 at 23:55 -0600, Matthew Wilcox wrote:

> I think it makes more sense to add them to linux/syscall.h, possibly
> with comments mentioning which architectures implement them.
> 
> If there are architectures with different prototypes for the same
> syscall, using an ifdef CONFIG_(arch) is /better/ annotation that having
> them in different header files.
> 

﻿linux/syscalls.h is Linux syscall interfaces (non-arch-specific)

So asm/syscalls.h is ﻿Linux syscall interfaces (arch-specific)

And if we add all arch dependent syscalls.h in linux/syscalls then it
will be very complex and do not look nice, for example sys_fork is keep
on changing for many architecture.

Thank you,

Jaswinder Singh.

