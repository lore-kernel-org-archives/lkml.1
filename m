Return-Path: <linux-kernel-owner+w=401wt.eu-S1758264AbYGUGRW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758264AbYGUGRW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 02:17:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754283AbYGUGRN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 02:17:13 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:54852 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750954AbYGUGRN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 02:17:13 -0400
Date: Mon, 21 Jul 2008 00:16:55 -0600
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
Message-ID: <20080721061655.GE24246@parisc-linux.org>
References: <1216592500.3679.14.camel@jaswinder.satnam> <20080721002837.GA3851@martell.zuzino.mipt.ru> <1216619100.2705.27.camel@jaswinder.satnam> <20080721055459.GD24246@parisc-linux.org> <1216620434.2705.38.camel@jaswinder.satnam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1216620434.2705.38.camel@jaswinder.satnam>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 21, 2008 at 11:37:14AM +0530, Jaswinder Singh wrote:
> ???linux/syscalls.h is Linux syscall interfaces (non-arch-specific)
> 
> So asm/syscalls.h is ???Linux syscall interfaces (arch-specific)

That's how you see it.

> And if we add all arch dependent syscalls.h in linux/syscalls then it
> will be very complex and do not look nice, for example sys_fork is keep
> on changing for many architecture.

sys_fork() does seem to be the worst case scenario.  I suspect there's
similar ones (clone?).  I still think it's worth adding them all to
linux/syscalls.h.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
