Return-Path: <linux-kernel-owner+w=401wt.eu-S933803AbXGYSQh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933803AbXGYSQh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 14:16:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755064AbXGYSQZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 14:16:25 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:44196 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754247AbXGYSQY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 14:16:24 -0400
Date: Wed, 25 Jul 2007 20:15:57 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Andrew Morton <akpm@linux-foundation.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, Josh Triplett <josh@kernel.org>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: 2.6.23-rc1-mm1: net/ipv4/fib_trie.c compile error
Message-ID: <20070725181557.GF3572@stusta.de>
References: <20070725040304.111550f4.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070725040304.111550f4.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 25, 2007 at 04:03:04AM -0700, Andrew Morton wrote:
>...
> Changes since 2.6.22-rc6-mm1:
>...
> +immunize-rcu_dereference-against-crazy-compiler-writers.patch
>...
>  Misc new patches
>...

This patch causes the following compile error:

<--  snip  -->

...
  CC      net/ipv4/fib_trie.o
/home/bunk/linux/kernel-2.6/linux-2.6.23-rc1-mm1/net/ipv4/fib_trie.c: In function ‘trie_rebalance’:
/home/bunk/linux/kernel-2.6/linux-2.6.23-rc1-mm1/net/ipv4/fib_trie.c:969: error: lvalue required as unary ‘&’ operand
/home/bunk/linux/kernel-2.6/linux-2.6.23-rc1-mm1/net/ipv4/fib_trie.c:971: error: lvalue required as unary ‘&’ operand
/home/bunk/linux/kernel-2.6/linux-2.6.23-rc1-mm1/net/ipv4/fib_trie.c:977: error: lvalue required as unary ‘&’ operand
/home/bunk/linux/kernel-2.6/linux-2.6.23-rc1-mm1/net/ipv4/fib_trie.c:980: error: lvalue required as unary ‘&’ operand
...
make[3]: *** [net/ipv4/fib_trie.o] Error 1

<--  snip  -->


cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

