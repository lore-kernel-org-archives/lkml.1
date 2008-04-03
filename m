Return-Path: <linux-kernel-owner+w=401wt.eu-S1757777AbYDCNjg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757777AbYDCNjg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 09:39:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754379AbYDCNj2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 09:39:28 -0400
Received: from nelson.telenet-ops.be ([195.130.133.66]:55608 "EHLO
	nelson.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754284AbYDCNj1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 09:39:27 -0400
Date: Thu, 3 Apr 2008 15:39:16 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Johannes Weiner <hannes@saeurebad.de>
cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, mingo@elte.hu,
       davem@davemloft.net, hskinnemoen@atmel.com, cooloney@kernel.org,
       starvik@axis.com, dhowells@redhat.com, ysato@users.sourceforge.net,
       takata@linux-m32r.org, ralf@linux-mips.org, kyle@parisc-linux.org,
       paulus@samba.org, schwidefsky@de.ibm.com, lethal@linux-sh.org,
       jdike@addtoit.com, miles@gnu.org, chris@zankel.net,
       rmk@arm.linux.org.uk, tony.luck@intel.com
Subject: Re: [RFC 10/22] m68k: Use generic show_mem()
In-Reply-To: <87myobp02g.fsf@saeurebad.de>
Message-ID: <Pine.LNX.4.64.0804031538150.11898@anakin>
References: <12071688283927-git-send-email-hannes@saeurebad.de>
 <1207168941186-git-send-email-hannes@saeurebad.de> <Pine.LNX.4.64.0804030939320.9848@anakin>
 <87myobp02g.fsf@saeurebad.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 3 Apr 2008, Johannes Weiner wrote:
> Geert Uytterhoeven <geert@linux-m68k.org> writes:
> > The new version no longer prints
> >
> >> -	printk("Free swap:       %6ldkB\n", nr_swap_pages<<(PAGE_SHIFT-10));
> >
> 
> show_mem()
>  show_free_areas()
>   show_swap_cache_info()
>    printk("Free swap  = %lukB\n", nr_swap_pages << (PAGE_SHIFT - 10));
> 
> > and
> >
> >> -	printk("%d free pages\n",free);
> >
> > on m68k.
> 
> show_free_areas() prints global_page_state(NR_FREE_PAGES).  Isn't this
> the same?

Thanks, good to know...

So I suggest to add an additional (first) step to the consolidation: remove all
duplicates.

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
