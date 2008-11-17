Return-Path: <linux-kernel-owner+w=401wt.eu-S1753398AbYKQWPa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753398AbYKQWPa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 17:15:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751750AbYKQWPU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 17:15:20 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:49937 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751684AbYKQWPR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 17:15:17 -0500
Date: Mon, 17 Nov 2008 23:14:45 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Eric Dumazet <dada1@cosmosbay.com>, David Miller <davem@davemloft.net>,
       rjw@sisk.pl, linux-kernel@vger.kernel.org,
       kernel-testers@vger.kernel.org, cl@linux-foundation.org, efault@gmx.de,
       a.p.zijlstra@chello.nl, Stephen Hemminger <shemminger@vyatta.com>
Subject: tcp_transmit_skb() - Re: [Bug #11308] tbench regression on each
	kernel release from 2.6.22 -&gt; 2.6.28
Message-ID: <20081117221445.GC6398@elte.hu>
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
>   1.431553 tcp_transmit_skb

                      hits (total: 143155)
                 .........
ffffffff804c550e:      485 <tcp_transmit_skb>:
ffffffff804c550e:      485 	41 57                	push   %r15
ffffffff804c5510:     5692 	41 56                	push   %r14
ffffffff804c5512:      390 	49 89 f6             	mov    %rsi,%r14
ffffffff804c5515:        0 	41 55                	push   %r13
ffffffff804c5517:       69 	41 54                	push   %r12
ffffffff804c5519:      388 	41 89 d4             	mov    %edx,%r12d
ffffffff804c551c:        0 	55                   	push   %rbp
ffffffff804c551d:       66 	48 89 fd             	mov    %rdi,%rbp
ffffffff804c5520:      405 	53                   	push   %rbx
ffffffff804c5521:        0 	89 cb                	mov    %ecx,%ebx
ffffffff804c5523:       75 	48 83 ec 38          	sub    $0x38,%rsp
ffffffff804c5527:      396 	48 85 f6             	test   %rsi,%rsi
ffffffff804c552a:       51 	74 15                	je     ffffffff804c5541 <tcp_transmit_skb+0x33>
ffffffff804c552c:      396 	8b 96 c8 00 00 00    	mov    0xc8(%rsi),%edx
ffffffff804c5532:        1 	48 8b 86 d0 00 00 00 	mov    0xd0(%rsi),%rax
ffffffff804c5539:       63 	66 83 7c 02 08 00    	cmpw   $0x0,0x8(%rdx,%rax,1)
ffffffff804c553f:      417 	75 04                	jne    ffffffff804c5545 <tcp_transmit_skb+0x37>
ffffffff804c5541:        0 	0f 0b                	ud2a   
ffffffff804c5543:        0 	eb fe                	jmp    ffffffff804c5543 <tcp_transmit_skb+0x35>
ffffffff804c5545:     3719 	48 8b 87 60 03 00 00 	mov    0x360(%rdi),%rax
ffffffff804c554c:     2873 	f6 40 10 02          	testb  $0x2,0x10(%rax)
ffffffff804c5550:        1 	74 09                	je     ffffffff804c555b <tcp_transmit_skb+0x4d>
ffffffff804c5552:        0 	e8 1d 48 d8 ff       	callq  ffffffff80249d74 <ktime_get_real>
ffffffff804c5557:        0 	49 89 46 18          	mov    %rax,0x18(%r14)
ffffffff804c555b:      487 	45 85 e4             	test   %r12d,%r12d
ffffffff804c555e:      456 	74 33                	je     ffffffff804c5593 <tcp_transmit_skb+0x85>
ffffffff804c5560:        0 	4c 89 f7             	mov    %r14,%rdi
ffffffff804c5563:      482 	e8 28 f4 ff ff       	callq  ffffffff804c4990 <skb_cloned>
ffffffff804c5568:     1469 	85 c0                	test   %eax,%eax
ffffffff804c556a:     1085 	74 0c                	je     ffffffff804c5578 <tcp_transmit_skb+0x6a>
ffffffff804c556c:        0 	89 de                	mov    %ebx,%esi
ffffffff804c556e:        0 	4c 89 f7             	mov    %r14,%rdi
ffffffff804c5571:        0 	e8 47 41 fc ff       	callq  ffffffff804896bd <pskb_copy>
ffffffff804c5576:        0 	eb 0a                	jmp    ffffffff804c5582 <tcp_transmit_skb+0x74>
ffffffff804c5578:        0 	89 de                	mov    %ebx,%esi
ffffffff804c557a:      906 	4c 89 f7             	mov    %r14,%rdi
ffffffff804c557d:        0 	e8 ab 35 fc ff       	callq  ffffffff80488b2d <skb_clone>
ffffffff804c5582:        0 	48 85 c0             	test   %rax,%rax
ffffffff804c5585:        7 	49 89 c6             	mov    %rax,%r14
ffffffff804c5588:      576 	bb 97 ff ff ff       	mov    $0xffffff97,%ebx
ffffffff804c558d:        0 	0f 84 59 05 00 00    	je     ffffffff804c5aec <tcp_transmit_skb+0x5de>
ffffffff804c5593:        0 	49 8d 46 38          	lea    0x38(%r14),%rax
ffffffff804c5597:      699 	48 8d 54 24 10       	lea    0x10(%rsp),%rdx
ffffffff804c559c:        1 	fc                   	cld    
ffffffff804c559d:      452 	48 89 04 24          	mov    %rax,(%rsp)
ffffffff804c55a1:       40 	48 89 d7             	mov    %rdx,%rdi
ffffffff804c55a4:        1 	31 c0                	xor    %eax,%eax
ffffffff804c55a6:      432 	ab                   	stos   %eax,%es:(%rdi)
ffffffff804c55a7:      956 	ab                   	stos   %eax,%es:(%rdi)
ffffffff804c55a8:      959 	ab                   	stos   %eax,%es:(%rdi)
ffffffff804c55a9:      910 	ab                   	stos   %eax,%es:(%rdi)
ffffffff804c55aa:      943 	48 8b 0c 24          	mov    (%rsp),%rcx
ffffffff804c55ae:      455 	f6 41 24 02          	testb  $0x2,0x24(%rcx)
ffffffff804c55b2:        0 	0f 84 b7 00 00 00    	je     ffffffff804c566f <tcp_transmit_skb+0x161>
ffffffff804c55b8:        0 	48 8b 85 b8 05 00 00 	mov    0x5b8(%rbp),%rax
ffffffff804c55bf:        0 	48 89 ee             	mov    %rbp,%rsi
ffffffff804c55c2:        0 	48 89 ef             	mov    %rbp,%rdi
ffffffff804c55c5:        0 	ff 10                	callq  *(%rax)
ffffffff804c55c7:        0 	31 f6                	xor    %esi,%esi
ffffffff804c55c9:        0 	48 85 c0             	test   %rax,%rax
ffffffff804c55cc:        0 	48 89 44 24 28       	mov    %rax,0x28(%rsp)
ffffffff804c55d1:        0 	74 08                	je     ffffffff804c55db <tcp_transmit_skb+0xcd>
ffffffff804c55d3:        0 	80 4c 24 10 04       	orb    $0x4,0x10(%rsp)
ffffffff804c55d8:        0 	40 b6 14             	mov    $0x14,%sil
ffffffff804c55db:        0 	48 8b 55 78          	mov    0x78(%rbp),%rdx
ffffffff804c55df:        0 	0f b7 85 5c 04 00 00 	movzwl 0x45c(%rbp),%eax
ffffffff804c55e6:        0 	48 85 d2             	test   %rdx,%rdx
ffffffff804c55e9:        0 	74 13                	je     ffffffff804c55fe <tcp_transmit_skb+0xf0>
ffffffff804c55eb:        0 	8b 92 94 00 00 00    	mov    0x94(%rdx),%edx
ffffffff804c55f1:        0 	39 c2                	cmp    %eax,%edx
ffffffff804c55f3:        0 	73 09                	jae    ffffffff804c55fe <tcp_transmit_skb+0xf0>
ffffffff804c55f5:        0 	89 d0                	mov    %edx,%eax
ffffffff804c55f7:        0 	66 89 95 5c 04 00 00 	mov    %dx,0x45c(%rbp)
ffffffff804c55fe:        0 	83 3d 23 2e 3f 00 00 	cmpl   $0x0,0x3f2e23(%rip)        # ffffffff808b8428 <sysctl_tcp_timestamps>
ffffffff804c5605:        0 	66 89 44 24 14       	mov    %ax,0x14(%rsp)
ffffffff804c560a:        0 	8d 4e 04             	lea    0x4(%rsi),%ecx
ffffffff804c560d:        0 	74 25                	je     ffffffff804c5634 <tcp_transmit_skb+0x126>
ffffffff804c560f:        0 	48 83 7c 24 28 00    	cmpq   $0x0,0x28(%rsp)
ffffffff804c5615:        0 	75 1d                	jne    ffffffff804c5634 <tcp_transmit_skb+0x126>
ffffffff804c5617:        0 	48 8b 14 24          	mov    (%rsp),%rdx
ffffffff804c561b:        0 	80 4c 24 10 02       	orb    $0x2,0x10(%rsp)
ffffffff804c5620:        0 	8d 4e 10             	lea    0x10(%rsi),%ecx
ffffffff804c5623:        0 	8b 42 20             	mov    0x20(%rdx),%eax
ffffffff804c5626:        0 	89 44 24 18          	mov    %eax,0x18(%rsp)
ffffffff804c562a:        0 	8b 85 90 04 00 00    	mov    0x490(%rbp),%eax
ffffffff804c5630:        0 	89 44 24 1c          	mov    %eax,0x1c(%rsp)
ffffffff804c5634:        0 	83 3d f1 2d 3f 00 00 	cmpl   $0x0,0x3f2df1(%rip)        # ffffffff808b842c <sysctl_tcp_window_scaling>
ffffffff804c563b:        0 	74 15                	je     ffffffff804c5652 <tcp_transmit_skb+0x144>
ffffffff804c563d:        0 	8a 85 9d 04 00 00    	mov    0x49d(%rbp),%al
ffffffff804c5643:        0 	8d 51 04             	lea    0x4(%rcx),%edx
ffffffff804c5646:        0 	c0 e8 04             	shr    $0x4,%al
ffffffff804c5649:        0 	84 c0                	test   %al,%al
ffffffff804c564b:        0 	88 44 24 11          	mov    %al,0x11(%rsp)
ffffffff804c564f:        0 	0f 45 ca             	cmovne %edx,%ecx
ffffffff804c5652:        0 	83 3d d7 2d 3f 00 00 	cmpl   $0x0,0x3f2dd7(%rip)        # ffffffff808b8430 <sysctl_tcp_sack>
ffffffff804c5659:        0 	74 26                	je     ffffffff804c5681 <tcp_transmit_skb+0x173>
ffffffff804c565b:        0 	8a 44 24 10          	mov    0x10(%rsp),%al
ffffffff804c565f:        0 	83 c8 01             	or     $0x1,%eax
ffffffff804c5662:        0 	a8 02                	test   $0x2,%al
ffffffff804c5664:        0 	88 44 24 10          	mov    %al,0x10(%rsp)
ffffffff804c5668:        0 	75 17                	jne    ffffffff804c5681 <tcp_transmit_skb+0x173>
ffffffff804c566a:        0 	83 c1 04             	add    $0x4,%ecx
ffffffff804c566d:        0 	eb 12                	jmp    ffffffff804c5681 <tcp_transmit_skb+0x173>
ffffffff804c566f:      502 	48 8d 4c 24 28       	lea    0x28(%rsp),%rcx
ffffffff804c5674:      638 	4c 89 f6             	mov    %r14,%rsi
ffffffff804c5677:        0 	48 89 ef             	mov    %rbp,%rdi
ffffffff804c567a:        0 	e8 1e fb ff ff       	callq  ffffffff804c519d <tcp_established_options>
ffffffff804c567f:      468 	89 c1                	mov    %eax,%ecx
ffffffff804c5681:     1605 	8b 85 74 04 00 00    	mov    0x474(%rbp),%eax
ffffffff804c5687:      307 	03 85 78 04 00 00    	add    0x478(%rbp),%eax
ffffffff804c568d:        0 	44 8d 69 14          	lea    0x14(%rcx),%r13d
ffffffff804c5691:      409 	2b 85 d0 04 00 00    	sub    0x4d0(%rbp),%eax
ffffffff804c5697:       89 	3b 85 cc 04 00 00    	cmp    0x4cc(%rbp),%eax
ffffffff804c569d:        0 	75 0a                	jne    ffffffff804c56a9 <tcp_transmit_skb+0x19b>
ffffffff804c569f:      415 	31 f6                	xor    %esi,%esi
ffffffff804c56a1:      210 	48 89 ef             	mov    %rbp,%rdi
ffffffff804c56a4:        0 	e8 b0 f3 ff ff       	callq  ffffffff804c4a59 <tcp_ca_event>
ffffffff804c56a9:     1050 	44 89 ee             	mov    %r13d,%esi
ffffffff804c56ac:     1063 	4c 89 f7             	mov    %r14,%rdi
ffffffff804c56af:        0 	e8 00 34 fc ff       	callq  ffffffff80488ab4 <skb_push>
ffffffff804c56b4:        0 	4c 89 f7             	mov    %r14,%rdi
ffffffff804c56b7:      789 	e8 4f f3 ff ff       	callq  ffffffff804c4a0b <skb_reset_transport_header>
ffffffff804c56bc:      509 	f0 ff 45 28          	lock incl 0x28(%rbp)
ffffffff804c56c0:      494 	49 89 6e 10          	mov    %rbp,0x10(%r14)
ffffffff804c56c4:     3510 	49 c7 86 80 00 00 00 	movq   $0xffffffff80486679,0x80(%r14)
ffffffff804c56cb:        0 	79 66 48 80 
ffffffff804c56cf:      102 	41 8b 86 e0 00 00 00 	mov    0xe0(%r14),%eax
ffffffff804c56d6:      155 	f0 01 85 98 00 00 00 	lock add %eax,0x98(%rbp)
ffffffff804c56dd:      437 	41 8b 9e b8 00 00 00 	mov    0xb8(%r14),%ebx
ffffffff804c56e4:      219 	8b 85 50 02 00 00    	mov    0x250(%rbp),%eax
ffffffff804c56ea:       71 	49 03 9e d0 00 00 00 	add    0xd0(%r14),%rbx
ffffffff804c56f1:      735 	66 89 03             	mov    %ax,(%rbx)
ffffffff804c56f4:        0 	8b 85 38 02 00 00    	mov    0x238(%rbp),%eax
ffffffff804c56fa:       75 	66 89 43 02          	mov    %ax,0x2(%rbx)
ffffffff804c56fe:      720 	48 8b 0c 24          	mov    (%rsp),%rcx
ffffffff804c5702:     5992 	8b 41 18             	mov    0x18(%rcx),%eax
ffffffff804c5705:     1460 	0f c8                	bswap  %eax
ffffffff804c5707:       60 	89 43 04             	mov    %eax,0x4(%rbx)
ffffffff804c570a:       69 	8b 85 f0 03 00 00    	mov    0x3f0(%rbp),%eax
ffffffff804c5710:      374 	0f c8                	bswap  %eax
ffffffff804c5712:       43 	89 43 08             	mov    %eax,0x8(%rbx)
ffffffff804c5715:       76 	0f b6 51 24          	movzbl 0x24(%rcx),%edx
ffffffff804c5719:      337 	44 89 e8             	mov    %r13d,%eax
ffffffff804c571c:       36 	c1 e8 02             	shr    $0x2,%eax
ffffffff804c571f:       76 	c1 e0 0c             	shl    $0xc,%eax
ffffffff804c5722:      476 	09 d0                	or     %edx,%eax
ffffffff804c5724:       48 	66 c1 c0 08          	rol    $0x8,%ax
ffffffff804c5728:       51 	66 89 43 0c          	mov    %ax,0xc(%rbx)
ffffffff804c572c:      370 	0f b6 41 24          	movzbl 0x24(%rcx),%eax
ffffffff804c5730:      137 	89 c2                	mov    %eax,%edx
ffffffff804c5732:      118 	83 e2 02             	and    $0x2,%edx
ffffffff804c5735:      377 	74 1b                	je     ffffffff804c5752 <tcp_transmit_skb+0x244>
ffffffff804c5737:        0 	81 bd c0 04 00 00 ff 	cmpl   $0xffff,0x4c0(%rbp)
ffffffff804c573e:        0 	ff 00 00 
ffffffff804c5741:        0 	b8 ff ff 00 00       	mov    $0xffff,%eax
ffffffff804c5746:        0 	0f 46 85 c0 04 00 00 	cmovbe 0x4c0(%rbp),%eax
ffffffff804c574d:        0 	e9 a0 00 00 00       	jmpq   ffffffff804c57f2 <tcp_transmit_skb+0x2e4>
ffffffff804c5752:       34 	8b 85 f8 03 00 00    	mov    0x3f8(%rbp),%eax
ffffffff804c5758:     5610 	03 85 c0 04 00 00    	add    0x4c0(%rbp),%eax
ffffffff804c575e:       44 	41 89 d4             	mov    %edx,%r12d
ffffffff804c5761:      539 	2b 85 f0 03 00 00    	sub    0x3f0(%rbp),%eax
ffffffff804c5767:        1 	48 89 ef             	mov    %rbp,%rdi
ffffffff804c576a:       51 	44 0f 49 e0          	cmovns %eax,%r12d
ffffffff804c576e:      495 	e8 7e f8 ff ff       	callq  ffffffff804c4ff1 <__tcp_select_window>
ffffffff804c5773:      484 	44 39 e0             	cmp    %r12d,%eax
ffffffff804c5776:      244 	89 c2                	mov    %eax,%edx
ffffffff804c5778:        0 	73 19                	jae    ffffffff804c5793 <tcp_transmit_skb+0x285>
ffffffff804c577a:        0 	8a 8d 9d 04 00 00    	mov    0x49d(%rbp),%cl
ffffffff804c5780:        0 	b8 01 00 00 00       	mov    $0x1,%eax
ffffffff804c5785:        0 	c0 e9 04             	shr    $0x4,%cl
ffffffff804c5788:        0 	d3 e0                	shl    %cl,%eax
ffffffff804c578a:        0 	42 8d 54 20 ff       	lea    -0x1(%rax,%r12,1),%edx
ffffffff804c578f:        0 	f7 d8                	neg    %eax
ffffffff804c5791:        0 	21 c2                	and    %eax,%edx
ffffffff804c5793:      217 	f6 85 9d 04 00 00 f0 	testb  $0xf0,0x49d(%rbp)
ffffffff804c579a:     2014 	8b 85 f0 03 00 00    	mov    0x3f0(%rbp),%eax
ffffffff804c57a0:        0 	89 95 c0 04 00 00    	mov    %edx,0x4c0(%rbp)
ffffffff804c57a6:      490 	89 85 f8 03 00 00    	mov    %eax,0x3f8(%rbp)
ffffffff804c57ac:        1 	75 16                	jne    ffffffff804c57c4 <tcp_transmit_skb+0x2b6>
ffffffff804c57ae:        0 	83 3d bb 2c 3f 00 00 	cmpl   $0x0,0x3f2cbb(%rip)        # ffffffff808b8470 <sysctl_tcp_workaround_signed_windows>
ffffffff804c57b5:        0 	74 0d                	je     ffffffff804c57c4 <tcp_transmit_skb+0x2b6>
ffffffff804c57b7:        0 	b8 ff 7f 00 00       	mov    $0x7fff,%eax
ffffffff804c57bc:        0 	81 fa ff 7f 00 00    	cmp    $0x7fff,%edx
ffffffff804c57c2:        0 	eb 12                	jmp    ffffffff804c57d6 <tcp_transmit_skb+0x2c8>
ffffffff804c57c4:        0 	8a 8d 9d 04 00 00    	mov    0x49d(%rbp),%cl
ffffffff804c57ca:     7025 	b8 ff ff 00 00       	mov    $0xffff,%eax
ffffffff804c57cf:        0 	c0 e9 04             	shr    $0x4,%cl
ffffffff804c57d2:      418 	d3 e0                	shl    %cl,%eax
ffffffff804c57d4:      102 	39 c2                	cmp    %eax,%edx
ffffffff804c57d6:        0 	8a 8d 9d 04 00 00    	mov    0x49d(%rbp),%cl
ffffffff804c57dc:      424 	0f 46 c2             	cmovbe %edx,%eax
ffffffff804c57df:      105 	c0 e9 04             	shr    $0x4,%cl
ffffffff804c57e2:        9 	d3 e8                	shr    %cl,%eax
ffffffff804c57e4:      389 	85 c0                	test   %eax,%eax
ffffffff804c57e6:       76 	75 0a                	jne    ffffffff804c57f2 <tcp_transmit_skb+0x2e4>
ffffffff804c57e8:        0 	c7 85 ec 03 00 00 00 	movl   $0x0,0x3ec(%rbp)
ffffffff804c57ef:        0 	00 00 00 
ffffffff804c57f2:        2 	66 c1 c0 08          	rol    $0x8,%ax
ffffffff804c57f6:     1657 	66 c7 43 10 00 00    	movw   $0x0,0x10(%rbx)
ffffffff804c57fc:       35 	66 c7 43 12 00 00    	movw   $0x0,0x12(%rbx)
ffffffff804c5802:     4377 	66 89 43 0e          	mov    %ax,0xe(%rbx)
ffffffff804c5806:      954 	8b 95 80 04 00 00    	mov    0x480(%rbp),%edx
ffffffff804c580c:       31 	39 95 00 04 00 00    	cmp    %edx,0x400(%rbp)
ffffffff804c5812:      186 	74 27                	je     ffffffff804c583b <tcp_transmit_skb+0x32d>
ffffffff804c5814:        0 	48 8b 34 24          	mov    (%rsp),%rsi
ffffffff804c5818:        0 	8b 4e 18             	mov    0x18(%rsi),%ecx
ffffffff804c581b:        0 	89 d6                	mov    %edx,%esi
ffffffff804c581d:        0 	8d 41 01             	lea    0x1(%rcx),%eax
ffffffff804c5820:        0 	29 c6                	sub    %eax,%esi
ffffffff804c5822:        0 	81 fe fe ff 00 00    	cmp    $0xfffe,%esi
ffffffff804c5828:        0 	77 11                	ja     ffffffff804c583b <tcp_transmit_skb+0x32d>
ffffffff804c582a:        0 	89 d0                	mov    %edx,%eax
ffffffff804c582c:        0 	80 4b 0d 20          	orb    $0x20,0xd(%rbx)
ffffffff804c5830:        0 	66 29 c8             	sub    %cx,%ax
ffffffff804c5833:        0 	66 c1 c0 08          	rol    $0x8,%ax
ffffffff804c5837:        0 	66 89 43 12          	mov    %ax,0x12(%rbx)
ffffffff804c583b:      268 	48 8d 7b 14          	lea    0x14(%rbx),%rdi
ffffffff804c583f:      187 	48 8d 4c 24 20       	lea    0x20(%rsp),%rcx
ffffffff804c5844:     4006 	48 8d 54 24 10       	lea    0x10(%rsp),%rdx
ffffffff804c5849:     1117 	48 89 ee             	mov    %rbp,%rsi
ffffffff804c584c:        0 	e8 a9 fb ff ff       	callq  ffffffff804c53fa <tcp_options_write>
ffffffff804c5851:     1285 	48 8b 04 24          	mov    (%rsp),%rax
ffffffff804c5855:      727 	f6 40 24 02          	testb  $0x2,0x24(%rax)
ffffffff804c5859:        0 	0f 85 8f 00 00 00    	jne    ffffffff804c58ee <tcp_transmit_skb+0x3e0>
ffffffff804c585f:        0 	f6 85 7e 04 00 00 01 	testb  $0x1,0x47e(%rbp)
ffffffff804c5866:      456 	0f 84 82 00 00 00    	je     ffffffff804c58ee <tcp_transmit_skb+0x3e0>
ffffffff804c586c:        0 	45 39 6e 68          	cmp    %r13d,0x68(%r14)
ffffffff804c5870:        0 	74 53                	je     ffffffff804c58c5 <tcp_transmit_skb+0x3b7>
ffffffff804c5872:        0 	8b 95 fc 03 00 00    	mov    0x3fc(%rbp),%edx
ffffffff804c5878:        0 	39 50 18             	cmp    %edx,0x18(%rax)
ffffffff804c587b:        0 	78 48                	js     ffffffff804c58c5 <tcp_transmit_skb+0x3b7>
ffffffff804c587d:        0 	8a 85 7e 04 00 00    	mov    0x47e(%rbp),%al
ffffffff804c5883:        0 	80 8d 54 02 00 00 02 	orb    $0x2,0x254(%rbp)
ffffffff804c588a:        0 	a8 02                	test   $0x2,%al
ffffffff804c588c:        0 	74 3e                	je     ffffffff804c58cc <tcp_transmit_skb+0x3be>
ffffffff804c588e:        0 	83 e0 fd             	and    $0xfffffffffffffffd,%eax
ffffffff804c5891:        0 	88 85 7e 04 00 00    	mov    %al,0x47e(%rbp)
ffffffff804c5897:        0 	41 8b 8e b8 00 00 00 	mov    0xb8(%r14),%ecx
ffffffff804c589e:        0 	49 8b 96 d0 00 00 00 	mov    0xd0(%r14),%rdx
ffffffff804c58a5:        0 	8a 44 11 0d          	mov    0xd(%rcx,%rdx,1),%al
ffffffff804c58a9:        0 	83 c8 80             	or     $0xffffffffffffff80,%eax
ffffffff804c58ac:        0 	88 44 0a 0d          	mov    %al,0xd(%rdx,%rcx,1)
ffffffff804c58b0:        0 	41 8b 86 c8 00 00 00 	mov    0xc8(%r14),%eax
ffffffff804c58b7:        0 	49 03 86 d0 00 00 00 	add    0xd0(%r14),%rax
ffffffff804c58be:        0 	66 83 48 0a 08       	orw    $0x8,0xa(%rax)
ffffffff804c58c3:        0 	eb 07                	jmp    ffffffff804c58cc <tcp_transmit_skb+0x3be>
ffffffff804c58c5:        0 	80 a5 54 02 00 00 fc 	andb   $0xfc,0x254(%rbp)
ffffffff804c58cc:        0 	f6 85 7e 04 00 00 04 	testb  $0x4,0x47e(%rbp)
ffffffff804c58d3:        0 	74 19                	je     ffffffff804c58ee <tcp_transmit_skb+0x3e0>
ffffffff804c58d5:        0 	41 8b 8e b8 00 00 00 	mov    0xb8(%r14),%ecx
ffffffff804c58dc:        0 	49 8b 96 d0 00 00 00 	mov    0xd0(%r14),%rdx
ffffffff804c58e3:        0 	8a 44 11 0d          	mov    0xd(%rcx,%rdx,1),%al
ffffffff804c58e7:        0 	83 c8 40             	or     $0x40,%eax
ffffffff804c58ea:        0 	88 44 0a 0d          	mov    %al,0xd(%rdx,%rcx,1)
ffffffff804c58ee:        0 	48 83 7c 24 28 00    	cmpq   $0x0,0x28(%rsp)
ffffffff804c58f4:     9425 	74 26                	je     ffffffff804c591c <tcp_transmit_skb+0x40e>
ffffffff804c58f6:        0 	48 8b 85 b8 05 00 00 	mov    0x5b8(%rbp),%rax
ffffffff804c58fd:        0 	81 a5 fc 00 00 00 ff 	andl   $0xffff,0xfc(%rbp)
ffffffff804c5904:        0 	ff 00 00 
ffffffff804c5907:        0 	4d 89 f0             	mov    %r14,%r8
ffffffff804c590a:        0 	48 8b 74 24 28       	mov    0x28(%rsp),%rsi
ffffffff804c590f:        0 	48 8b 7c 24 20       	mov    0x20(%rsp),%rdi
ffffffff804c5914:        0 	31 c9                	xor    %ecx,%ecx
ffffffff804c5916:        0 	48 89 ea             	mov    %rbp,%rdx
ffffffff804c5919:        0 	ff 50 08             	callq  *0x8(%rax)
ffffffff804c591c:        0 	48 8b 85 68 03 00 00 	mov    0x368(%rbp),%rax
ffffffff804c5923:     2344 	41 8b 76 68          	mov    0x68(%r14),%esi
ffffffff804c5927:        1 	4c 89 f2             	mov    %r14,%rdx
ffffffff804c592a:        0 	48 89 ef             	mov    %rbp,%rdi
ffffffff804c592d:      486 	ff 50 08             	callq  *0x8(%rax)
ffffffff804c5930:       44 	48 8b 0c 24          	mov    (%rsp),%rcx
ffffffff804c5934:      836 	f6 41 24 10          	testb  $0x10,0x24(%rcx)
ffffffff804c5938:        0 	74 4f                	je     ffffffff804c5989 <tcp_transmit_skb+0x47b>
ffffffff804c593a:       75 	41 8b 96 c8 00 00 00 	mov    0xc8(%r14),%edx
ffffffff804c5941:     8600 	49 8b 86 d0 00 00 00 	mov    0xd0(%r14),%rax
ffffffff804c5948:     1667 	8b 44 10 08          	mov    0x8(%rax,%rdx,1),%eax
ffffffff804c594c:       13 	8a 95 81 03 00 00    	mov    0x381(%rbp),%dl
ffffffff804c5952:       24 	84 d2                	test   %dl,%dl
ffffffff804c5954:      429 	74 25                	je     ffffffff804c597b <tcp_transmit_skb+0x46d>
ffffffff804c5956:        0 	0f b7 c8             	movzwl %ax,%ecx
ffffffff804c5959:        3 	0f b6 c2             	movzbl %dl,%eax
ffffffff804c595c:        0 	39 c1                	cmp    %eax,%ecx
ffffffff804c595e:        0 	72 13                	jb     ffffffff804c5973 <tcp_transmit_skb+0x465>
ffffffff804c5960:        0 	c6 85 81 03 00 00 00 	movb   $0x0,0x381(%rbp)
ffffffff804c5967:        1 	c7 85 84 03 00 00 0a 	movl   $0xa,0x384(%rbp)
ffffffff804c596e:        0 	00 00 00 
ffffffff804c5971:        0 	eb 08                	jmp    ffffffff804c597b <tcp_transmit_skb+0x46d>
ffffffff804c5973:        1 	28 ca                	sub    %cl,%dl
ffffffff804c5975:        0 	88 95 81 03 00 00    	mov    %dl,0x381(%rbp)
ffffffff804c597b:       11 	c6 85 80 03 00 00 00 	movb   $0x0,0x380(%rbp)
ffffffff804c5982:     4553 	c6 85 83 03 00 00 00 	movb   $0x0,0x383(%rbp)
ffffffff804c5989:      714 	45 39 6e 68          	cmp    %r13d,0x68(%r14)
ffffffff804c598d:        1 	0f 84 e2 00 00 00    	je     ffffffff804c5a75 <tcp_transmit_skb+0x567>
ffffffff804c5993:      288 	83 3d e6 2a 3f 00 00 	cmpl   $0x0,0x3f2ae6(%rip)        # ffffffff808b8480 <sysctl_tcp_slow_start_after_idle>
ffffffff804c599a:      247 	48 8b 05 df 3e 3f 00 	mov    0x3f3edf(%rip),%rax        # ffffffff808b9880 <jiffies>
ffffffff804c59a1:      711 	41 89 c7             	mov    %eax,%r15d
ffffffff804c59a4:        0 	0f 84 ad 00 00 00    	je     ffffffff804c5a57 <tcp_transmit_skb+0x549>
ffffffff804c59aa:      159 	83 bd 74 04 00 00 00 	cmpl   $0x0,0x474(%rbp)
ffffffff804c59b1:      311 	0f 85 a0 00 00 00    	jne    ffffffff804c5a57 <tcp_transmit_skb+0x549>
ffffffff804c59b7:        0 	44 8b ad 0c 04 00 00 	mov    0x40c(%rbp),%r13d
ffffffff804c59be:      183 	44 29 e8             	sub    %r13d,%eax
ffffffff804c59c1:      475 	3b 85 58 03 00 00    	cmp    0x358(%rbp),%eax
ffffffff804c59c7:       54 	0f 86 8a 00 00 00    	jbe    ffffffff804c5a57 <tcp_transmit_skb+0x549>
ffffffff804c59cd:        0 	48 8b 75 78          	mov    0x78(%rbp),%rsi
ffffffff804c59d1:        1 	48 8b 05 a8 3e 3f 00 	mov    0x3f3ea8(%rip),%rax        # ffffffff808b9880 <jiffies>
ffffffff804c59d8:        0 	48 89 ef             	mov    %rbp,%rdi
ffffffff804c59db:        0 	48 89 44 24 08       	mov    %rax,0x8(%rsp)
ffffffff804c59e0:        0 	e8 9c 92 ff ff       	callq  ffffffff804bec81 <tcp_init_cwnd>
ffffffff804c59e5:        0 	be 01 00 00 00       	mov    $0x1,%esi
ffffffff804c59ea:        0 	48 89 ef             	mov    %rbp,%rdi
ffffffff804c59ed:        0 	41 89 c4             	mov    %eax,%r12d
ffffffff804c59f0:        0 	8b 9d ac 04 00 00    	mov    0x4ac(%rbp),%ebx
ffffffff804c59f6:        0 	e8 5e f0 ff ff       	callq  ffffffff804c4a59 <tcp_ca_event>
ffffffff804c59fb:        0 	48 89 ef             	mov    %rbp,%rdi
ffffffff804c59fe:        0 	e8 6d f0 ff ff       	callq  ffffffff804c4a70 <tcp_current_ssthresh>
ffffffff804c5a03:        0 	89 85 a8 04 00 00    	mov    %eax,0x4a8(%rbp)
ffffffff804c5a09:        4 	8b 85 58 03 00 00    	mov    0x358(%rbp),%eax
ffffffff804c5a0f:        0 	41 39 dc             	cmp    %ebx,%r12d
ffffffff804c5a12:        0 	8b 54 24 08          	mov    0x8(%rsp),%edx
ffffffff804c5a16:        0 	89 d9                	mov    %ebx,%ecx
ffffffff804c5a18:        0 	41 0f 46 cc          	cmovbe %r12d,%ecx
ffffffff804c5a1c:        0 	89 c6                	mov    %eax,%esi
ffffffff804c5a1e:        0 	44 29 ea             	sub    %r13d,%edx
ffffffff804c5a21:        0 	f7 de                	neg    %esi
ffffffff804c5a23:        0 	29 c2                	sub    %eax,%edx
ffffffff804c5a25:        0 	89 d8                	mov    %ebx,%eax
ffffffff804c5a27:        0 	eb 02                	jmp    ffffffff804c5a2b <tcp_transmit_skb+0x51d>
ffffffff804c5a29:        0 	d1 e8                	shr    %eax
ffffffff804c5a2b:        0 	85 d2                	test   %edx,%edx
ffffffff804c5a2d:        1 	7e 06                	jle    ffffffff804c5a35 <tcp_transmit_skb+0x527>
ffffffff804c5a2f:        0 	01 f2                	add    %esi,%edx
ffffffff804c5a31:        0 	39 c8                	cmp    %ecx,%eax
ffffffff804c5a33:        0 	77 f4                	ja     ffffffff804c5a29 <tcp_transmit_skb+0x51b>
ffffffff804c5a35:        0 	39 c8                	cmp    %ecx,%eax
ffffffff804c5a37:        1 	0f 43 c8             	cmovae %eax,%ecx
ffffffff804c5a3a:        0 	89 8d ac 04 00 00    	mov    %ecx,0x4ac(%rbp)
ffffffff804c5a40:        0 	48 8b 05 39 3e 3f 00 	mov    0x3f3e39(%rip),%rax        # ffffffff808b9880 <jiffies>
ffffffff804c5a47:        0 	c7 85 b8 04 00 00 00 	movl   $0x0,0x4b8(%rbp)
ffffffff804c5a4e:        0 	00 00 00 
ffffffff804c5a51:        0 	89 85 bc 04 00 00    	mov    %eax,0x4bc(%rbp)
ffffffff804c5a57:      173 	44 89 bd 0c 04 00 00 	mov    %r15d,0x40c(%rbp)
ffffffff804c5a5e:     5224 	44 2b bd 90 03 00 00 	sub    0x390(%rbp),%r15d
ffffffff804c5a65:      478 	44 3b bd 84 03 00 00 	cmp    0x384(%rbp),%r15d
ffffffff804c5a6c:        0 	73 07                	jae    ffffffff804c5a75 <tcp_transmit_skb+0x567>
ffffffff804c5a6e:       38 	c6 85 82 03 00 00 01 	movb   $0x1,0x382(%rbp)
ffffffff804c5a75:      452 	48 8b 14 24          	mov    (%rsp),%rdx
ffffffff804c5a79:      312 	8b 42 1c             	mov    0x1c(%rdx),%eax
ffffffff804c5a7c:       33 	39 85 fc 03 00 00    	cmp    %eax,0x3fc(%rbp)
ffffffff804c5a82:     4768 	78 05                	js     ffffffff804c5a89 <tcp_transmit_skb+0x57b>
ffffffff804c5a84:        0 	39 42 18             	cmp    %eax,0x18(%rdx)
ffffffff804c5a87:       20 	75 37                	jne    ffffffff804c5ac0 <tcp_transmit_skb+0x5b2>
ffffffff804c5a89:       30 	65 48 8b 04 25 10 00 	mov    %gs:0x10,%rax
ffffffff804c5a90:        0 	00 00 
ffffffff804c5a92:     1059 	8b 80 48 e0 ff ff    	mov    -0x1fb8(%rax),%eax
ffffffff804c5a98:       21 	65 8b 14 25 24 00 00 	mov    %gs:0x24,%edx
ffffffff804c5a9f:        0 	00 
ffffffff804c5aa0:       14 	89 d2                	mov    %edx,%edx
ffffffff804c5aa2:      471 	30 c0                	xor    %al,%al
ffffffff804c5aa4:        3 	66 83 f8 01          	cmp    $0x1,%ax
ffffffff804c5aa8:       21 	48 19 c0             	sbb    %rax,%rax
ffffffff804c5aab:      433 	83 e0 08             	and    $0x8,%eax
ffffffff804c5aae:        2 	48 8b 80 98 16 ab 80 	mov    -0x7f54e968(%rax),%rax
ffffffff804c5ab5:       16 	48 f7 d0             	not    %rax
ffffffff804c5ab8:      457 	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
ffffffff804c5abc:        3 	48 ff 40 58          	incq   0x58(%rax)
ffffffff804c5ac0:       20 	48 8b 85 68 03 00 00 	mov    0x368(%rbp),%rax
ffffffff804c5ac7:      424 	31 f6                	xor    %esi,%esi
ffffffff804c5ac9:        2 	4c 89 f7             	mov    %r14,%rdi
ffffffff804c5acc:       20 	ff 10                	callq  *(%rax)
ffffffff804c5ace:        0 	85 c0                	test   %eax,%eax
ffffffff804c5ad0:     9596 	89 c3                	mov    %eax,%ebx
ffffffff804c5ad2:        0 	7e 18                	jle    ffffffff804c5aec <tcp_transmit_skb+0x5de>
ffffffff804c5ad4:        0 	be 01 00 00 00       	mov    $0x1,%esi
ffffffff804c5ad9:        0 	48 89 ef             	mov    %rbp,%rdi
ffffffff804c5adc:        0 	e8 d9 91 ff ff       	callq  ffffffff804becba <tcp_enter_cwr>
ffffffff804c5ae1:        0 	83 fb 02             	cmp    $0x2,%ebx
ffffffff804c5ae4:        0 	b8 00 00 00 00       	mov    $0x0,%eax
ffffffff804c5ae9:        0 	0f 44 d8             	cmove  %eax,%ebx
ffffffff804c5aec:      457 	48 83 c4 38          	add    $0x38,%rsp
ffffffff804c5af0:     1473 	89 d8                	mov    %ebx,%eax
ffffffff804c5af2:        0 	5b                   	pop    %rbx
ffffffff804c5af3:      480 	5d                   	pop    %rbp
ffffffff804c5af4:        0 	41 5c                	pop    %r12
ffffffff804c5af6:        0 	41 5d                	pop    %r13
ffffffff804c5af8:      449 	41 5e                	pop    %r14
ffffffff804c5afa:        0 	41 5f                	pop    %r15
ffffffff804c5afc:        0 	c3                   	retq   

looks like spread-out overhead with no particular bad spike. Just 
called a lot.

	Ingo
