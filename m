Return-Path: <linux-kernel-owner+w=401wt.eu-S1753488AbYKQV1a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753488AbYKQV1a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 16:27:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751754AbYKQV1V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 16:27:21 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:43911 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751684AbYKQV1T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 16:27:19 -0500
Date: Mon, 17 Nov 2008 22:26:57 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Eric Dumazet <dada1@cosmosbay.com>, David Miller <davem@davemloft.net>,
       rjw@sisk.pl, linux-kernel@vger.kernel.org,
       kernel-testers@vger.kernel.org, cl@linux-foundation.org, efault@gmx.de,
       a.p.zijlstra@chello.nl, Stephen Hemminger <shemminger@vyatta.com>
Subject: eth_type_trans(): Re: [Bug #11308] tbench regression on each
	kernel release from 2.6.22 -&gt; 2.6.28
Message-ID: <20081117212657.GH12020@elte.hu>
References: <20081117110119.GL28786@elte.hu> <4921539B.2000002@cosmosbay.com> <20081117161135.GE12081@elte.hu> <49219D36.5020801@cosmosbay.com> <20081117170844.GJ12081@elte.hu> <20081117172549.GA27974@elte.hu> <4921AAD6.3010603@cosmosbay.com> <alpine.LFD.2.00.0811170937540.3468@nehalem.linux-foundation.org> <20081117182320.GA26844@elte.hu> <20081117184951.GA5585@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081117184951.GA5585@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> 100.000000 total
> ................
>   1.717771 eth_type_trans

                      hits (total: 171777)
                 .........
ffffffff8049e215:      457 <eth_type_trans>:
ffffffff8049e215:      457 	41 54                	push   %r12
ffffffff8049e217:     6514 	55                   	push   %rbp
ffffffff8049e218:        0 	48 89 f5             	mov    %rsi,%rbp
ffffffff8049e21b:        0 	53                   	push   %rbx
ffffffff8049e21c:      441 	48 8b 87 d8 00 00 00 	mov    0xd8(%rdi),%rax
ffffffff8049e223:        5 	48 89 fb             	mov    %rdi,%rbx
ffffffff8049e226:        0 	2b 87 d0 00 00 00    	sub    0xd0(%rdi),%eax
ffffffff8049e22c:      493 	48 89 73 20          	mov    %rsi,0x20(%rbx)
ffffffff8049e230:        2 	be 0e 00 00 00       	mov    $0xe,%esi
ffffffff8049e235:        0 	89 87 c0 00 00 00    	mov    %eax,0xc0(%rdi)
ffffffff8049e23b:      472 	e8 2c 98 fe ff       	callq  ffffffff80487a6c <skb_pull>
ffffffff8049e240:      501 	44 8b a3 c0 00 00 00 	mov    0xc0(%rbx),%r12d
ffffffff8049e247:      763 	4c 03 a3 d0 00 00 00 	add    0xd0(%rbx),%r12
ffffffff8049e24e:        0 	41 f6 04 24 01       	testb  $0x1,(%r12)
ffffffff8049e253:      497 	74 26                	je     ffffffff8049e27b <eth_type_trans+0x66>
ffffffff8049e255:        0 	48 8d b5 38 02 00 00 	lea    0x238(%rbp),%rsi
ffffffff8049e25c:        0 	4c 89 e7             	mov    %r12,%rdi
ffffffff8049e25f:        0 	e8 49 fc ff ff       	callq  ffffffff8049dead <compare_ether_addr>
ffffffff8049e264:        0 	85 c0                	test   %eax,%eax
ffffffff8049e266:        0 	8a 43 7d             	mov    0x7d(%rbx),%al
ffffffff8049e269:        0 	75 08                	jne    ffffffff8049e273 <eth_type_trans+0x5e>
ffffffff8049e26b:        0 	83 e0 f8             	and    $0xfffffffffffffff8,%eax
ffffffff8049e26e:        0 	83 c8 01             	or     $0x1,%eax
ffffffff8049e271:        0 	eb 24                	jmp    ffffffff8049e297 <eth_type_trans+0x82>
ffffffff8049e273:        0 	83 e0 f8             	and    $0xfffffffffffffff8,%eax
ffffffff8049e276:        0 	83 c8 02             	or     $0x2,%eax
ffffffff8049e279:        0 	eb 1c                	jmp    ffffffff8049e297 <eth_type_trans+0x82>
ffffffff8049e27b:       82 	48 8d b5 18 02 00 00 	lea    0x218(%rbp),%rsi
ffffffff8049e282:     8782 	4c 89 e7             	mov    %r12,%rdi
ffffffff8049e285:     1752 	e8 23 fc ff ff       	callq  ffffffff8049dead <compare_ether_addr>
ffffffff8049e28a:        0 	85 c0                	test   %eax,%eax
ffffffff8049e28c:      757 	74 0c                	je     ffffffff8049e29a <eth_type_trans+0x85>
ffffffff8049e28e:        0 	8a 43 7d             	mov    0x7d(%rbx),%al
ffffffff8049e291:        0 	83 e0 f8             	and    $0xfffffffffffffff8,%eax
ffffffff8049e294:        0 	83 c8 03             	or     $0x3,%eax
ffffffff8049e297:        0 	88 43 7d             	mov    %al,0x7d(%rbx)
ffffffff8049e29a:      107 	66 41 8b 44 24 0c    	mov    0xc(%r12),%ax
ffffffff8049e2a0:     1031 	0f b7 c8             	movzwl %ax,%ecx
ffffffff8049e2a3:      518 	66 c1 e8 08          	shr    $0x8,%ax
ffffffff8049e2a7:        0 	89 ca                	mov    %ecx,%edx
ffffffff8049e2a9:        0 	c1 e2 08             	shl    $0x8,%edx
ffffffff8049e2ac:      484 	09 d0                	or     %edx,%eax
ffffffff8049e2ae:        0 	0f b7 c0             	movzwl %ax,%eax
ffffffff8049e2b1:        0 	3d ff 05 00 00       	cmp    $0x5ff,%eax
ffffffff8049e2b6:      468 	7f 18                	jg     ffffffff8049e2d0 <eth_type_trans+0xbb>
ffffffff8049e2b8:        0 	48 8b 83 d8 00 00 00 	mov    0xd8(%rbx),%rax
ffffffff8049e2bf:        0 	b9 00 01 00 00       	mov    $0x100,%ecx
ffffffff8049e2c4:        0 	66 83 38 ff          	cmpw   $0xffffffffffffffff,(%rax)
ffffffff8049e2c8:        0 	b8 00 04 00 00       	mov    $0x400,%eax
ffffffff8049e2cd:        0 	0f 45 c8             	cmovne %eax,%ecx
ffffffff8049e2d0:        0 	5b                   	pop    %rbx
ffffffff8049e2d1:    85064 	5d                   	pop    %rbp
ffffffff8049e2d2:    63776 	41 5c                	pop    %r12
ffffffff8049e2d4:        1 	89 c8                	mov    %ecx,%eax
ffffffff8049e2d6:      474 	c3                   	retq   

small function, big bang - 1.7% of the total overhead.

90% of this function's cost is in the closing sequence. My guess would 
be that it originates from ffffffff8049e2ae (the branch after that is 
not taken), which corresponds to this source code context:

(gdb) list *0xffffffff8049e2ae
0xffffffff8049e2ae is in eth_type_trans (net/ethernet/eth.c:199).
194		if (netdev_uses_dsa_tags(dev))
195			return htons(ETH_P_DSA);
196		if (netdev_uses_trailer_tags(dev))
197			return htons(ETH_P_TRAILER);
198	
199		if (ntohs(eth->h_proto) >= 1536)
200			return eth->h_proto;
201	
202		rawp = skb->data;
203	

eth->h_proto access.

Given that this workload does localhost networking, my guess would be 
that eth->h_proto is bouncing around between 16 CPUs? At minimum this 
read-mostly field should be separated from the bouncing bits.

	Ingo
