Return-Path: <linux-kernel-owner+w=401wt.eu-S1761513AbYDCHlS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761513AbYDCHlS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 03:41:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759581AbYDCHlG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 03:41:06 -0400
Received: from nelson.telenet-ops.be ([195.130.133.66]:49426 "EHLO
	nelson.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758976AbYDCHlF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 03:41:05 -0400
Date: Thu, 3 Apr 2008 09:40:50 +0200 (CEST)
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
In-Reply-To: <1207168941186-git-send-email-hannes@saeurebad.de>
Message-ID: <Pine.LNX.4.64.0804030939320.9848@anakin>
References: <12071688283927-git-send-email-hannes@saeurebad.de>
 <1207168941186-git-send-email-hannes@saeurebad.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The new version no longer prints

> -	printk("Free swap:       %6ldkB\n", nr_swap_pages<<(PAGE_SHIFT-10));

and

> -	printk("%d free pages\n",free);

on m68k.

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
