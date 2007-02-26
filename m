Return-Path: <linux-kernel-owner+w=401wt.eu-S1161411AbXBZXns@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161411AbXBZXns (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 18:43:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161412AbXBZXns
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 18:43:48 -0500
Received: from ozlabs.org ([203.10.76.45]:56287 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161411AbXBZXnr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 18:43:47 -0500
Subject: Re: [-mm patch] LGUEST must depend on NET
From: Rusty Russell <rusty@rustcorp.com.au>
To: Adrian Bunk <bunk@stusta.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
In-Reply-To: <20070226222336.GC29575@stusta.de>
References: <20070217215146.30e7ffa3.akpm@linux-foundation.org>
	 <20070226222336.GC29575@stusta.de>
Content-Type: text/plain
Date: Tue, 27 Feb 2007 10:42:57 +1100
Message-Id: <1172533377.13541.61.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-02-26 at 23:23 +0100, Adrian Bunk wrote:
> CONFIG_LGUEST=y, CONFIG_NET=n results in the following compile error:
> 
> <--  snip  -->
> 
> ...
>   LD      .tmp_vmlinux1
> drivers/built-in.o: In function `lguestnet_close':
> lguest_net.c:(.text+0x3b8de): undefined reference to `kfree_skb'
> drivers/built-in.o: In function `fill_slot':
> lguest_net.c:(.text+0x3ba08): undefined reference to `__alloc_skb'
> drivers/built-in.o: In function `lguestnet_open':
> lguest_net.c:(.text+0x3bada): undefined reference to `kfree_skb'
> drivers/built-in.o: In function `lguestnet_start_xmit':
> lguest_net.c:(.text+0x3bc03): undefined reference to `kfree_skb'
> drivers/built-in.o: In function `lguestnet_rcv':
> lguest_net.c:(.text+0x3bc61): undefined reference to `kfree_skb'
> lguest_net.c:(.text+0x3bc6c): undefined reference to `skb_put'
> lguest_net.c:(.text+0x3bc76): undefined reference to `eth_type_trans'
> lguest_net.c:(.text+0x3bc94): undefined reference to `netif_rx'
> drivers/built-in.o: In function `lguestnet_probe':
> lguest_net.c:(.text+0x3bcdb): undefined reference to `alloc_etherdev'
> lguest_net.c:(.text+0x3bcea): undefined reference to `ether_setup'
> lguest_net.c:(.text+0x3bdc1): undefined reference to `register_netdev'
> lguest_net.c:(.text+0x3be10): undefined reference to `unregister_netdev'
> lguest_net.c:(.text+0x3be17): undefined reference to `free_netdev'
> make[1]: *** [.tmp_vmlinux1] Error 1
> 
> <--  snip  -->
> 
> Signed-off-by: Adrian Bunk <bunk@stusta.de>

Thanks Adrian, good catch!

Rusty.


