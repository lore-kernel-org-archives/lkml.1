Return-Path: <linux-kernel-owner+w=401wt.eu-S1764565AbXHVPbr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764565AbXHVPbr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 11:31:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761181AbXHVPbh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 11:31:37 -0400
Received: from nf-out-0910.google.com ([64.233.182.189]:8994 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760233AbXHVPbg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 11:31:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=VSss2vbV99b3ehasK4DBS+B7xo7dtp6D/V0FdOJN/9m32ofz1rv1Nyf6Tm6Mj2awH82QiqgxNOY4+NGeuX2LBdRqPK/457vfAacXLxS75feUzFjbIG7gCIABy1SHAq/cpp3e3oYBJsTrCZGxfa9UjvCiidLVyHlM9khBdtEr6h8=
Message-ID: <46CC5685.7090500@googlemail.com>
Date: Wed, 22 Aug 2007 17:30:13 +0200
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070803)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, netdev <netdev@vger.kernel.org>
Subject: net/ipv4/fib_trie.c - compile error (Re: 2.6.23-rc3-mm1)
References: <20070822020648.5ea3a612.akpm@linux-foundation.org>
In-Reply-To: <20070822020648.5ea3a612.akpm@linux-foundation.org>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Got it with a randconfig ( http://194.231.229.228/kernel/mm/2.6.23-rc3-mm1/r/randconfig-8 )

...

net/ipv4/fib_trie.c: In function 'trie_rebalance':
net/ipv4/fib_trie.c:969: error: lvalue required as unary '&' operand
net/ipv4/fib_trie.c:971: error: lvalue required as unary '&' operand
net/ipv4/fib_trie.c:977: error: lvalue required as unary '&' operand
net/ipv4/fib_trie.c:980: error: lvalue required as unary '&' operand
net/ipv4/fib_trie.c: In function 'fib_insert_node':
net/ipv4/fib_trie.c:1034: error: lvalue required as unary '&' operand
net/ipv4/fib_trie.c:1034: error: lvalue required as unary '&' operand
net/ipv4/fib_trie.c:1034: error: lvalue required as unary '&' operand
net/ipv4/fib_trie.c: In function 'fn_trie_lookup':
net/ipv4/fib_trie.c:1498: error: lvalue required as unary '&' operand
net/ipv4/fib_trie.c:1502: error: lvalue required as unary '&' operand
net/ipv4/fib_trie.c:1502: error: lvalue required as unary '&' operand
net/ipv4/fib_trie.c:1503: error: lvalue required as unary '&' operand
net/ipv4/fib_trie.c: In function 'trie_leaf_remove':
net/ipv4/fib_trie.c:1539: error: lvalue required as unary '&' operand
net/ipv4/fib_trie.c:1539: error: lvalue required as unary '&' operand
net/ipv4/fib_trie.c:1539: error: lvalue required as unary '&' operand
net/ipv4/fib_trie.c:1554: error: lvalue required as unary '&' operand
net/ipv4/fib_trie.c: In function 'nextleaf':
net/ipv4/fib_trie.c:1706: error: lvalue required as unary '&' operand
net/ipv4/fib_trie.c:1743: error: lvalue required as unary '&' operand
net/ipv4/fib_trie.c: In function 'fib_trie_get_next':
net/ipv4/fib_trie.c:2046: error: lvalue required as unary '&' operand
net/ipv4/fib_trie.c: In function 'fib_trie_seq_show':
net/ipv4/fib_trie.c:2320: error: lvalue required as unary '&' operand
make[2]: *** [net/ipv4/fib_trie.o] Error 1
make[1]: *** [net/ipv4] Error 2
make: *** [net] Error 2
make: *** Waiting for unfinished jobs....

...
