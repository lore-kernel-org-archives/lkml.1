Return-Path: <linux-kernel-owner+w=401wt.eu-S1760731AbYGUFz1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760731AbYGUFz1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 01:55:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754186AbYGUFzT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 01:55:19 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:52948 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753524AbYGUFzS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 01:55:18 -0400
Date: Sun, 20 Jul 2008 23:55:00 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Jaswinder Singh <jaswinder@infradead.org>
Cc: Alexey Dobriyan <adobriyan@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, kernelnewbies <kernelnewbies@nl.linux.org>,
       David Woodhouse <dwmw2@infradead.org>, rth@twiddle.net,
       rmk@arm.linux.org.uk, hskinnemoen@atmel.com, cooloney@kernel.org,
       starvik@axis.com, dhowells@redhat.com, ysato@users.sourceforge.jp,
       tony.luck@intel.com, takata@linux-m32r.org, geert@linux-m68k.org,
       ralf@linux-mips.org, schwidefsky@de.ibm.com, lethal@linux-sh.org,
       chris@zankel.net
Subject: Re: [PATCH 0/22] Introducing asm/syscalls.h
Message-ID: <20080721055459.GD24246@parisc-linux.org>
References: <1216592500.3679.14.camel@jaswinder.satnam> <20080721002837.GA3851@martell.zuzino.mipt.ru> <1216619100.2705.27.camel@jaswinder.satnam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1216619100.2705.27.camel@jaswinder.satnam>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 21, 2008 at 11:15:00AM +0530, Jaswinder Singh wrote:
> It may be useless for you but it looks useful for me.
> If you go though all syscalls patches only then you will figure it out
> syscalls are moving in many files for many architecture.
> 
> There can be many reasons to add syscalls.h, few of them are :-
> 1. Declaring syscalls functions before they get used is a nice habit and
> will quite also quiet sparse.
> 
> 2. Declaring all arch dependent syscalls under one roof is nice for
> future enhancement for kernel developers as they can see what is defined
> in other architectures and try to follow same prototype as far as
> possible, Then it will be really useful for everyone. And then we can
> move common arch dependent syscalls in one place.
> 
> 3. ???Declaring all arch dependent syscalls under one roof is nice for
> user for reference purpose.

I think it makes more sense to add them to linux/syscall.h, possibly
with comments mentioning which architectures implement them.

If there are architectures with different prototypes for the same
syscall, using an ifdef CONFIG_(arch) is /better/ annotation that having
them in different header files.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
