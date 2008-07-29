Return-Path: <linux-kernel-owner+w=401wt.eu-S1754047AbYG2AGk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754047AbYG2AGk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 20:06:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752426AbYG2AGc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 20:06:32 -0400
Received: from mta23.gyao.ne.jp ([125.63.38.249]:36455 "EHLO mx.gate01.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752077AbYG2AGb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 20:06:31 -0400
Date: Tue, 29 Jul 2008 09:05:47 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Adrian Bunk <bunk@kernel.org>
Cc: Andi Kleen <ak@suse.de>, Nick Piggin <npiggin@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>, wli@holomorphy.com,
       linux-kernel@vger.kernel.org, linux-sh@vger.kernel.org
Subject: Re: [2.6 patch] mm/hugetlb.c must #include <asm/io.h>
Message-ID: <20080729000547.GF28055@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Adrian Bunk <bunk@kernel.org>, Andi Kleen <ak@suse.de>,
	Nick Piggin <npiggin@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>, wli@holomorphy.com,
	linux-kernel@vger.kernel.org, linux-sh@vger.kernel.org
References: <20080727130438.GJ9301@cs181140183.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080727130438.GJ9301@cs181140183.pp.htv.fi>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 27, 2008 at 04:04:38PM +0300, Adrian Bunk wrote:
> This patch fixes the following build error on sh caused by
> commit aa888a74977a8f2120ae9332376e179c39a6b07d
> (hugetlb: support larger than MAX_ORDER):
> 
> <--  snip  -->
> 
> ...
>   CC      mm/hugetlb.o
> /home/bunk/linux/kernel-2.6/git/linux-2.6/mm/hugetlb.c: In function 'alloc_bootmem_huge_page':
> /home/bunk/linux/kernel-2.6/git/linux-2.6/mm/hugetlb.c:958: error: implicit declaration of function 'virt_to_phys'
> make[2]: *** [mm/hugetlb.o] Error 1
> 
> <--  snip  -->
> 
> Reported-by: Adrian Bunk <bunk@kernel.org>
> Signed-off-by: Adrian Bunk <bunk@kernel.org>
> 
Acked-by: Paul Mundt <lethal@linux-sh.org>
