Return-Path: <linux-kernel-owner+w=401wt.eu-S1765442AbXHVQdi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765442AbXHVQdi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 12:33:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762966AbXHVQd3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 12:33:29 -0400
Received: from nf-out-0910.google.com ([64.233.182.190]:36182 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758740AbXHVQd2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 12:33:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=MuopwyIRHGPzgYBBLE+4OF4vf/9pFwlRaSrFhgiwGfcMndwCWbGQrtuuQYb61QDqnhbioAQsgbAOAIvczxGnQCqTxVm76y70A6bhO/MJhQdSIFb5da8MeV1NRy3iIk7rHctGMz/M2i7xoZZyiAVv4fxs5ZYWYjSB+FRXswVEPUU=
Message-ID: <46CC6504.3020500@googlemail.com>
Date: Wed, 22 Aug 2007 18:32:04 +0200
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070803)
MIME-Version: 1.0
To: Adrian Bunk <bunk@kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       netdev <netdev@vger.kernel.org>
Subject: Re: net/ipv4/fib_trie.c - compile error (Re: 2.6.23-rc3-mm1)
References: <20070822020648.5ea3a612.akpm@linux-foundation.org> <46CC5685.7090500@googlemail.com> <20070822154111.GI30705@stusta.de>
In-Reply-To: <20070822154111.GI30705@stusta.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> On Wed, Aug 22, 2007 at 05:30:13PM +0200, Gabriel C wrote:
>> Got it with a randconfig ( http://194.231.229.228/kernel/mm/2.6.23-rc3-mm1/r/randconfig-8 )
>>
>> ...
>>
>> net/ipv4/fib_trie.c: In function 'trie_rebalance':
>> net/ipv4/fib_trie.c:969: error: lvalue required as unary '&' operand
>> net/ipv4/fib_trie.c:971: error: lvalue required as unary '&' operand
>> net/ipv4/fib_trie.c:977: error: lvalue required as unary '&' operand
>> net/ipv4/fib_trie.c:980: error: lvalue required as unary '&' operand
>> ...
> 
> Side effect of the git-net removal, temporarily removing 
> immunize-rcu_dereference-against-crazy-compiler-writers.patch should 
> work around it.

Yes it does , thx Adrian

> 
> cu
> Adrian
> 

Gabriel
