Return-Path: <linux-kernel-owner+w=401wt.eu-S1752791AbYJFIse@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752791AbYJFIse (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 04:48:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751833AbYJFIsZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 04:48:25 -0400
Received: from nelson.telenet-ops.be ([195.130.133.66]:39645 "EHLO
	nelson.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751821AbYJFIsZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 04:48:25 -0400
Date: Mon, 6 Oct 2008 10:48:22 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Huang Ying <ying.huang@intel.com>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm -v3] Separate atomic_t declaration from asm/atomic.h
 into asm/atomic_def.h
In-Reply-To: <1223263964.5872.20.camel@yhuang-dev.sh.intel.com>
Message-ID: <Pine.LNX.4.64.0810061047440.5594@anakin>
References: <1223263964.5872.20.camel@yhuang-dev.sh.intel.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 6 Oct 2008, Huang Ying wrote:
> From: Huang Ying <ying.huang@intel.com>
> 
> asm/atomic.h contains both declaration and implementation of atomic_t.  So
> there are some implementation related files included in asm/atomic.h.  And
> atomic_t is a typedef.  Combination of above makes it impossible to use
> atomic_t in files included by atomic.h.  Such as atomic_t can not be used
> in linux/kernel.h on i386, because it is included by asm/atomic.h.
> 
> It is reasonable to separate declaration from implementation.  So a new
> file atomic_def.h is added for every architecture to accommodate the
> declaration of atomic_t.

And how many of these atomic_def.h are identical?
asm-generic?

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
