Return-Path: <linux-kernel-owner+w=401wt.eu-S1762125AbXGJVHA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762125AbXGJVHA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 17:07:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758308AbXGJVGy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 17:06:54 -0400
Received: from asia.telenet-ops.be ([195.130.137.74]:53524 "EHLO
	asia.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757608AbXGJVGx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 17:06:53 -0400
Date: Tue, 10 Jul 2007 23:06:50 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: avoiding rejects
In-Reply-To: <20070710124422.a52b0458.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0707102306030.10340@anakin>
References: <20070710124422.a52b0458.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Jul 2007, Andrew Morton wrote:
> There are many situations where patching the kernel involves adding a new
> item to a list, such as:
> 
> - adding a makefile line
> - adding a new #include
> - adding a new Kconfig entry
> - adding a new PCI ID
> - adding a record to feature-removal.txt
> - adding a new sysctl table entry
> - etc
> 
> Of course, everyone just sticks the new entry at the end of the existing
> entries.  This strategy carefully maximises the opportunity for patch
> rejects and leads to unhappiness.
> 
> Most of these lists are unordered anyway, so inserting the new item at a
> randomly-chosen position is a better approach than just appending it.

Really?

#includes should be sorted alphabetically
Lots of other stuff should be sorted numerically/alphabetically

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
