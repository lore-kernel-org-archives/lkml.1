Return-Path: <linux-kernel-owner+w=401wt.eu-S1755660AbXKJWfA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755660AbXKJWfA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Nov 2007 17:35:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754860AbXKJWex
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Nov 2007 17:34:53 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:43465 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754856AbXKJWew (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Nov 2007 17:34:52 -0500
Date: Sat, 10 Nov 2007 14:33:02 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Jeff Garzik <jeff@garzik.org>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 0/5] introduce K64BIT=y and backward compatibility
 ARCH={i386,x86_64} for x86
Message-Id: <20071110143302.73b571d6.randy.dunlap@oracle.com>
In-Reply-To: <20071110204038.GA13140@uranus.ravnborg.org>
References: <20071110204038.GA13140@uranus.ravnborg.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.6 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 10 Nov 2007 21:40:38 +0100 Sam Ravnborg wrote:

> As discussed in another thread the right thing is to add a generic solution
> to select between 32 and 64 bit - useable for powerpc, s390, ppc et al.
> 
> First step was to teach kconfig how to force 64BIT to a specific value.
> The x86 Kconfig file needed a small twist to use 64BIT as the symbol
> to seelct 32 or 64 bit.
> Then it was simple to add backward compatibility ARCH= settings.
> 
> The patchset is not yet pushed out - I will await a bit feedback first.
> 
> Shortlog and diffstat.
>       kconfig: factor out code in confdata.c
>       kconfig: use $K64BIT to set 64BIT with all*config targets
>       x86: Use CONFIG_64BIT to select between 32 and 64 bit in Kconfig
>       kconfig: document make K64BIT=y in README
>       x86: introduce ARCH=i386,ARCH=x86_64 to select 32/64 bit

Hi Sam,
Looks good to me and should satisfy our habits^w usages models.

The one minor question is the environment variable name (K64BIT or
something else, like Guillaume brought up).  Personally I don't
care how it's spelled.  IOW, K64BIT is sufficient, but if there is a
goal to be able to place any CONFIG_symbol on the command line or
as an env. variable, they might as well all be named with CONFIG_*.

Thanks,
---
~Randy
