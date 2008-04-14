Return-Path: <linux-kernel-owner+w=401wt.eu-S1761348AbYDNPFz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761348AbYDNPFz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 11:05:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756371AbYDNPFr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 11:05:47 -0400
Received: from saraswathi.solana.com ([198.99.130.12]:48036 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753566AbYDNPFq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 11:05:46 -0400
Date: Mon, 14 Apr 2008 11:03:58 -0400
From: Jeff Dike <jdike@addtoit.com>
To: WANG Cong <xiyou.wangcong@gmail.com>
Cc: linux-kernel@vger.kernel.org, akpm@osdl.org,
       user-mode-linux-devel@lists.sourceforge.net
Subject: Re: [Patch] uml: compile error fix
Message-ID: <20080414150358.GD7186@c2.user-mode-linux.org>
References: <20080412.174733.133433510.xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080412.174733.133433510.xiyou.wangcong@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 12, 2008 at 05:47:33PM +0800, WANG Cong wrote:
> 
> This patch fixes this error:
> 
>   CC      arch/um/kernel/smp.o
> In file included from /home/wangcong/projects/linux-2.6/arch/um/kernel/smp.c:9:
> include2/asm/tlb.h: In function ‘tlb_remove_page’:
> include2/asm/tlb.h:101: error: implicit declaration of function ‘page_cache_release’
> make[2]: *** [arch/um/kernel/smp.o] Error 1
> make[1]: *** [arch/um/kernel] Error 2
> make: *** [sub-make] Error 2
> 
> And since including <linux/pagemap.h> in <linux/swap.h> will break sparc,
> we add this #include in uml's own header.

Sigh, ACK.

I took a stab at fixing this problem for real a while ago by
untangling the headers involved, but failed.

	       	       		 Jeff

-- 
Work email - jdike at linux dot intel dot com
