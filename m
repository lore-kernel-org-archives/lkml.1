Return-Path: <linux-kernel-owner+w=401wt.eu-S1754513AbYGRGRg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754513AbYGRGRg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 02:17:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752307AbYGRGR2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 02:17:28 -0400
Received: from winston.telenet-ops.be ([195.130.137.75]:39059 "EHLO
	winston.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751709AbYGRGR1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 02:17:27 -0400
Date: Fri, 18 Jul 2008 08:17:23 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Denys Vlasenko <vda.linux@googlemail.com>
cc: Andrew Morton <akpm@linux-foundation.org>, mingo@elte.hu, x86@kernel.org,
       James Bottomley <James.Bottomley@hansenpartnership.com>,
       Russell King <rmk@arm.linux.org.uk>,
       David Howells <dhowells@redhat.com>, Ralf Baechle <ralf@linux-mips.org>,
       Lennert Buytenhek <kernel@wantstofly.org>,
       Josh Boyer <jwboyer@linux.vnet.ibm.com>,
       Paul Mackerras <paulus@samba.org>,
       David Woodhouse <dwmw2@infradead.org>, Andi Kleen <andi@firstfloor.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Paul Gortmaker <paul.gortmaker@windriver.com>,
       linux-embedded@vger.kernel.org,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       Tim Bird <tim.bird@am.sony.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Dave Miller <davem@davemloft.net>
Subject: Re: [PATCH] (updated, rolled up) make section names compatible with
 -ffunction-sections -fdata-sections
In-Reply-To: <200807172213.37411.vda.linux@googlemail.com>
Message-ID: <Pine.LNX.4.64.0807180816550.20605@anakin>
References: <200807172213.37411.vda.linux@googlemail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Jul 2008, Denys Vlasenko wrote:
> Here is the update against current Linus tree,
> rolled up into one patch.
> 
> James Bottomley suggested a different naming scheme:
> instead of swapping parts (.text.head -> .head.text),
> prepend .kernel to our special section names.
> This patch implements his idea.

Why not '.linux'?

> ppc and v850 are dropped per comments from arch people.
> parisc and x86 had minor fixes. x86 fix added proper
> executable bits to a section:
> 
> -.section ".text.head"
> +.section ".kernel.text.head","ax",@progbits
> 
> Does arch/m68k/kernel/sun3-head.S need the same fix?

Sure, why not?

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
