Return-Path: <linux-kernel-owner+w=401wt.eu-S1757184AbZGHVQ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757184AbZGHVQ3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 17:16:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755019AbZGHVQW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 17:16:22 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:56652 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754986AbZGHVQW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 17:16:22 -0400
Date: Wed, 8 Jul 2009 22:13:21 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: Kevin Hilman <khilman@deeprootsystems.com>,
       David Howells <dhowells@redhat.com>, benh@kernel.crashing.org,
       paulus@samba.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com,
       jdike@addtoit.com, Ingo Molnar <mingo@elte.hu>,
       x86 maintainers <x86@kernel.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       David Miller <davem@davemloft.net>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       dbrownell@users.sourceforge.net, Greg KH <greg@kroah.com>,
       mchehab@infradead.org, jeremy@xensource.com, felixb@sgi.com,
       lenb@kernel.org, airlied@linux.ie, bcrl@kvack.org,
       Steven Rostedt <rostedt@goodmis.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Sam Ravnborg <sam@ravnborg.org>, LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 0/44] includecheck: fix multiple includes
Message-ID: <20090708211321.GA15928@flint.arm.linux.org.uk>
References: <1247063308.4382.12.camel@ht.satnam> <1247076059.4382.127.camel@ht.satnam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1247076059.4382.127.camel@ht.satnam>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 08, 2009 at 11:30:59PM +0530, Jaswinder Singh Rajput wrote:
> I am still waiting ACK/NAK for :
> 
>       includecheck fix: arm, misc.c
>       includecheck fix: arm, atomic.h
>       includecheck fix: arm, board-dm355-evm.c
>       includecheck fix: arm, board-dm355-leopard.c
>       includecheck fix: arm, board-dm644x-evm.c
>       includecheck fix: arm, board-dm646x-evm.c
>       includecheck fix: arm, board-sffsdr.c
>       includecheck fix: arm, mach-mx3/devices.c
>       includecheck fix: arm, mach-omap1/mcbsp.c
>       includecheck fix: arm, mach-omap2/mcbsp.c
>       includecheck fix: arm, plat-s3c64xx/pm.c
>       includecheck fix: arm, plat-stmp3xxx/pinmux.c

You're still waiting because apparantly you never sent this set anywhere
near any ARM people before.

For the first two, I'll ack them:

Acked-by: Russell King <rmk+kernel@arm.linux.org.uk>

The remainder look sane to me, but you'll have to seek acks from the
individual platform maintainer(s).

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
