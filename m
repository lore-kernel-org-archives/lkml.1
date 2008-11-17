Return-Path: <linux-kernel-owner+w=401wt.eu-S1755222AbYKQVUH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755222AbYKQVUH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 16:20:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752321AbYKQVTv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 16:19:51 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:42402 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752336AbYKQVTs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 16:19:48 -0500
Date: Mon, 17 Nov 2008 22:19:20 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Eric Dumazet <dada1@cosmosbay.com>, David Miller <davem@davemloft.net>,
       rjw@sisk.pl, linux-kernel@vger.kernel.org,
       kernel-testers@vger.kernel.org, cl@linux-foundation.org, efault@gmx.de,
       a.p.zijlstra@chello.nl, Stephen Hemminger <shemminger@vyatta.com>
Subject: tcp_recvmsg(): Re: [Bug #11308] tbench regression on each kernel
	release from 2.6.22 -&gt; 2.6.28
Message-ID: <20081117211920.GG12020@elte.hu>
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
>   1.833688 tcp_recvmsg

                      hits (total: 183368)
                 .........
ffffffff804bd46e:      882 <tcp_recvmsg>:
ffffffff804bd46e:      882 	41 57                	push   %r15
ffffffff804bd470:    15507 	48 89 f7             	mov    %rsi,%rdi
ffffffff804bd473:      179 	41 56                	push   %r14
ffffffff804bd475:        0 	49 89 ce             	mov    %rcx,%r14
ffffffff804bd478:      744 	41 55                	push   %r13
ffffffff804bd47a:      165 	41 54                	push   %r12
ffffffff804bd47c:        0 	45 89 c4             	mov    %r8d,%r12d
ffffffff804bd47f:      692 	55                   	push   %rbp
ffffffff804bd480:      178 	44 89 cd             	mov    %r9d,%ebp
ffffffff804bd483:     3434 	53                   	push   %rbx
ffffffff804bd484:      685 	48 89 f3             	mov    %rsi,%rbx
ffffffff804bd487:       11 	48 83 ec 68          	sub    $0x68,%rsp
ffffffff804bd48b:      949 	48 89 54 24 30       	mov    %rdx,0x30(%rsp)
ffffffff804bd490:        7 	e8 e8 e8 ff ff       	callq  ffffffff804bbd7d <lock_sock>
ffffffff804bd495:     1771 	8a 43 02             	mov    0x2(%rbx),%al
ffffffff804bd498:     6176 	3c 0a                	cmp    $0xa,%al
ffffffff804bd49a:        0 	0f 84 3a 06 00 00    	je     ffffffff804bdada <tcp_recvmsg+0x66c>
ffffffff804bd4a0:     3121 	31 c0                	xor    %eax,%eax
ffffffff804bd4a2:      195 	45 85 e4             	test   %r12d,%r12d
ffffffff804bd4a5:        0 	75 07                	jne    ffffffff804bd4ae <tcp_recvmsg+0x40>
ffffffff804bd4a7:      926 	48 8b 83 68 01 00 00 	mov    0x168(%rbx),%rax
ffffffff804bd4ae:      189 	40 f6 c5 01          	test   $0x1,%bpl
ffffffff804bd4b2:        0 	48 89 44 24 58       	mov    %rax,0x58(%rsp)
ffffffff804bd4b7:      819 	0f 85 33 06 00 00    	jne    ffffffff804bdaf0 <tcp_recvmsg+0x682>
ffffffff804bd4bd:      216 	89 e8                	mov    %ebp,%eax
ffffffff804bd4bf:        0 	83 e0 02             	and    $0x2,%eax
ffffffff804bd4c2:      638 	89 44 24 3c          	mov    %eax,0x3c(%rsp)
ffffffff804bd4c6:      177 	75 0e                	jne    ffffffff804bd4d6 <tcp_recvmsg+0x68>
ffffffff804bd4c8:        0 	48 8d 93 f4 03 00 00 	lea    0x3f4(%rbx),%rdx
ffffffff804bd4cf:      661 	48 89 54 24 40       	mov    %rdx,0x40(%rsp)
ffffffff804bd4d4:      195 	eb 14                	jmp    ffffffff804bd4ea <tcp_recvmsg+0x7c>
ffffffff804bd4d6:        0 	8b 83 f4 03 00 00    	mov    0x3f4(%rbx),%eax
ffffffff804bd4dc:        0 	48 8d 4c 24 60       	lea    0x60(%rsp),%rcx
ffffffff804bd4e1:        0 	48 89 4c 24 40       	mov    %rcx,0x40(%rsp)
ffffffff804bd4e6:        0 	89 44 24 60          	mov    %eax,0x60(%rsp)
ffffffff804bd4ea:      867 	89 ee                	mov    %ebp,%esi
ffffffff804bd4ec:      210 	44 89 f2             	mov    %r14d,%edx
ffffffff804bd4ef:        0 	48 89 df             	mov    %rbx,%rdi
ffffffff804bd4f2:      894 	81 e6 00 01 00 00    	and    $0x100,%esi
ffffffff804bd4f8:      192 	45 31 ff             	xor    %r15d,%r15d
ffffffff804bd4fb:        0 	e8 fc df ff ff       	callq  ffffffff804bb4fc <sock_rcvlowat>
ffffffff804bd500:      853 	89 44 24 4c          	mov    %eax,0x4c(%rsp)
ffffffff804bd504:     1857 	48 8d 83 a8 00 00 00 	lea    0xa8(%rbx),%rax
ffffffff804bd50b:        0 	89 e9                	mov    %ebp,%ecx
ffffffff804bd50d:      595 	48 8d 93 10 04 00 00 	lea    0x410(%rbx),%rdx
ffffffff804bd514:      263 	83 e1 22             	and    $0x22,%ecx
ffffffff804bd517:        0 	83 e5 20             	and    $0x20,%ebp
ffffffff804bd51a:      601 	48 89 44 24 28       	mov    %rax,0x28(%rsp)
ffffffff804bd51f:      254 	48 8d 83 f8 04 00 00 	lea    0x4f8(%rbx),%rax
ffffffff804bd526:        2 	48 c7 44 24 50 00 00 	movq   $0x0,0x50(%rsp)
ffffffff804bd52d:        0 	00 00 
ffffffff804bd52f:      578 	48 89 54 24 20       	mov    %rdx,0x20(%rsp)
ffffffff804bd534:      290 	89 4c 24 1c          	mov    %ecx,0x1c(%rsp)
ffffffff804bd538:        1 	48 89 44 24 10       	mov    %rax,0x10(%rsp)
ffffffff804bd53d:      593 	89 6c 24 0c          	mov    %ebp,0xc(%rsp)
ffffffff804bd541:      568 	66 83 bb 7c 04 00 00 	cmpw   $0x0,0x47c(%rbx)
ffffffff804bd548:        0 	00 
ffffffff804bd549:     3956 	74 55                	je     ffffffff804bd5a0 <tcp_recvmsg+0x132>
ffffffff804bd54b:        0 	48 8b 54 24 40       	mov    0x40(%rsp),%rdx
ffffffff804bd550:        0 	8b 83 84 05 00 00    	mov    0x584(%rbx),%eax
ffffffff804bd556:        0 	3b 02                	cmp    (%rdx),%eax
ffffffff804bd558:        0 	75 46                	jne    ffffffff804bd5a0 <tcp_recvmsg+0x132>
ffffffff804bd55a:        0 	45 85 ff             	test   %r15d,%r15d
ffffffff804bd55d:        0 	0f 85 e6 04 00 00    	jne    ffffffff804bda49 <tcp_recvmsg+0x5db>
ffffffff804bd563:        0 	65 48 8b 3c 25 00 00 	mov    %gs:0x0,%rdi
ffffffff804bd56a:        0 	00 00 
ffffffff804bd56c:        0 	e8 4c e1 ff ff       	callq  ffffffff804bb6bd <signal_pending>
ffffffff804bd571:        0 	85 c0                	test   %eax,%eax
ffffffff804bd573:        0 	74 2b                	je     ffffffff804bd5a0 <tcp_recvmsg+0x132>
ffffffff804bd575:        0 	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
ffffffff804bd57a:        0 	41 bf f5 ff ff ff    	mov    $0xfffffff5,%r15d
ffffffff804bd580:        0 	48 85 d2             	test   %rdx,%rdx
ffffffff804bd583:        0 	0f 84 c0 04 00 00    	je     ffffffff804bda49 <tcp_recvmsg+0x5db>
ffffffff804bd589:        0 	48 b8 ff ff ff ff ff 	mov    $0x7fffffffffffffff,%rax
ffffffff804bd590:        0 	ff ff 7f 
ffffffff804bd593:        0 	66 41 bf 00 fe       	mov    $0xfe00,%r15w
ffffffff804bd598:        0 	48 39 c2             	cmp    %rax,%rdx
ffffffff804bd59b:        0 	e9 89 01 00 00       	jmpq   ffffffff804bd729 <tcp_recvmsg+0x2bb>
ffffffff804bd5a0:      597 	48 8b ab a8 00 00 00 	mov    0xa8(%rbx),%rbp
ffffffff804bd5a7:     4601 	48 3b 6c 24 28       	cmp    0x28(%rsp),%rbp
ffffffff804bd5ac:        1 	b8 00 00 00 00       	mov    $0x0,%eax
ffffffff804bd5b1:     1769 	48 0f 44 e8          	cmove  %rax,%rbp
ffffffff804bd5b5:      473 	48 85 ed             	test   %rbp,%rbp
ffffffff804bd5b8:        0 	74 76                	je     ffffffff804bd630 <tcp_recvmsg+0x1c2>
ffffffff804bd5ba:      595 	48 8b 4c 24 40       	mov    0x40(%rsp),%rcx
ffffffff804bd5bf:      897 	8b 55 50             	mov    0x50(%rbp),%edx
ffffffff804bd5c2:       89 	8b 31                	mov    (%rcx),%esi
ffffffff804bd5c4:      581 	41 89 f5             	mov    %esi,%r13d
ffffffff804bd5c7:      301 	41 29 d5             	sub    %edx,%r13d
ffffffff804bd5ca:       33 	79 10                	jns    ffffffff804bd5dc <tcp_recvmsg+0x16e>
ffffffff804bd5cc:        0 	48 c7 c7 48 d9 6a 80 	mov    $0xffffffff806ad948,%rdi
ffffffff804bd5d3:        0 	31 c0                	xor    %eax,%eax
ffffffff804bd5d5:        0 	e8 9a 97 d7 ff       	callq  ffffffff80236d74 <printk>
ffffffff804bd5da:        0 	eb 54                	jmp    ffffffff804bd630 <tcp_recvmsg+0x1c2>
ffffffff804bd5dc:      584 	8b 85 b8 00 00 00    	mov    0xb8(%rbp),%eax
ffffffff804bd5e2:     1061 	48 8b 95 d0 00 00 00 	mov    0xd0(%rbp),%rdx
ffffffff804bd5e9:        1 	8a 54 02 0d          	mov    0xd(%rdx,%rax,1),%dl
ffffffff804bd5ed:        0 	88 d0                	mov    %dl,%al
ffffffff804bd5ef:      876 	83 e0 02             	and    $0x2,%eax
ffffffff804bd5f2:        0 	3c 01                	cmp    $0x1,%al
ffffffff804bd5f4:        0 	8b 45 68             	mov    0x68(%rbp),%eax
ffffffff804bd5f7:      909 	41 83 d5 ff          	adc    $0xffffffffffffffff,%r13d
ffffffff804bd5fb:        0 	41 39 c5             	cmp    %eax,%r13d
ffffffff804bd5fe:        0 	0f 82 df 02 00 00    	jb     ffffffff804bd8e3 <tcp_recvmsg+0x475>
ffffffff804bd604:        0 	80 e2 01             	and    $0x1,%dl
ffffffff804bd607:        0 	0f 85 16 04 00 00    	jne    ffffffff804bda23 <tcp_recvmsg+0x5b5>
ffffffff804bd60d:        0 	83 7c 24 3c 00       	cmpl   $0x0,0x3c(%rsp)
ffffffff804bd612:        0 	75 11                	jne    ffffffff804bd625 <tcp_recvmsg+0x1b7>
ffffffff804bd614:        0 	be 53 05 00 00       	mov    $0x553,%esi
ffffffff804bd619:        0 	48 c7 c7 13 d9 6a 80 	mov    $0xffffffff806ad913,%rdi
ffffffff804bd620:        0 	e8 90 8b d7 ff       	callq  ffffffff802361b5 <warn_on_slowpath>
ffffffff804bd625:        0 	48 8b 6d 00          	mov    0x0(%rbp),%rbp
ffffffff804bd629:        0 	48 3b 6c 24 28       	cmp    0x28(%rsp),%rbp
ffffffff804bd62e:        0 	75 85                	jne    ffffffff804bd5b5 <tcp_recvmsg+0x147>
ffffffff804bd630:       80 	44 3b 7c 24 4c       	cmp    0x4c(%rsp),%r15d
ffffffff804bd635:     4164 	7c 0b                	jl     ffffffff804bd642 <tcp_recvmsg+0x1d4>
ffffffff804bd637:        0 	48 83 7b 68 00       	cmpq   $0x0,0x68(%rbx)
ffffffff804bd63c:        0 	0f 84 07 04 00 00    	je     ffffffff804bda49 <tcp_recvmsg+0x5db>
ffffffff804bd642:        1 	45 85 ff             	test   %r15d,%r15d
ffffffff804bd645:     3438 	74 49                	je     ffffffff804bd690 <tcp_recvmsg+0x222>
ffffffff804bd647:        0 	83 bb 44 01 00 00 00 	cmpl   $0x0,0x144(%rbx)
ffffffff804bd64e:        0 	0f 85 f5 03 00 00    	jne    ffffffff804bda49 <tcp_recvmsg+0x5db>
ffffffff804bd654:        0 	8a 43 02             	mov    0x2(%rbx),%al
ffffffff804bd657:        0 	3c 07                	cmp    $0x7,%al
ffffffff804bd659:        0 	0f 84 ea 03 00 00    	je     ffffffff804bda49 <tcp_recvmsg+0x5db>
ffffffff804bd65f:        0 	f6 43 38 01          	testb  $0x1,0x38(%rbx)
ffffffff804bd663:        0 	0f 85 e0 03 00 00    	jne    ffffffff804bda49 <tcp_recvmsg+0x5db>
ffffffff804bd669:        0 	48 83 7c 24 58 00    	cmpq   $0x0,0x58(%rsp)
ffffffff804bd66f:        0 	0f 84 d4 03 00 00    	je     ffffffff804bda49 <tcp_recvmsg+0x5db>
ffffffff804bd675:        0 	65 48 8b 3c 25 00 00 	mov    %gs:0x0,%rdi
ffffffff804bd67c:        0 	00 00 
ffffffff804bd67e:        0 	e8 3a e0 ff ff       	callq  ffffffff804bb6bd <signal_pending>
ffffffff804bd683:        0 	85 c0                	test   %eax,%eax
ffffffff804bd685:        0 	0f 84 ac 00 00 00    	je     ffffffff804bd737 <tcp_recvmsg+0x2c9>
ffffffff804bd68b:        0 	e9 b9 03 00 00       	jmpq   ffffffff804bda49 <tcp_recvmsg+0x5db>
ffffffff804bd690:        0 	be 01 00 00 00       	mov    $0x1,%esi
ffffffff804bd695:     4166 	48 89 df             	mov    %rbx,%rdi
ffffffff804bd698:        0 	e8 7b de ff ff       	callq  ffffffff804bb518 <sock_flag>
ffffffff804bd69d:        0 	85 c0                	test   %eax,%eax
ffffffff804bd69f:      276 	0f 85 a4 03 00 00    	jne    ffffffff804bda49 <tcp_recvmsg+0x5db>
ffffffff804bd6a5:      126 	83 bb 44 01 00 00 00 	cmpl   $0x0,0x144(%rbx)
ffffffff804bd6ac:        0 	74 10                	je     ffffffff804bd6be <tcp_recvmsg+0x250>
ffffffff804bd6ae:        0 	48 89 df             	mov    %rbx,%rdi
ffffffff804bd6b1:        0 	e8 00 df ff ff       	callq  ffffffff804bb5b6 <sock_error>
ffffffff804bd6b6:        0 	41 89 c7             	mov    %eax,%r15d
ffffffff804bd6b9:        0 	e9 8b 03 00 00       	jmpq   ffffffff804bda49 <tcp_recvmsg+0x5db>
ffffffff804bd6be:      112 	f6 43 38 01          	testb  $0x1,0x38(%rbx)
ffffffff804bd6c2:     3451 	0f 85 81 03 00 00    	jne    ffffffff804bda49 <tcp_recvmsg+0x5db>
ffffffff804bd6c8:      497 	8a 43 02             	mov    0x2(%rbx),%al
ffffffff804bd6cb:        0 	3c 07                	cmp    $0x7,%al
ffffffff804bd6cd:      113 	75 20                	jne    ffffffff804bd6ef <tcp_recvmsg+0x281>
ffffffff804bd6cf:        0 	be 01 00 00 00       	mov    $0x1,%esi
ffffffff804bd6d4:        0 	48 89 df             	mov    %rbx,%rdi
ffffffff804bd6d7:        0 	e8 3c de ff ff       	callq  ffffffff804bb518 <sock_flag>
ffffffff804bd6dc:        0 	85 c0                	test   %eax,%eax
ffffffff804bd6de:        0 	0f 85 65 03 00 00    	jne    ffffffff804bda49 <tcp_recvmsg+0x5db>
ffffffff804bd6e4:        0 	41 bf 95 ff ff ff    	mov    $0xffffff95,%r15d
ffffffff804bd6ea:        0 	e9 5a 03 00 00       	jmpq   ffffffff804bda49 <tcp_recvmsg+0x5db>
ffffffff804bd6ef:      118 	48 83 7c 24 58 00    	cmpq   $0x0,0x58(%rsp)
ffffffff804bd6f5:      398 	75 0b                	jne    ffffffff804bd702 <tcp_recvmsg+0x294>
ffffffff804bd6f7:        0 	41 bf f5 ff ff ff    	mov    $0xfffffff5,%r15d
ffffffff804bd6fd:        0 	e9 47 03 00 00       	jmpq   ffffffff804bda49 <tcp_recvmsg+0x5db>
ffffffff804bd702:        0 	65 48 8b 3c 25 00 00 	mov    %gs:0x0,%rdi
ffffffff804bd709:        0 	00 00 
ffffffff804bd70b:     2993 	e8 ad df ff ff       	callq  ffffffff804bb6bd <signal_pending>
ffffffff804bd710:      200 	85 c0                	test   %eax,%eax
ffffffff804bd712:        0 	74 23                	je     ffffffff804bd737 <tcp_recvmsg+0x2c9>
ffffffff804bd714:        0 	48 b8 ff ff ff ff ff 	mov    $0x7fffffffffffffff,%rax
ffffffff804bd71b:        0 	ff ff 7f 
ffffffff804bd71e:        0 	48 39 44 24 58       	cmp    %rax,0x58(%rsp)
ffffffff804bd723:        0 	41 bf 00 fe ff ff    	mov    $0xfffffe00,%r15d
ffffffff804bd729:        0 	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
ffffffff804bd72e:        0 	44 0f 45 f8          	cmovne %eax,%r15d
ffffffff804bd732:        0 	e9 12 03 00 00       	jmpq   ffffffff804bda49 <tcp_recvmsg+0x5db>
ffffffff804bd737:      207 	44 89 fe             	mov    %r15d,%esi
ffffffff804bd73a:      198 	48 89 df             	mov    %rbx,%rdi
ffffffff804bd73d:        0 	e8 cc e9 ff ff       	callq  ffffffff804bc10e <tcp_cleanup_rbuf>
ffffffff804bd742:      227 	83 3d 9b ad 3f 00 00 	cmpl   $0x0,0x3fad9b(%rip)        # ffffffff808b84e4 <sysctl_tcp_low_latency>
ffffffff804bd749:      210 	0f 85 81 00 00 00    	jne    ffffffff804bd7d0 <tcp_recvmsg+0x362>
ffffffff804bd74f:        0 	48 8b ab 28 04 00 00 	mov    0x428(%rbx),%rbp
ffffffff804bd756:        0 	48 3b 6c 24 50       	cmp    0x50(%rsp),%rbp
ffffffff804bd75b:      232 	75 73                	jne    ffffffff804bd7d0 <tcp_recvmsg+0x362>
ffffffff804bd75d:        0 	48 83 7c 24 50 00    	cmpq   $0x0,0x50(%rsp)
ffffffff804bd763:        7 	75 27                	jne    ffffffff804bd78c <tcp_recvmsg+0x31e>
ffffffff804bd765:      229 	83 7c 24 1c 00       	cmpl   $0x0,0x1c(%rsp)
ffffffff804bd76a:       30 	75 20                	jne    ffffffff804bd78c <tcp_recvmsg+0x31e>
ffffffff804bd76c:        7 	48 8b 54 24 30       	mov    0x30(%rsp),%rdx
ffffffff804bd771:      191 	65 48 8b 2c 25 00 00 	mov    %gs:0x0,%rbp
ffffffff804bd778:        0 	00 00 
ffffffff804bd77a:       12 	48 89 ab 28 04 00 00 	mov    %rbp,0x428(%rbx)
ffffffff804bd781:     2617 	48 8b 42 10          	mov    0x10(%rdx),%rax
ffffffff804bd785:      670 	48 89 83 30 04 00 00 	mov    %rax,0x430(%rbx)
ffffffff804bd78c:       11 	8b 83 f4 03 00 00    	mov    0x3f4(%rbx),%eax
ffffffff804bd792:      188 	3b 83 f0 03 00 00    	cmp    0x3f0(%rbx),%eax
ffffffff804bd798:      166 	44 89 b3 3c 04 00 00 	mov    %r14d,0x43c(%rbx)
ffffffff804bd79f:        5 	74 18                	je     ffffffff804bd7b9 <tcp_recvmsg+0x34b>
ffffffff804bd7a1:        0 	83 7c 24 1c 00       	cmpl   $0x0,0x1c(%rsp)
ffffffff804bd7a6:        0 	75 11                	jne    ffffffff804bd7b9 <tcp_recvmsg+0x34b>
ffffffff804bd7a8:        0 	be 92 05 00 00       	mov    $0x592,%esi
ffffffff804bd7ad:        0 	48 c7 c7 13 d9 6a 80 	mov    $0xffffffff806ad913,%rdi
ffffffff804bd7b4:        0 	e8 fc 89 d7 ff       	callq  ffffffff802361b5 <warn_on_slowpath>
ffffffff804bd7b9:      336 	48 8b 4c 24 20       	mov    0x20(%rsp),%rcx
ffffffff804bd7be:      302 	48 39 8b 10 04 00 00 	cmp    %rcx,0x410(%rbx)
ffffffff804bd7c5:     1176 	48 89 6c 24 50       	mov    %rbp,0x50(%rsp)
ffffffff804bd7ca:      244 	0f 85 81 00 00 00    	jne    ffffffff804bd851 <tcp_recvmsg+0x3e3>
ffffffff804bd7d0:      135 	44 3b 7c 24 4c       	cmp    0x4c(%rsp),%r15d
ffffffff804bd7d5:      112 	7c 12                	jl     ffffffff804bd7e9 <tcp_recvmsg+0x37b>
ffffffff804bd7d7:        0 	48 89 df             	mov    %rbx,%rdi
ffffffff804bd7da:        0 	e8 57 7f fc ff       	callq  ffffffff80485736 <release_sock>
ffffffff804bd7df:        0 	48 89 df             	mov    %rbx,%rdi
ffffffff804bd7e2:        0 	e8 96 e5 ff ff       	callq  ffffffff804bbd7d <lock_sock>
ffffffff804bd7e7:        0 	eb 0d                	jmp    ffffffff804bd7f6 <tcp_recvmsg+0x388>
ffffffff804bd7e9:      152 	48 8d 74 24 58       	lea    0x58(%rsp),%rsi
ffffffff804bd7ee:      563 	48 89 df             	mov    %rbx,%rdi
ffffffff804bd7f1:       59 	e8 83 99 fc ff       	callq  ffffffff80487179 <sk_wait_data>
ffffffff804bd7f6:       86 	48 83 7c 24 50 00    	cmpq   $0x0,0x50(%rsp)
ffffffff804bd7fc:     8550 	0f 84 8a 00 00 00    	je     ffffffff804bd88c <tcp_recvmsg+0x41e>
ffffffff804bd802:     4038 	44 89 f1             	mov    %r14d,%ecx
ffffffff804bd805:      900 	2b 8b 3c 04 00 00    	sub    0x43c(%rbx),%ecx
ffffffff804bd80b:        5 	74 28                	je     ffffffff804bd835 <tcp_recvmsg+0x3c7>
ffffffff804bd80d:        0 	48 8b 05 ac 3e 5f 00 	mov    0x5f3eac(%rip),%rax        # ffffffff80ab16c0 <init_net+0xf0>
ffffffff804bd814:        1 	41 01 cf             	add    %ecx,%r15d
ffffffff804bd817:        0 	65 8b 14 25 24 00 00 	mov    %gs:0x24,%edx
ffffffff804bd81e:        0 	00 
ffffffff804bd81f:        0 	89 d2                	mov    %edx,%edx
ffffffff804bd821:        0 	48 f7 d0             	not    %rax
ffffffff804bd824:        0 	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
ffffffff804bd828:        0 	48 63 d1             	movslq %ecx,%rdx
ffffffff804bd82b:        0 	49 29 d6             	sub    %rdx,%r14
ffffffff804bd82e:        0 	48 01 90 b8 00 00 00 	add    %rdx,0xb8(%rax)
ffffffff804bd835:        4 	8b 83 f0 03 00 00    	mov    0x3f0(%rbx),%eax
ffffffff804bd83b:      373 	3b 83 f4 03 00 00    	cmp    0x3f4(%rbx),%eax
ffffffff804bd841:     3604 	75 49                	jne    ffffffff804bd88c <tcp_recvmsg+0x41e>
ffffffff804bd843:        0 	48 8b 44 24 20       	mov    0x20(%rsp),%rax
ffffffff804bd848:      971 	48 39 83 10 04 00 00 	cmp    %rax,0x410(%rbx)
ffffffff804bd84f:       11 	74 3b                	je     ffffffff804bd88c <tcp_recvmsg+0x41e>
ffffffff804bd851:        6 	48 89 df             	mov    %rbx,%rdi
ffffffff804bd854:      267 	e8 94 e6 ff ff       	callq  ffffffff804bbeed <tcp_prequeue_process>
ffffffff804bd859:        0 	44 89 f1             	mov    %r14d,%ecx
ffffffff804bd85c:      879 	2b 8b 3c 04 00 00    	sub    0x43c(%rbx),%ecx
ffffffff804bd862:      256 	74 28                	je     ffffffff804bd88c <tcp_recvmsg+0x41e>
ffffffff804bd864:        0 	48 8b 05 55 3e 5f 00 	mov    0x5f3e55(%rip),%rax        # ffffffff80ab16c0 <init_net+0xf0>
ffffffff804bd86b:      116 	41 01 cf             	add    %ecx,%r15d
ffffffff804bd86e:       17 	65 8b 14 25 24 00 00 	mov    %gs:0x24,%edx
ffffffff804bd875:        0 	00 
ffffffff804bd876:        0 	89 d2                	mov    %edx,%edx
ffffffff804bd878:        1 	48 f7 d0             	not    %rax
ffffffff804bd87b:        5 	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
ffffffff804bd87f:        0 	48 63 d1             	movslq %ecx,%rdx
ffffffff804bd882:        6 	49 29 d6             	sub    %rdx,%r14
ffffffff804bd885:        7 	48 01 90 c0 00 00 00 	add    %rdx,0xc0(%rax)
ffffffff804bd88c:       11 	83 7c 24 3c 00       	cmpl   $0x0,0x3c(%rsp)
ffffffff804bd891:      438 	0f 84 a9 01 00 00    	je     ffffffff804bda40 <tcp_recvmsg+0x5d2>
ffffffff804bd897:        0 	8b 44 24 60          	mov    0x60(%rsp),%eax
ffffffff804bd89b:        0 	3b 83 f4 03 00 00    	cmp    0x3f4(%rbx),%eax
ffffffff804bd8a1:        0 	0f 84 99 01 00 00    	je     ffffffff804bda40 <tcp_recvmsg+0x5d2>
ffffffff804bd8a7:        0 	e8 19 ad fd ff       	callq  ffffffff804985c5 <net_ratelimit>
ffffffff804bd8ac:        0 	85 c0                	test   %eax,%eax
ffffffff804bd8ae:        0 	74 24                	je     ffffffff804bd8d4 <tcp_recvmsg+0x466>
ffffffff804bd8b0:        0 	65 48 8b 34 25 00 00 	mov    %gs:0x0,%rsi
ffffffff804bd8b7:        0 	00 00 
ffffffff804bd8b9:        0 	8b 96 70 01 00 00    	mov    0x170(%rsi),%edx
ffffffff804bd8bf:        0 	48 c7 c7 6a d9 6a 80 	mov    $0xffffffff806ad96a,%rdi
ffffffff804bd8c6:        0 	48 81 c6 68 03 00 00 	add    $0x368,%rsi
ffffffff804bd8cd:        0 	31 c0                	xor    %eax,%eax
ffffffff804bd8cf:        0 	e8 a0 94 d7 ff       	callq  ffffffff80236d74 <printk>
ffffffff804bd8d4:        0 	8b 83 f4 03 00 00    	mov    0x3f4(%rbx),%eax
ffffffff804bd8da:        0 	89 44 24 60          	mov    %eax,0x60(%rsp)
ffffffff804bd8de:        0 	e9 5d 01 00 00       	jmpq   ffffffff804bda40 <tcp_recvmsg+0x5d2>
ffffffff804bd8e3:     4077 	44 29 e8             	sub    %r13d,%eax
ffffffff804bd8e6:     6031 	4d 89 f4             	mov    %r14,%r12
ffffffff804bd8e9:        0 	4c 39 f0             	cmp    %r14,%rax
ffffffff804bd8ec:        0 	4c 0f 46 e0          	cmovbe %rax,%r12
ffffffff804bd8f0:      934 	66 83 bb 7c 04 00 00 	cmpw   $0x0,0x47c(%rbx)
ffffffff804bd8f7:        0 	00 
ffffffff804bd8f8:        0 	74 38                	je     ffffffff804bd932 <tcp_recvmsg+0x4c4>
ffffffff804bd8fa:        0 	8b 83 84 05 00 00    	mov    0x584(%rbx),%eax
ffffffff804bd900:        0 	29 f0                	sub    %esi,%eax
ffffffff804bd902:        0 	89 c2                	mov    %eax,%edx
ffffffff804bd904:        0 	4c 39 e2             	cmp    %r12,%rdx
ffffffff804bd907:        0 	73 29                	jae    ffffffff804bd932 <tcp_recvmsg+0x4c4>
ffffffff804bd909:        0 	85 c0                	test   %eax,%eax
ffffffff804bd90b:        0 	74 05                	je     ffffffff804bd912 <tcp_recvmsg+0x4a4>
ffffffff804bd90d:        0 	49 89 d4             	mov    %rdx,%r12
ffffffff804bd910:        0 	eb 20                	jmp    ffffffff804bd932 <tcp_recvmsg+0x4c4>
ffffffff804bd912:        0 	be 02 00 00 00       	mov    $0x2,%esi
ffffffff804bd917:        0 	48 89 df             	mov    %rbx,%rdi
ffffffff804bd91a:        0 	e8 f9 db ff ff       	callq  ffffffff804bb518 <sock_flag>
ffffffff804bd91f:        0 	85 c0                	test   %eax,%eax
ffffffff804bd921:        0 	75 0f                	jne    ffffffff804bd932 <tcp_recvmsg+0x4c4>
ffffffff804bd923:        0 	48 8b 54 24 40       	mov    0x40(%rsp),%rdx
ffffffff804bd928:        0 	41 ff c5             	inc    %r13d
ffffffff804bd92b:        0 	ff 02                	incl   (%rdx)
ffffffff804bd92d:        0 	49 ff cc             	dec    %r12
ffffffff804bd930:        0 	74 4c                	je     ffffffff804bd97e <tcp_recvmsg+0x510>
ffffffff804bd932:      906 	83 7c 24 0c 00       	cmpl   $0x0,0xc(%rsp)
ffffffff804bd937:     6039 	75 2f                	jne    ffffffff804bd968 <tcp_recvmsg+0x4fa>
ffffffff804bd939:       48 	48 8b 4c 24 30       	mov    0x30(%rsp),%rcx
ffffffff804bd93e:     1412 	44 89 ee             	mov    %r13d,%esi
ffffffff804bd941:     6648 	48 89 ef             	mov    %rbp,%rdi
ffffffff804bd944:        0 	48 8b 51 10          	mov    0x10(%rcx),%rdx
ffffffff804bd948:     1524 	44 89 e1             	mov    %r12d,%ecx
ffffffff804bd94b:      167 	e8 c5 d3 fc ff       	callq  ffffffff8048ad15 <skb_copy_datagram_iovec>
ffffffff804bd950:        0 	85 c0                	test   %eax,%eax
ffffffff804bd952:     1038 	74 14                	je     ffffffff804bd968 <tcp_recvmsg+0x4fa>
ffffffff804bd954:        0 	45 85 ff             	test   %r15d,%r15d
ffffffff804bd957:        0 	0f 85 ec 00 00 00    	jne    ffffffff804bda49 <tcp_recvmsg+0x5db>
ffffffff804bd95d:        0 	41 bf f2 ff ff ff    	mov    $0xfffffff2,%r15d
ffffffff804bd963:        0 	e9 e1 00 00 00       	jmpq   ffffffff804bda49 <tcp_recvmsg+0x5db>
ffffffff804bd968:       28 	48 8b 54 24 40       	mov    0x40(%rsp),%rdx
ffffffff804bd96d:     5713 	48 89 df             	mov    %rbx,%rdi
ffffffff804bd970:      241 	45 01 e7             	add    %r12d,%r15d
ffffffff804bd973:       27 	4d 29 e6             	sub    %r12,%r14
ffffffff804bd976:      626 	44 01 22             	add    %r12d,(%rdx)
ffffffff804bd979:      221 	e8 fe 11 00 00       	callq  ffffffff804beb7c <tcp_rcv_space_adjust>
ffffffff804bd97e:     1425 	66 83 bb 7c 04 00 00 	cmpw   $0x0,0x47c(%rbx)
ffffffff804bd985:        0 	00 
ffffffff804bd986:     3430 	74 63                	je     ffffffff804bd9eb <tcp_recvmsg+0x57d>
ffffffff804bd988:        0 	8b 8b f4 03 00 00    	mov    0x3f4(%rbx),%ecx
ffffffff804bd98e:        0 	39 8b 84 05 00 00    	cmp    %ecx,0x584(%rbx)
ffffffff804bd994:        0 	79 55                	jns    ffffffff804bd9eb <tcp_recvmsg+0x57d>
ffffffff804bd996:        0 	48 8b 44 24 10       	mov    0x10(%rsp),%rax
ffffffff804bd99b:        0 	48 39 83 f8 04 00 00 	cmp    %rax,0x4f8(%rbx)
ffffffff804bd9a2:        0 	66 c7 83 7c 04 00 00 	movw   $0x0,0x47c(%rbx)
ffffffff804bd9a9:        0 	00 00 
ffffffff804bd9ab:        0 	75 3e                	jne    ffffffff804bd9eb <tcp_recvmsg+0x57d>
ffffffff804bd9ad:        0 	83 bb c0 04 00 00 00 	cmpl   $0x0,0x4c0(%rbx)
ffffffff804bd9b4:        0 	74 35                	je     ffffffff804bd9eb <tcp_recvmsg+0x57d>
ffffffff804bd9b6:        0 	8b 83 94 00 00 00    	mov    0x94(%rbx),%eax
ffffffff804bd9bc:        0 	3b 43 3c             	cmp    0x3c(%rbx),%eax
ffffffff804bd9bf:        0 	7d 2a                	jge    ffffffff804bd9eb <tcp_recvmsg+0x57d>
ffffffff804bd9c1:        0 	0f b7 83 e8 03 00 00 	movzwl 0x3e8(%rbx),%eax
ffffffff804bd9c8:        0 	8a 8b 9d 04 00 00    	mov    0x49d(%rbx),%cl
ffffffff804bd9ce:        0 	8b 93 44 04 00 00    	mov    0x444(%rbx),%edx
ffffffff804bd9d4:        0 	83 e1 0f             	and    $0xf,%ecx
ffffffff804bd9d7:        0 	c1 e0 1a             	shl    $0x1a,%eax
ffffffff804bd9da:        0 	d3 ea                	shr    %cl,%edx
ffffffff804bd9dc:        0 	09 d0                	or     %edx,%eax
ffffffff804bd9de:        0 	0d 00 00 10 00       	or     $0x100000,%eax
ffffffff804bd9e3:        0 	0f c8                	bswap  %eax
ffffffff804bd9e5:        0 	89 83 ec 03 00 00    	mov    %eax,0x3ec(%rbx)
ffffffff804bd9eb:        0 	8b 55 68             	mov    0x68(%rbp),%edx
ffffffff804bd9ee:     1655 	44 89 e8             	mov    %r13d,%eax
ffffffff804bd9f1:       32 	4c 01 e0             	add    %r12,%rax
ffffffff804bd9f4:        0 	48 39 d0             	cmp    %rdx,%rax
ffffffff804bd9f7:      847 	72 47                	jb     ffffffff804bda40 <tcp_recvmsg+0x5d2>
ffffffff804bd9f9:        0 	8b 95 b8 00 00 00    	mov    0xb8(%rbp),%edx
ffffffff804bd9ff:       80 	48 8b 85 d0 00 00 00 	mov    0xd0(%rbp),%rax
ffffffff804bda06:      441 	f6 44 02 0d 01       	testb  $0x1,0xd(%rdx,%rax,1)
ffffffff804bda0b:        0 	75 16                	jne    ffffffff804bda23 <tcp_recvmsg+0x5b5>
ffffffff804bda0d:        0 	83 7c 24 3c 00       	cmpl   $0x0,0x3c(%rsp)
ffffffff804bda12:      453 	75 2c                	jne    ffffffff804bda40 <tcp_recvmsg+0x5d2>
ffffffff804bda14:        0 	31 d2                	xor    %edx,%edx
ffffffff804bda16:        0 	48 89 ee             	mov    %rbp,%rsi
ffffffff804bda19:      477 	48 89 df             	mov    %rbx,%rdi
ffffffff804bda1c:        0 	e8 0f e4 ff ff       	callq  ffffffff804bbe30 <sk_eat_skb>
ffffffff804bda21:      562 	eb 1d                	jmp    ffffffff804bda40 <tcp_recvmsg+0x5d2>
ffffffff804bda23:        0 	48 8b 54 24 40       	mov    0x40(%rsp),%rdx
ffffffff804bda28:        0 	ff 02                	incl   (%rdx)
ffffffff804bda2a:        0 	83 7c 24 3c 00       	cmpl   $0x0,0x3c(%rsp)
ffffffff804bda2f:        0 	75 18                	jne    ffffffff804bda49 <tcp_recvmsg+0x5db>
ffffffff804bda31:        0 	31 d2                	xor    %edx,%edx
ffffffff804bda33:        0 	48 89 ee             	mov    %rbp,%rsi
ffffffff804bda36:        0 	48 89 df             	mov    %rbx,%rdi
ffffffff804bda39:        0 	e8 f2 e3 ff ff       	callq  ffffffff804bbe30 <sk_eat_skb>
ffffffff804bda3e:        0 	eb 09                	jmp    ffffffff804bda49 <tcp_recvmsg+0x5db>
ffffffff804bda40:      959 	4d 85 f6             	test   %r14,%r14
ffffffff804bda43:     4766 	0f 85 f8 fa ff ff    	jne    ffffffff804bd541 <tcp_recvmsg+0xd3>
ffffffff804bda49:      217 	48 83 7c 24 50 00    	cmpq   $0x0,0x50(%rsp)
ffffffff804bda4f:     2084 	74 71                	je     ffffffff804bdac2 <tcp_recvmsg+0x654>
ffffffff804bda51:       40 	48 8d 83 10 04 00 00 	lea    0x410(%rbx),%rax
ffffffff804bda58:      448 	48 39 83 10 04 00 00 	cmp    %rax,0x410(%rbx)
ffffffff804bda5f:        4 	74 4c                	je     ffffffff804bdaad <tcp_recvmsg+0x63f>
ffffffff804bda61:        0 	31 c0                	xor    %eax,%eax
ffffffff804bda63:        0 	45 85 ff             	test   %r15d,%r15d
ffffffff804bda66:        0 	48 89 df             	mov    %rbx,%rdi
ffffffff804bda69:        0 	41 0f 4f c6          	cmovg  %r14d,%eax
ffffffff804bda6d:        0 	89 83 3c 04 00 00    	mov    %eax,0x43c(%rbx)
ffffffff804bda73:        0 	e8 75 e4 ff ff       	callq  ffffffff804bbeed <tcp_prequeue_process>
ffffffff804bda78:        0 	45 85 ff             	test   %r15d,%r15d
ffffffff804bda7b:        0 	7e 30                	jle    ffffffff804bdaad <tcp_recvmsg+0x63f>
ffffffff804bda7d:        0 	44 89 f1             	mov    %r14d,%ecx
ffffffff804bda80:        0 	2b 8b 3c 04 00 00    	sub    0x43c(%rbx),%ecx
ffffffff804bda86:        0 	74 25                	je     ffffffff804bdaad <tcp_recvmsg+0x63f>
ffffffff804bda88:        0 	48 8b 05 31 3c 5f 00 	mov    0x5f3c31(%rip),%rax        # ffffffff80ab16c0 <init_net+0xf0>
ffffffff804bda8f:        0 	41 01 cf             	add    %ecx,%r15d
ffffffff804bda92:        0 	65 8b 14 25 24 00 00 	mov    %gs:0x24,%edx
ffffffff804bda99:        0 	00 
ffffffff804bda9a:        0 	89 d2                	mov    %edx,%edx
ffffffff804bda9c:        0 	48 f7 d0             	not    %rax
ffffffff804bda9f:        0 	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
ffffffff804bdaa3:        0 	48 63 c1             	movslq %ecx,%rax
ffffffff804bdaa6:        0 	48 01 82 c0 00 00 00 	add    %rax,0xc0(%rdx)
ffffffff804bdaad:      214 	48 c7 83 28 04 00 00 	movq   $0x0,0x428(%rbx)
ffffffff804bdab4:        0 	00 00 00 00 
ffffffff804bdab8:     1530 	c7 83 3c 04 00 00 00 	movl   $0x0,0x43c(%rbx)
ffffffff804bdabf:        0 	00 00 00 
ffffffff804bdac2:     1135 	48 89 df             	mov    %rbx,%rdi
ffffffff804bdac5:     3909 	44 89 fe             	mov    %r15d,%esi
ffffffff804bdac8:        0 	e8 41 e6 ff ff       	callq  ffffffff804bc10e <tcp_cleanup_rbuf>
ffffffff804bdacd:     1724 	48 89 df             	mov    %rbx,%rdi
ffffffff804bdad0:      932 	e8 61 7c fc ff       	callq  ffffffff80485736 <release_sock>
ffffffff804bdad5:     4661 	e9 12 01 00 00       	jmpq   ffffffff804bdbec <tcp_recvmsg+0x77e>
ffffffff804bdada:        0 	41 bc 95 ff ff ff    	mov    $0xffffff95,%r12d
ffffffff804bdae0:        0 	48 89 df             	mov    %rbx,%rdi
ffffffff804bdae3:        0 	45 89 e7             	mov    %r12d,%r15d
ffffffff804bdae6:        0 	e8 4b 7c fc ff       	callq  ffffffff80485736 <release_sock>
ffffffff804bdaeb:        0 	e9 fc 00 00 00       	jmpq   ffffffff804bdbec <tcp_recvmsg+0x77e>
ffffffff804bdaf0:        0 	be 02 00 00 00       	mov    $0x2,%esi
ffffffff804bdaf5:        0 	48 89 df             	mov    %rbx,%rdi
ffffffff804bdaf8:        0 	e8 1b da ff ff       	callq  ffffffff804bb518 <sock_flag>
ffffffff804bdafd:        0 	85 c0                	test   %eax,%eax
ffffffff804bdaff:        0 	0f 85 d4 00 00 00    	jne    ffffffff804bdbd9 <tcp_recvmsg+0x76b>
ffffffff804bdb05:        0 	8b 83 7c 04 00 00    	mov    0x47c(%rbx),%eax
ffffffff804bdb0b:        0 	66 85 c0             	test   %ax,%ax
ffffffff804bdb0e:        0 	0f 84 c5 00 00 00    	je     ffffffff804bdbd9 <tcp_recvmsg+0x76b>
ffffffff804bdb14:        0 	66 3d 00 04          	cmp    $0x400,%ax
ffffffff804bdb18:        0 	0f 84 bb 00 00 00    	je     ffffffff804bdbd9 <tcp_recvmsg+0x76b>
ffffffff804bdb1e:        0 	8a 43 02             	mov    0x2(%rbx),%al
ffffffff804bdb21:        0 	3c 07                	cmp    $0x7,%al
ffffffff804bdb23:        0 	75 17                	jne    ffffffff804bdb3c <tcp_recvmsg+0x6ce>
ffffffff804bdb25:        0 	be 01 00 00 00       	mov    $0x1,%esi
ffffffff804bdb2a:        0 	48 89 df             	mov    %rbx,%rdi
ffffffff804bdb2d:        0 	41 bc 95 ff ff ff    	mov    $0xffffff95,%r12d
ffffffff804bdb33:        0 	e8 e0 d9 ff ff       	callq  ffffffff804bb518 <sock_flag>
ffffffff804bdb38:        0 	85 c0                	test   %eax,%eax
ffffffff804bdb3a:        0 	74 a4                	je     ffffffff804bdae0 <tcp_recvmsg+0x672>
ffffffff804bdb3c:        0 	8b 83 7c 04 00 00    	mov    0x47c(%rbx),%eax
ffffffff804bdb42:        0 	f6 c4 01             	test   $0x1,%ah
ffffffff804bdb45:        0 	74 79                	je     ffffffff804bdbc0 <tcp_recvmsg+0x752>
ffffffff804bdb47:        0 	40 f6 c5 02          	test   $0x2,%bpl
ffffffff804bdb4b:        0 	88 44 24 67          	mov    %al,0x67(%rsp)
ffffffff804bdb4f:        0 	75 09                	jne    ffffffff804bdb5a <tcp_recvmsg+0x6ec>
ffffffff804bdb51:        0 	66 c7 83 7c 04 00 00 	movw   $0x400,0x47c(%rbx)
ffffffff804bdb58:        0 	00 04 
ffffffff804bdb5a:        0 	48 8b 4c 24 30       	mov    0x30(%rsp),%rcx
ffffffff804bdb5f:        0 	45 89 f4             	mov    %r14d,%r12d
ffffffff804bdb62:        0 	8b 51 30             	mov    0x30(%rcx),%edx
ffffffff804bdb65:        0 	89 d0                	mov    %edx,%eax
ffffffff804bdb67:        0 	83 c8 01             	or     $0x1,%eax
ffffffff804bdb6a:        0 	45 85 f6             	test   %r14d,%r14d
ffffffff804bdb6d:        0 	89 41 30             	mov    %eax,0x30(%rcx)
ffffffff804bdb70:        0 	7e 33                	jle    ffffffff804bdba5 <tcp_recvmsg+0x737>
ffffffff804bdb72:        0 	40 80 e5 20          	and    $0x20,%bpl
ffffffff804bdb76:        0 	41 bc 01 00 00 00    	mov    $0x1,%r12d
ffffffff804bdb7c:        0 	0f 85 5e ff ff ff    	jne    ffffffff804bdae0 <tcp_recvmsg+0x672>
ffffffff804bdb82:        0 	48 8b 79 10          	mov    0x10(%rcx),%rdi
ffffffff804bdb86:        0 	48 8d 74 24 67       	lea    0x67(%rsp),%rsi
ffffffff804bdb8b:        0 	ba 01 00 00 00       	mov    $0x1,%edx
ffffffff804bdb90:        0 	41 bc f2 ff ff ff    	mov    $0xfffffff2,%r12d
ffffffff804bdb96:        0 	e8 8a cb fc ff       	callq  ffffffff8048a725 <memcpy_toiovec>
ffffffff804bdb9b:        0 	85 c0                	test   %eax,%eax
ffffffff804bdb9d:        0 	0f 85 3d ff ff ff    	jne    ffffffff804bdae0 <tcp_recvmsg+0x672>
ffffffff804bdba3:        0 	eb 10                	jmp    ffffffff804bdbb5 <tcp_recvmsg+0x747>
ffffffff804bdba5:        0 	48 8b 44 24 30       	mov    0x30(%rsp),%rax
ffffffff804bdbaa:        0 	83 ca 21             	or     $0x21,%edx
ffffffff804bdbad:        0 	89 50 30             	mov    %edx,0x30(%rax)
ffffffff804bdbb0:        0 	e9 2b ff ff ff       	jmpq   ffffffff804bdae0 <tcp_recvmsg+0x672>
ffffffff804bdbb5:        0 	41 bc 01 00 00 00    	mov    $0x1,%r12d
ffffffff804bdbbb:        0 	e9 20 ff ff ff       	jmpq   ffffffff804bdae0 <tcp_recvmsg+0x672>
ffffffff804bdbc0:        0 	8a 43 02             	mov    0x2(%rbx),%al
ffffffff804bdbc3:        0 	3c 07                	cmp    $0x7,%al
ffffffff804bdbc5:        0 	74 1d                	je     ffffffff804bdbe4 <tcp_recvmsg+0x776>
ffffffff804bdbc7:        0 	f6 43 38 01          	testb  $0x1,0x38(%rbx)
ffffffff804bdbcb:        0 	41 bc f5 ff ff ff    	mov    $0xfffffff5,%r12d
ffffffff804bdbd1:        0 	0f 84 09 ff ff ff    	je     ffffffff804bdae0 <tcp_recvmsg+0x672>
ffffffff804bdbd7:        0 	eb 0b                	jmp    ffffffff804bdbe4 <tcp_recvmsg+0x776>
ffffffff804bdbd9:        0 	41 bc ea ff ff ff    	mov    $0xffffffea,%r12d
ffffffff804bdbdf:        0 	e9 fc fe ff ff       	jmpq   ffffffff804bdae0 <tcp_recvmsg+0x672>
ffffffff804bdbe4:        0 	45 31 e4             	xor    %r12d,%r12d
ffffffff804bdbe7:        0 	e9 f4 fe ff ff       	jmpq   ffffffff804bdae0 <tcp_recvmsg+0x672>
ffffffff804bdbec:     1206 	48 83 c4 68          	add    $0x68,%rsp
ffffffff804bdbf0:      498 	44 89 f8             	mov    %r15d,%eax
ffffffff804bdbf3:      387 	5b                   	pop    %rbx
ffffffff804bdbf4:      462 	5d                   	pop    %rbp
ffffffff804bdbf5:        0 	41 5c                	pop    %r12
ffffffff804bdbf7:      485 	41 5d                	pop    %r13
ffffffff804bdbf9:      466 	41 5e                	pop    %r14
ffffffff804bdbfb:        0 	41 5f                	pop    %r15
ffffffff804bdbfd:      796 	c3                   	retq   

no real hotspots either - but a bit too fractured code sequence, so 
this function's icache footprint is too probably double the size of 
what it could be.

a bit of overhead (8%) leaks in from a callsite:

ffffffff804bd46e:      882 	41 57                	push   %r15
ffffffff804bd470:    15507 	48 89 f7             	mov    %rsi,%rdi

(this is used as a dynamic function pointer too so i'm just guessing 
that the common callsite would be sock_common_recvmsg().)

perhaps this sequence, about 7% of the total overhead of this 
function, warrants mention:

ffffffff804bd7e2:        0 	e8 96 e5 ff ff       	callq  ffffffff804bbd7d <lock_sock>
ffffffff804bd7e7:        0 	eb 0d                	jmp    ffffffff804bd7f6 <tcp_recvmsg+0x388>
ffffffff804bd7e9:      152 	48 8d 74 24 58       	lea    0x58(%rsp),%rsi
ffffffff804bd7ee:      563 	48 89 df             	mov    %rbx,%rdi
ffffffff804bd7f1:       59 	e8 83 99 fc ff       	callq  ffffffff80487179 <sk_wait_data>
ffffffff804bd7f6:       86 	48 83 7c 24 50 00    	cmpq   $0x0,0x50(%rsp)
ffffffff804bd7fc:     8550 	0f 84 8a 00 00 00    	je     ffffffff804bd88c <tcp_recvmsg+0x41e>
ffffffff804bd802:     4038 	44 89 f1             	mov    %r14d,%ecx

that's most likely lock_sock[_nested]()'s overhead leaking over into 
this function:

ffffffff804857cb:     9392 <lock_sock_nested>:
ffffffff804857cb:     9392 	41 55                	push   %r13
ffffffff804857cd:     4112 	41 54                	push   %r12
ffffffff804857cf:        2 	55                   	push   %rbp
ffffffff804857d0:        7 	48 8d 6f 40          	lea    0x40(%rdi),%rbp
ffffffff804857d4:     1515 	53                   	push   %rbx
ffffffff804857d5:        0 	48 89 fb             	mov    %rdi,%rbx
ffffffff804857d8:        4 	48 89 ef             	mov    %rbp,%rdi
ffffffff804857db:     1461 	48 83 ec 38          	sub    $0x38,%rsp
ffffffff804857df:        8 	e8 78 11 09 00       	callq  ffffffff8051695c <_spin_lock_bh>
ffffffff804857e4:     4827 	83 7b 44 00          	cmpl   $0x0,0x44(%rbx)
ffffffff804857e8:     2937 	74 6d                	je     ffffffff80485857 <lock_sock_nested+0x8c>
ffffffff804857ea:        0 	65 48 8b 14 25 00 00 	mov    %gs:0x0,%rdx
ffffffff804857f1:        0 	00 00 
ffffffff804857f3:        0 	fc                   	cld    
ffffffff804857f4:        0 	31 c0                	xor    %eax,%eax
ffffffff804857f6:        0 	48 89 e7             	mov    %rsp,%rdi
ffffffff804857f9:        0 	b9 0a 00 00 00       	mov    $0xa,%ecx
ffffffff804857fe:        0 	f3 ab                	rep stos %eax,%es:(%rdi)
ffffffff80485800:        0 	48 8d 44 24 18       	lea    0x18(%rsp),%rax
ffffffff80485805:        0 	4c 8d 63 48          	lea    0x48(%rbx),%r12
ffffffff80485809:        0 	48 89 54 24 08       	mov    %rdx,0x8(%rsp)
ffffffff8048580e:        0 	48 c7 44 24 10 80 78 	movq   $0xffffffff80247880,0x10(%rsp)
ffffffff80485815:        0 	24 80 
ffffffff80485817:        0 	48 89 44 24 18       	mov    %rax,0x18(%rsp)
ffffffff8048581c:        0 	48 89 44 24 20       	mov    %rax,0x20(%rsp)
ffffffff80485821:        0 	ba 02 00 00 00       	mov    $0x2,%edx
ffffffff80485826:        0 	48 89 e6             	mov    %rsp,%rsi
ffffffff80485829:        0 	4c 89 e7             	mov    %r12,%rdi
ffffffff8048582c:        0 	e8 fd 20 dc ff       	callq  ffffffff8024792e <prepare_to_wait_exclusive>
ffffffff80485831:        0 	48 89 ef             	mov    %rbp,%rdi
ffffffff80485834:        0 	e8 18 11 09 00       	callq  ffffffff80516951 <_spin_unlock_bh>
ffffffff80485839:        0 	e8 52 f9 08 00       	callq  ffffffff80515190 <schedule>
ffffffff8048583e:        0 	48 89 ef             	mov    %rbp,%rdi
ffffffff80485841:        0 	e8 16 11 09 00       	callq  ffffffff8051695c <_spin_lock_bh>
ffffffff80485846:        0 	83 7b 44 00          	cmpl   $0x0,0x44(%rbx)
ffffffff8048584a:        0 	75 d5                	jne    ffffffff80485821 <lock_sock_nested+0x56>
ffffffff8048584c:        0 	48 89 e6             	mov    %rsp,%rsi
ffffffff8048584f:        0 	4c 89 e7             	mov    %r12,%rdi
ffffffff80485852:        0 	e8 7a 20 dc ff       	callq  ffffffff802478d1 <finish_wait>
ffffffff80485857:       88 	c7 43 44 01 00 00 00 	movl   $0x1,0x44(%rbx)
ffffffff8048585e:     3431 	fe 43 40             	incb   0x40(%rbx)
ffffffff80485861:     1568 	e8 00 4e db ff       	callq  ffffffff8023a666 <local_bh_enable>
ffffffff80485866:     1548 	48 83 c4 38          	add    $0x38,%rsp
ffffffff8048586a:       61 	5b                   	pop    %rbx
ffffffff8048586b:     1568 	5d                   	pop    %rbp
ffffffff8048586c:       36 	41 5c                	pop    %r12
ffffffff8048586e:        0 	41 5d                	pop    %r13
ffffffff80485870:     2753 	c3                   	retq   

which is:

1748	void lock_sock_nested(struct sock *sk, int subclass)
1749	{
1750		might_sleep();
1751		spin_lock_bh(&sk->sk_lock.slock);
1752		if (sk->sk_lock.owned)
1753			__lock_sock(sk);
1754		sk->sk_lock.owned = 1;
1755		spin_unlock(&sk->sk_lock.slock);

that branch in the middle should perhaps be:

		if (unlikely(sk->sk_lock.owned))

to make this function fall-through.

	Ingo
