Return-Path: <linux-kernel-owner+w=401wt.eu-S1759507AbXG2Awq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759507AbXG2Awq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jul 2007 20:52:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758313AbXG2Awi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jul 2007 20:52:38 -0400
Received: from ozlabs.org ([203.10.76.45]:40777 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757293AbXG2Awh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jul 2007 20:52:37 -0400
Subject: Re: [PATCH] Fix lguest bzImage loading with CONFIG_RELOCATABLE=y
From: Rusty Russell <rusty@rustcorp.com.au>
To: Andi Kleen <andi@firstfloor.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, lguest <lguest@ozlabs.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <p73wswmqg4o.fsf@bingen.suse.de>
References: <1185507343.12151.25.camel@localhost.localdomain>
	 <p73wswmqg4o.fsf@bingen.suse.de>
Content-Type: text/plain
Date: Sun, 29 Jul 2007 10:23:30 +1000
Message-Id: <1185668610.12151.72.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-07-27 at 12:45 +0200, Andi Kleen wrote:
> Rusty Russell <rusty@rustcorp.com.au> writes:
> 
> > Jason Yeh sent his crashing .config: bzImages made with
> > CONFIG_RELOCATABLE=y put the relocs where the BSS is expected, and we
> > crash with unusual results such as:
> 
> The normal kernel startup should already clear BSS. Why does
> this not work here? Can it be fixed?

Unfortunately, lguest doesn't go through the normal startup path (which
does this in asm).

Thanks,
Rusty.


