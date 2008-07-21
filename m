Return-Path: <linux-kernel-owner+w=401wt.eu-S1758612AbYGUFqX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758612AbYGUFqX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 01:46:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751863AbYGUFqP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 01:46:15 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:43351 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751796AbYGUFqO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 01:46:14 -0400
Subject: Re: [PATCH 0/22] Introducing asm/syscalls.h
From: Jaswinder Singh <jaswinder@infradead.org>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       kernelnewbies <kernelnewbies@nl.linux.org>,
       David Woodhouse <dwmw2@infradead.org>, rth@twiddle.net,
       rmk@arm.linux.org.uk, hskinnemoen@atmel.com, cooloney@kernel.org,
       starvik@axis.com, dhowells@redhat.com, ysato@users.sourceforge.jp,
       tony.luck@intel.com, takata@linux-m32r.org, geert@linux-m68k.org,
       ralf@linux-mips.org, matthew@wil.cx, schwidefsky@de.ibm.com,
       lethal@linux-sh.org, chris@zankel.net
In-Reply-To: <20080721002837.GA3851@martell.zuzino.mipt.ru>
References: <1216592500.3679.14.camel@jaswinder.satnam>
	 <20080721002837.GA3851@martell.zuzino.mipt.ru>
Content-Type: text/plain; charset=utf8
Date: Mon, 21 Jul 2008 11:15:00 +0530
Message-Id: <1216619100.2705.27.camel@jaswinder.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Alexey,

On Mon, 2008-07-21 at 04:28 +0400, Alexey Dobriyan wrote:
> On Mon, Jul 21, 2008 at 03:51:40AM +0530, Jaswinder Singh wrote:
> > The following series of patches introduce asm/syscalls.h in various
> > architectures.
> 
> Copyright for a bunch of prototypes?
> 

﻿So according to you, there _should_ be no copyright for header files.
If this is the case, then remove it, I have no objections :)

> All those /* kernel/signal.c */ comments are generally stupid and
> useless, so no point adding even for functions that rarely move
> (syscalls).
> 
> Of course, there is no explanation why files are being added.
> 

It may be useless for you but it looks useful for me.
If you go though all syscalls patches only then you will figure it out
syscalls are moving in many files for many architecture.

There can be many reasons to add syscalls.h, few of them are :-
1. Declaring syscalls functions before they get used is a nice habit and
will quite also quiet sparse.

2. Declaring all arch dependent syscalls under one roof is nice for
future enhancement for kernel developers as they can see what is defined
in other architectures and try to follow same prototype as far as
possible, Then it will be really useful for everyone. And then we can
move common arch dependent syscalls in one place.

3. ﻿Declaring all arch dependent syscalls under one roof is nice for
user for reference purpose.

Thank you,

Jaswinder Singh.

