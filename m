Return-Path: <linux-kernel-owner+w=401wt.eu-S1758116AbXIQVXI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758116AbXIQVXI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 17:23:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759473AbXIQVWu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 17:22:50 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:41165 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759408AbXIQVWt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 17:22:49 -0400
Date: Mon, 17 Sep 2007 23:22:57 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Oliver Falk <oliver@linux-kernel.at>, Richard Henderson <rth@twiddle.net>
Cc: linux-kernel@vger.kernel.org, axp-list@redhat.com,
       Jay Estabrook <jay.estabrook@hp.com>, ac-admin@lists.anotherbloody.com,
       ink@jurassic.park.msu.ru
Subject: Re: 2.6.23 alpha unistd.h changes
Message-ID: <20070917212257.GA27980@stusta.de>
References: <46EEE483.4020209@linux-kernel.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <46EEE483.4020209@linux-kernel.at>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 17, 2007 at 10:33:07PM +0200, Oliver Falk wrote:
> Hi!

Hi Oliver!

> At Alphacore we used to patch the kernel headers for a while now; We
> added syscalls __NR_openat (447) until __NR_tee (466).

Why did your numbers differ from the numbers that were used in the 
upstream kernel?

The Alpha maintainers (Cc's added) might now better what happened here.

> However, since 2.6.23 these syscall where added upstream, but with
> different syscall numbers; What happens is the following:
>...

These syscalls were added in 2.6.22, not 2.6.23, and are therefore in 
the officially released kernel since more than two months.

Changing a userspace ABI that has already been part of an officially 
released kernel because someone patched other syscall numbers into his 
private kernel doesn't sound like a good solution.

> Best,
>  Oliver

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

