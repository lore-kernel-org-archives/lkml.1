Return-Path: <linux-kernel-owner+w=401wt.eu-S932783AbXF2Es0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932783AbXF2Es0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2007 00:48:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751455AbXF2EsQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jun 2007 00:48:16 -0400
Received: from ozlabs.org ([203.10.76.45]:53421 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751053AbXF2EsP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2007 00:48:15 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18052.36612.846937.794756@cargo.ozlabs.ibm.com>
Date: Fri, 29 Jun 2007 14:48:04 +1000
From: Paul Mackerras <paulus@samba.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       lkml <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Arch <linux-arch@vger.kernel.org>,
       Richard Henderson <rth@twiddle.net>, Ian Molton <spyro@f2s.com>,
       Russell King <rmk@arm.linux.org.uk>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>,
       Aubrey Li <aubrey.li@analog.com>, Mikael Starvik <starvik@axis.com>,
       David Howells <dhowells@redhat.com>,
       Yoshinori Sato <ysato@users.sourceforge.jp>, Andi Kleen <ak@suse.de>,
       Tony Luck <tony.luck@intel.com>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Ralf Baechle <ralf@linux-mips.org>, Matthew Wilcox <matthew@wil.cx>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Paul Mundt <lethal@linux-sh.org>,
       "David S. Miller" <davem@davemloft.net>,
       Miles Bader <uclinux-v850@lsi.nec.co.jp>,
       Chris Zankel <chris@zankel.net>
Subject: Re: [PATCH] cross-architecture ELF clean up
In-Reply-To: <20070620230902.387008536@goop.org>
References: <20070620230854.246399397@goop.org>
	<20070620230902.387008536@goop.org>
X-Mailer: VM 7.19 under Emacs 21.4.1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge writes:

> ===================================================================
> --- a/arch/powerpc/platforms/cell/io-workarounds.c
> +++ b/arch/powerpc/platforms/cell/io-workarounds.c
> @@ -9,6 +9,7 @@
>  #undef DEBUG
>  
>  #include <linux/kernel.h>
> +#include <linux/sched.h>

Why is this needed?  You've added #include <linux/sched.h> to 7 files
without explanation - and I can't see that you have removed a
corresponding #include from any header, have you?

Paul.


