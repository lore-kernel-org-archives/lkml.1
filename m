Return-Path: <linux-kernel-owner+w=401wt.eu-S1756086AbYKQVKt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756086AbYKQVKt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 16:10:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755950AbYKQVJt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 16:09:49 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:45490 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755930AbYKQVJl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 16:09:41 -0500
Date: Mon, 17 Nov 2008 22:09:06 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Eric Dumazet <dada1@cosmosbay.com>, David Miller <davem@davemloft.net>,
       rjw@sisk.pl, linux-kernel@vger.kernel.org,
       kernel-testers@vger.kernel.org, cl@linux-foundation.org, efault@gmx.de,
       a.p.zijlstra@chello.nl, Stephen Hemminger <shemminger@vyatta.com>
Subject: tcp_ack(): Re: [Bug #11308] tbench regression on each kernel
	release from 2.6.22 -&gt; 2.6.28
Message-ID: <20081117210906.GF12020@elte.hu>
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
>   1.997533 tcp_ack

                      hits (total: 199753)
                 .........
ffffffff804c0b17:      452 <tcp_ack>:
ffffffff804c0b17:      452 	41 57                	push   %r15
ffffffff804c0b19:     9569 	41 56                	push   %r14
ffffffff804c0b1b:        0 	41 55                	push   %r13
ffffffff804c0b1d:        0 	49 89 f5             	mov    %rsi,%r13
ffffffff804c0b20:      493 	41 54                	push   %r12
ffffffff804c0b22:      104 	41 89 d4             	mov    %edx,%r12d
ffffffff804c0b25:        0 	55                   	push   %rbp
ffffffff804c0b26:      425 	48 89 fd             	mov    %rdi,%rbp
ffffffff804c0b29:       21 	53                   	push   %rbx
ffffffff804c0b2a:        0 	48 81 ec 88 00 00 00 	sub    $0x88,%rsp
ffffffff804c0b31:      445 	8b 87 00 04 00 00    	mov    0x400(%rdi),%eax
ffffffff804c0b37:        0 	89 44 24 18          	mov    %eax,0x18(%rsp)
ffffffff804c0b3b:      443 	48 8d 46 38          	lea    0x38(%rsi),%rax
ffffffff804c0b3f:       18 	8b 50 28             	mov    0x28(%rax),%edx
ffffffff804c0b42:     2565 	44 8b 70 18          	mov    0x18(%rax),%r14d
ffffffff804c0b46:      358 	89 54 24 1c          	mov    %edx,0x1c(%rsp)
ffffffff804c0b4a:        2 	39 97 fc 03 00 00    	cmp    %edx,0x3fc(%rdi)
ffffffff804c0b50:      368 	0f 88 af 13 00 00    	js     ffffffff804c1f05 <tcp_ack+0x13ee>
ffffffff804c0b56:      106 	89 d1                	mov    %edx,%ecx
ffffffff804c0b58:        2 	2b 4c 24 18          	sub    0x18(%rsp),%ecx
ffffffff804c0b5c:      328 	0f 88 83 13 00 00    	js     ffffffff804c1ee5 <tcp_ack+0x13ce>
ffffffff804c0b62:     1440 	8b 44 24 18          	mov    0x18(%rsp),%eax
ffffffff804c0b66:        2 	29 d0                	sub    %edx,%eax
ffffffff804c0b68:       77 	44 89 e2             	mov    %r12d,%edx
ffffffff804c0b6b:      398 	89 c6                	mov    %eax,%esi
ffffffff804c0b6d:        3 	80 ce 04             	or     $0x4,%dh
ffffffff804c0b70:       65 	c1 ee 1f             	shr    $0x1f,%esi
ffffffff804c0b73:      362 	44 0f 45 e2          	cmovne %edx,%r12d
ffffffff804c0b77:        1 	83 3d ea 78 3f 00 00 	cmpl   $0x0,0x3f78ea(%rip)        # ffffffff808b8468 <sysctl_tcp_abc>
ffffffff804c0b7e:       64 	74 27                	je     ffffffff804c0ba7 <tcp_ack+0x90>
ffffffff804c0b80:        0 	8a 87 78 03 00 00    	mov    0x378(%rdi),%al
ffffffff804c0b86:        0 	3c 01                	cmp    $0x1,%al
ffffffff804c0b88:        0 	77 08                	ja     ffffffff804c0b92 <tcp_ack+0x7b>
ffffffff804c0b8a:        0 	01 8f dc 04 00 00    	add    %ecx,0x4dc(%rdi)
ffffffff804c0b90:        0 	eb 15                	jmp    ffffffff804c0ba7 <tcp_ack+0x90>
ffffffff804c0b92:        0 	3c 04                	cmp    $0x4,%al
ffffffff804c0b94:        0 	75 11                	jne    ffffffff804c0ba7 <tcp_ack+0x90>
ffffffff804c0b96:        0 	8b 87 4c 04 00 00    	mov    0x44c(%rdi),%eax
ffffffff804c0b9c:        0 	39 c1                	cmp    %eax,%ecx
ffffffff804c0b9e:        0 	0f 46 c1             	cmovbe %ecx,%eax
ffffffff804c0ba1:        0 	01 87 dc 04 00 00    	add    %eax,0x4dc(%rdi)
ffffffff804c0ba7:      377 	8b 9d d4 04 00 00    	mov    0x4d4(%rbp),%ebx
ffffffff804c0bad:     3672 	41 f7 c4 00 01 00 00 	test   $0x100,%r12d
ffffffff804c0bb4:      282 	89 5c 24 20          	mov    %ebx,0x20(%rsp)
ffffffff804c0bb8:        0 	8b 85 74 04 00 00    	mov    0x474(%rbp),%eax
ffffffff804c0bbe:      140 	89 44 24 30          	mov    %eax,0x30(%rsp)
ffffffff804c0bc2:     7592 	8b 95 d0 04 00 00    	mov    0x4d0(%rbp),%edx
ffffffff804c0bc8:     1580 	89 54 24 24          	mov    %edx,0x24(%rsp)
ffffffff804c0bcc:        3 	8b 9d cc 04 00 00    	mov    0x4cc(%rbp),%ebx
ffffffff804c0bd2:       58 	89 5c 24 28          	mov    %ebx,0x28(%rsp)
ffffffff804c0bd6:      419 	8b 85 78 04 00 00    	mov    0x478(%rbp),%eax
ffffffff804c0bdc:        0 	89 44 24 2c          	mov    %eax,0x2c(%rsp)
ffffffff804c0be0:       65 	75 4f                	jne    ffffffff804c0c31 <tcp_ack+0x11a>
ffffffff804c0be2:      423 	85 f6                	test   %esi,%esi
ffffffff804c0be4:       55 	74 4b                	je     ffffffff804c0c31 <tcp_ack+0x11a>
ffffffff804c0be6:       36 	44 89 b5 40 04 00 00 	mov    %r14d,0x440(%rbp)
ffffffff804c0bed:      368 	8b 54 24 1c          	mov    0x1c(%rsp),%edx
ffffffff804c0bf1:        4 	41 83 cc 02          	or     $0x2,%r12d
ffffffff804c0bf5:       32 	be 05 00 00 00       	mov    $0x5,%esi
ffffffff804c0bfa:      392 	48 89 ef             	mov    %rbp,%rdi
ffffffff804c0bfd:        4 	89 95 00 04 00 00    	mov    %edx,0x400(%rbp)
ffffffff804c0c03:     3341 	44 89 64 24 5c       	mov    %r12d,0x5c(%rsp)
ffffffff804c0c08:      855 	e8 98 dc ff ff       	callq  ffffffff804be8a5 <tcp_ca_event>
ffffffff804c0c0d:     2018 	48 8b 05 a4 0a 5f 00 	mov    0x5f0aa4(%rip),%rax        # ffffffff80ab16b8 <init_net+0xe8>
ffffffff804c0c14:      858 	65 8b 14 25 24 00 00 	mov    %gs:0x24,%edx
ffffffff804c0c1b:        0 	00 
ffffffff804c0c1c:        0 	89 d2                	mov    %edx,%edx
ffffffff804c0c1e:        0 	48 f7 d0             	not    %rax
ffffffff804c0c21:      425 	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
ffffffff804c0c25:        0 	48 ff 80 e8 00 00 00 	incq   0xe8(%rax)
ffffffff804c0c2c:        0 	e9 1b 01 00 00       	jmpq   ffffffff804c0d4c <tcp_ack+0x235>
ffffffff804c0c31:       41 	45 3b 75 54          	cmp    0x54(%r13),%r14d
ffffffff804c0c35:      360 	74 06                	je     ffffffff804c0c3d <tcp_ack+0x126>
ffffffff804c0c37:        1 	41 83 cc 01          	or     $0x1,%r12d
ffffffff804c0c3b:       80 	eb 1f                	jmp    ffffffff804c0c5c <tcp_ack+0x145>
ffffffff804c0c3d:        1 	48 8b 05 74 0a 5f 00 	mov    0x5f0a74(%rip),%rax        # ffffffff80ab16b8 <init_net+0xe8>
ffffffff804c0c44:      303 	65 8b 14 25 24 00 00 	mov    %gs:0x24,%edx
ffffffff804c0c4b:        0 	00 
ffffffff804c0c4c:       56 	89 d2                	mov    %edx,%edx
ffffffff804c0c4e:        0 	48 f7 d0             	not    %rax
ffffffff804c0c51:        4 	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
ffffffff804c0c55:       13 	48 ff 80 e0 00 00 00 	incq   0xe0(%rax)
ffffffff804c0c5c:       12 	41 8b 95 b8 00 00 00 	mov    0xb8(%r13),%edx
ffffffff804c0c63:      300 	49 03 95 d0 00 00 00 	add    0xd0(%r13),%rdx
ffffffff804c0c6a:       17 	66 8b 42 0e          	mov    0xe(%rdx),%ax
ffffffff804c0c6e:        0 	66 c1 c0 08          	rol    $0x8,%ax
ffffffff804c0c72:       22 	f6 42 0d 02          	testb  $0x2,0xd(%rdx)
ffffffff804c0c76:       13 	0f b7 d8             	movzwl %ax,%ebx
ffffffff804c0c79:        0 	75 0b                	jne    ffffffff804c0c86 <tcp_ack+0x16f>
ffffffff804c0c7b:       26 	8a 8d 9d 04 00 00    	mov    0x49d(%rbp),%cl
ffffffff804c0c81:      343 	83 e1 0f             	and    $0xf,%ecx
ffffffff804c0c84:        0 	d3 e3                	shl    %cl,%ebx
ffffffff804c0c86:       82 	8b 74 24 1c          	mov    0x1c(%rsp),%esi
ffffffff804c0c8a:       18 	44 89 f2             	mov    %r14d,%edx
ffffffff804c0c8d:        0 	89 d9                	mov    %ebx,%ecx
ffffffff804c0c8f:       12 	48 89 ef             	mov    %rbp,%rdi
ffffffff804c0c92:       12 	e8 47 e6 ff ff       	callq  ffffffff804bf2de <tcp_may_update_window>
ffffffff804c0c97:       16 	31 d2                	xor    %edx,%edx
ffffffff804c0c99:       66 	85 c0                	test   %eax,%eax
ffffffff804c0c9b:        0 	74 48                	je     ffffffff804c0ce5 <tcp_ack+0x1ce>
ffffffff804c0c9d:       12 	39 9d 44 04 00 00    	cmp    %ebx,0x444(%rbp)
ffffffff804c0ca3:       29 	44 89 b5 40 04 00 00 	mov    %r14d,0x440(%rbp)
ffffffff804c0caa:        0 	74 34                	je     ffffffff804c0ce0 <tcp_ack+0x1c9>
ffffffff804c0cac:        7 	89 9d 44 04 00 00    	mov    %ebx,0x444(%rbp)
ffffffff804c0cb2:       59 	c7 85 ec 03 00 00 00 	movl   $0x0,0x3ec(%rbp)
ffffffff804c0cb9:        0 	00 00 00 
ffffffff804c0cbc:        0 	48 89 ef             	mov    %rbp,%rdi
ffffffff804c0cbf:        7 	e8 13 e8 ff ff       	callq  ffffffff804bf4d7 <tcp_fast_path_check>
ffffffff804c0cc4:       23 	3b 9d 48 04 00 00    	cmp    0x448(%rbp),%ebx
ffffffff804c0cca:       48 	76 14                	jbe    ffffffff804c0ce0 <tcp_ack+0x1c9>
ffffffff804c0ccc:        0 	8b b5 5c 03 00 00    	mov    0x35c(%rbp),%esi
ffffffff804c0cd2:        0 	89 9d 48 04 00 00    	mov    %ebx,0x448(%rbp)
ffffffff804c0cd8:        0 	48 89 ef             	mov    %rbp,%rdi
ffffffff804c0cdb:        0 	e8 40 41 00 00       	callq  ffffffff804c4e20 <tcp_sync_mss>
ffffffff804c0ce0:        6 	ba 02 00 00 00       	mov    $0x2,%edx
ffffffff804c0ce5:      141 	8b 5c 24 1c          	mov    0x1c(%rsp),%ebx
ffffffff804c0ce9:        1 	44 09 e2             	or     %r12d,%edx
ffffffff804c0cec:        3 	89 9d 00 04 00 00    	mov    %ebx,0x400(%rbp)
ffffffff804c0cf2:       34 	89 54 24 5c          	mov    %edx,0x5c(%rsp)
ffffffff804c0cf6:        0 	41 80 7d 5d 00       	cmpb   $0x0,0x5d(%r13)
ffffffff804c0cfb:        6 	74 13                	je     ffffffff804c0d10 <tcp_ack+0x1f9>
ffffffff804c0cfd:        0 	8b 54 24 18          	mov    0x18(%rsp),%edx
ffffffff804c0d01:        0 	4c 89 ee             	mov    %r13,%rsi
ffffffff804c0d04:        0 	48 89 ef             	mov    %rbp,%rdi
ffffffff804c0d07:        0 	e8 b4 f5 ff ff       	callq  ffffffff804c02c0 <tcp_sacktag_write_queue>
ffffffff804c0d0c:        0 	09 44 24 5c          	or     %eax,0x5c(%rsp)
ffffffff804c0d10:       29 	41 8b 85 b8 00 00 00 	mov    0xb8(%r13),%eax
ffffffff804c0d17:      128 	49 03 85 d0 00 00 00 	add    0xd0(%r13),%rax
ffffffff804c0d1e:        0 	8a 40 0d             	mov    0xd(%rax),%al
ffffffff804c0d21:       33 	83 e0 42             	and    $0x42,%eax
ffffffff804c0d24:        0 	3c 40                	cmp    $0x40,%al
ffffffff804c0d26:        0 	75 17                	jne    ffffffff804c0d3f <tcp_ack+0x228>
ffffffff804c0d28:        0 	8b 44 24 5c          	mov    0x5c(%rsp),%eax
ffffffff804c0d2c:        0 	83 c8 40             	or     $0x40,%eax
ffffffff804c0d2f:        0 	f6 85 7e 04 00 00 01 	testb  $0x1,0x47e(%rbp)
ffffffff804c0d36:        0 	0f 44 44 24 5c       	cmove  0x5c(%rsp),%eax
ffffffff804c0d3b:        0 	89 44 24 5c          	mov    %eax,0x5c(%rsp)
ffffffff804c0d3f:       36 	be 06 00 00 00       	mov    $0x6,%esi
ffffffff804c0d44:      167 	48 89 ef             	mov    %rbp,%rdi
ffffffff804c0d47:        1 	e8 59 db ff ff       	callq  ffffffff804be8a5 <tcp_ca_event>
ffffffff804c0d4c:      581 	c7 85 48 01 00 00 00 	movl   $0x0,0x148(%rbp)
ffffffff804c0d53:        0 	00 00 00 
ffffffff804c0d56:     6076 	c6 85 7d 03 00 00 00 	movb   $0x0,0x37d(%rbp)
ffffffff804c0d5d:        0 	48 8b 05 1c 8b 3f 00 	mov    0x3f8b1c(%rip),%rax        # ffffffff808b9880 <jiffies>
ffffffff804c0d64:      443 	89 85 08 04 00 00    	mov    %eax,0x408(%rbp)
ffffffff804c0d6a:        0 	8b 85 74 04 00 00    	mov    0x474(%rbp),%eax
ffffffff804c0d70:        0 	85 c0                	test   %eax,%eax
ffffffff804c0d72:      845 	89 44 24 14          	mov    %eax,0x14(%rsp)
ffffffff804c0d76:        0 	0f 84 fb 10 00 00    	je     ffffffff804c1e77 <tcp_ack+0x1360>
ffffffff804c0d7c:        0 	48 8b 05 fd 8a 3f 00 	mov    0x3f8afd(%rip),%rax        # ffffffff808b9880 <jiffies>
ffffffff804c0d83:      586 	8b 54 24 14          	mov    0x14(%rsp),%edx
ffffffff804c0d87:        1 	41 83 cc ff          	or     $0xffffffffffffffff,%r12d
ffffffff804c0d8b:        2 	89 44 24 48          	mov    %eax,0x48(%rsp)
ffffffff804c0d8f:      879 	89 54 24 34          	mov    %edx,0x34(%rsp)
ffffffff804c0d93:        1 	8b 9d d0 04 00 00    	mov    0x4d0(%rbp),%ebx
ffffffff804c0d99:        0 	89 5c 24 40          	mov    %ebx,0x40(%rsp)
ffffffff804c0d9d:      889 	e8 e2 e8 ff ff       	callq  ffffffff804bf684 <net_invalid_timestamp>
ffffffff804c0da2:        0 	48 89 44 24 08       	mov    %rax,0x8(%rsp)
ffffffff804c0da7:       16 	48 8d 85 c0 00 00 00 	lea    0xc0(%rbp),%rax
ffffffff804c0dae:      445 	c7 44 24 44 01 00 00 	movl   $0x1,0x44(%rsp)
ffffffff804c0db5:        0 	00 
ffffffff804c0db6:        0 	c7 44 24 50 00 00 00 	movl   $0x0,0x50(%rsp)
ffffffff804c0dbd:        0 	00 
ffffffff804c0dbe:       10 	c7 44 24 38 00 00 00 	movl   $0x0,0x38(%rsp)
ffffffff804c0dc5:        0 	00 
ffffffff804c0dc6:     1308 	44 89 64 24 4c       	mov    %r12d,0x4c(%rsp)
ffffffff804c0dcb:      225 	48 89 04 24          	mov    %rax,(%rsp)
ffffffff804c0dcf:        2 	e9 8b 02 00 00       	jmpq   ffffffff804c105f <tcp_ack+0x548>
ffffffff804c0dd4:      488 	4d 8d 7d 38          	lea    0x38(%r13),%r15
ffffffff804c0dd8:     2298 	41 8a 57 25          	mov    0x25(%r15),%dl
ffffffff804c0ddc:        0 	88 54 24 3f          	mov    %dl,0x3f(%rsp)
ffffffff804c0de0:        6 	41 8b 77 1c          	mov    0x1c(%r15),%esi
ffffffff804c0de4:      455 	8b 95 00 04 00 00    	mov    0x400(%rbp),%edx
ffffffff804c0dea:        3 	49 8b 8d d0 00 00 00 	mov    0xd0(%r13),%rcx
ffffffff804c0df1:        0 	41 8b 85 c8 00 00 00 	mov    0xc8(%r13),%eax
ffffffff804c0df8:      440 	39 f2                	cmp    %esi,%edx
ffffffff804c0dfa:        0 	79 6f                	jns    ffffffff804c0e6b <tcp_ack+0x354>
ffffffff804c0dfc:        0 	89 c0                	mov    %eax,%eax
ffffffff804c0dfe:       39 	8b 5c 08 08          	mov    0x8(%rax,%rcx,1),%ebx
ffffffff804c0e02:        0 	66 83 fb 01          	cmp    $0x1,%bx
ffffffff804c0e06:        2 	0f 84 77 02 00 00    	je     ffffffff804c1083 <tcp_ack+0x56c>
ffffffff804c0e0c:        0 	41 8b 47 18          	mov    0x18(%r15),%eax
ffffffff804c0e10:        0 	39 d0                	cmp    %edx,%eax
ffffffff804c0e12:        0 	0f 89 6b 02 00 00    	jns    ffffffff804c1083 <tcp_ack+0x56c>
ffffffff804c0e18:        0 	29 c2                	sub    %eax,%edx
ffffffff804c0e1a:        0 	4c 89 ee             	mov    %r13,%rsi
ffffffff804c0e1d:        0 	48 89 ef             	mov    %rbp,%rdi
ffffffff804c0e20:        0 	e8 8f 4f 00 00       	callq  ffffffff804c5db4 <tcp_trim_head>
ffffffff804c0e25:        0 	85 c0                	test   %eax,%eax
ffffffff804c0e27:        0 	0f 85 56 02 00 00    	jne    ffffffff804c1083 <tcp_ack+0x56c>
ffffffff804c0e2d:        0 	41 8b 85 c8 00 00 00 	mov    0xc8(%r13),%eax
ffffffff804c0e34:        0 	0f b7 d3             	movzwl %bx,%edx
ffffffff804c0e37:        0 	49 03 85 d0 00 00 00 	add    0xd0(%r13),%rax
ffffffff804c0e3e:        0 	41 89 d6             	mov    %edx,%r14d
ffffffff804c0e41:        0 	8b 48 08             	mov    0x8(%rax),%ecx
ffffffff804c0e44:        0 	0f b7 c1             	movzwl %cx,%eax
ffffffff804c0e47:        0 	41 29 c6             	sub    %eax,%r14d
ffffffff804c0e4a:        0 	0f 84 33 02 00 00    	je     ffffffff804c1083 <tcp_ack+0x56c>
ffffffff804c0e50:        0 	66 85 c9             	test   %cx,%cx
ffffffff804c0e53:        0 	75 04                	jne    ffffffff804c0e59 <tcp_ack+0x342>
ffffffff804c0e55:        0 	0f 0b                	ud2a   
ffffffff804c0e57:        0 	eb fe                	jmp    ffffffff804c0e57 <tcp_ack+0x340>
ffffffff804c0e59:        0 	41 8b 5f 1c          	mov    0x1c(%r15),%ebx
ffffffff804c0e5d:        0 	41 39 5f 18          	cmp    %ebx,0x18(%r15)
ffffffff804c0e61:        0 	0f 88 d6 10 00 00    	js     ffffffff804c1f3d <tcp_ack+0x1426>
ffffffff804c0e67:        0 	0f 0b                	ud2a   
ffffffff804c0e69:        0 	eb fe                	jmp    ffffffff804c0e69 <tcp_ack+0x352>
ffffffff804c0e6b:        0 	83 7c 24 44 00       	cmpl   $0x0,0x44(%rsp)
ffffffff804c0e70:     6326 	89 c0                	mov    %eax,%eax
ffffffff804c0e72:      348 	44 0f b7 74 08 08    	movzwl 0x8(%rax,%rcx,1),%r14d
ffffffff804c0e78:        0 	0f 84 8f 00 00 00    	je     ffffffff804c0f0d <tcp_ack+0x3f6>
ffffffff804c0e7e:      132 	83 bd a4 03 00 00 00 	cmpl   $0x0,0x3a4(%rbp)
ffffffff804c0e85:     5840 	0f 84 82 00 00 00    	je     ffffffff804c0f0d <tcp_ack+0x3f6>
ffffffff804c0e8b:        0 	3b b5 b4 05 00 00    	cmp    0x5b4(%rbp),%esi
ffffffff804c0e91:        0 	78 7a                	js     ffffffff804c0f0d <tcp_ack+0x3f6>
ffffffff804c0e93:        0 	48 89 ef             	mov    %rbp,%rdi
ffffffff804c0e96:        0 	e8 21 da ff ff       	callq  ffffffff804be8bc <tcp_current_ssthresh>
ffffffff804c0e9b:        0 	8b b5 4c 04 00 00    	mov    0x44c(%rbp),%esi
ffffffff804c0ea1:        0 	44 8b a5 ac 04 00 00 	mov    0x4ac(%rbp),%r12d
ffffffff804c0ea8:        0 	48 89 ef             	mov    %rbp,%rdi
ffffffff804c0eab:        0 	89 85 6c 05 00 00    	mov    %eax,0x56c(%rbp)
ffffffff804c0eb1:        0 	e8 c7 3e 00 00       	callq  ffffffff804c4d7d <tcp_mss_to_mtu>
ffffffff804c0eb6:        0 	8b 9d a4 03 00 00    	mov    0x3a4(%rbp),%ebx
ffffffff804c0ebc:        0 	31 d2                	xor    %edx,%edx
ffffffff804c0ebe:        0 	c7 85 b0 04 00 00 00 	movl   $0x0,0x4b0(%rbp)
ffffffff804c0ec5:        0 	00 00 00 
ffffffff804c0ec8:        0 	41 0f af c4          	imul   %r12d,%eax
ffffffff804c0ecc:        0 	48 89 ef             	mov    %rbp,%rdi
ffffffff804c0ecf:        0 	f7 f3                	div    %ebx
ffffffff804c0ed1:        0 	89 85 ac 04 00 00    	mov    %eax,0x4ac(%rbp)
ffffffff804c0ed7:        0 	48 8b 05 a2 89 3f 00 	mov    0x3f89a2(%rip),%rax        # ffffffff808b9880 <jiffies>
ffffffff804c0ede:        0 	89 85 bc 04 00 00    	mov    %eax,0x4bc(%rbp)
ffffffff804c0ee4:        0 	e8 d3 d9 ff ff       	callq  ffffffff804be8bc <tcp_current_ssthresh>
ffffffff804c0ee9:        0 	8b b5 5c 03 00 00    	mov    0x35c(%rbp),%esi
ffffffff804c0eef:        0 	89 85 54 04 00 00    	mov    %eax,0x454(%rbp)
ffffffff804c0ef5:        0 	48 89 ef             	mov    %rbp,%rdi
ffffffff804c0ef8:        0 	89 9d a0 03 00 00    	mov    %ebx,0x3a0(%rbp)
ffffffff804c0efe:        0 	c7 85 a4 03 00 00 00 	movl   $0x0,0x3a4(%rbp)
ffffffff804c0f05:        0 	00 00 00 
ffffffff804c0f08:        0 	e8 13 3f 00 00       	callq  ffffffff804c4e20 <tcp_sync_mss>
ffffffff804c0f0d:      945 	0f b6 44 24 3f       	movzbl 0x3f(%rsp),%eax
ffffffff804c0f12:     6361 	a8 82                	test   $0x82,%al
ffffffff804c0f14:        0 	74 30                	je     ffffffff804c0f46 <tcp_ack+0x42f>
ffffffff804c0f16:        0 	a8 02                	test   $0x2,%al
ffffffff804c0f18:        0 	74 07                	je     ffffffff804c0f21 <tcp_ack+0x40a>
ffffffff804c0f1a:        0 	44 29 b5 78 04 00 00 	sub    %r14d,0x478(%rbp)
ffffffff804c0f21:        0 	83 4c 24 50 08       	orl    $0x8,0x50(%rsp)
ffffffff804c0f26:        0 	f6 44 24 50 04       	testb  $0x4,0x50(%rsp)
ffffffff804c0f2b:        0 	75 06                	jne    ffffffff804c0f33 <tcp_ack+0x41c>
ffffffff804c0f2d:        0 	41 83 fe 01          	cmp    $0x1,%r14d
ffffffff804c0f31:        0 	76 08                	jbe    ffffffff804c0f3b <tcp_ack+0x424>
ffffffff804c0f33:        0 	81 4c 24 50 00 10 00 	orl    $0x1000,0x50(%rsp)
ffffffff804c0f3a:        0 	00 
ffffffff804c0f3b:        0 	41 83 cc ff          	or     $0xffffffffffffffff,%r12d
ffffffff804c0f3f:        0 	44 89 64 24 4c       	mov    %r12d,0x4c(%rsp)
ffffffff804c0f44:        0 	eb 38                	jmp    ffffffff804c0f7e <tcp_ack+0x467>
ffffffff804c0f46:        0 	44 8b 64 24 48       	mov    0x48(%rsp),%r12d
ffffffff804c0f4b:     5837 	45 2b 67 20          	sub    0x20(%r15),%r12d
ffffffff804c0f4f:        1 	83 7c 24 4c 00       	cmpl   $0x0,0x4c(%rsp)
ffffffff804c0f54:      167 	8b 5c 24 4c          	mov    0x4c(%rsp),%ebx
ffffffff804c0f58:      514 	49 8b 55 18          	mov    0x18(%r13),%rdx
ffffffff804c0f5c:        0 	41 0f 48 dc          	cmovs  %r12d,%ebx
ffffffff804c0f60:      164 	a8 01                	test   $0x1,%al
ffffffff804c0f62:      413 	48 89 54 24 08       	mov    %rdx,0x8(%rsp)
ffffffff804c0f67:        0 	89 5c 24 4c          	mov    %ebx,0x4c(%rsp)
ffffffff804c0f6b:      148 	75 11                	jne    ffffffff804c0f7e <tcp_ack+0x467>
ffffffff804c0f6d:     1608 	8b 54 24 38          	mov    0x38(%rsp),%edx
ffffffff804c0f71:        0 	39 54 24 34          	cmp    %edx,0x34(%rsp)
ffffffff804c0f75:      272 	0f 46 54 24 34       	cmovbe 0x34(%rsp),%edx
ffffffff804c0f7a:      266 	89 54 24 34          	mov    %edx,0x34(%rsp)
ffffffff804c0f7e:        0 	a8 01                	test   $0x1,%al
ffffffff804c0f80:      164 	74 07                	je     ffffffff804c0f89 <tcp_ack+0x472>
ffffffff804c0f82:        0 	44 29 b5 d0 04 00 00 	sub    %r14d,0x4d0(%rbp)
ffffffff804c0f89:     3955 	a8 04                	test   $0x4,%al
ffffffff804c0f8b:     8510 	74 07                	je     ffffffff804c0f94 <tcp_ack+0x47d>
ffffffff804c0f8d:        0 	44 29 b5 cc 04 00 00 	sub    %r14d,0x4cc(%rbp)
ffffffff804c0f94:       11 	44 29 b5 74 04 00 00 	sub    %r14d,0x474(%rbp)
ffffffff804c0f9b:     1426 	44 01 74 24 38       	add    %r14d,0x38(%rsp)
ffffffff804c0fa0:        6 	41 f6 47 24 02       	testb  $0x2,0x24(%r15)
ffffffff804c0fa5:      548 	75 07                	jne    ffffffff804c0fae <tcp_ack+0x497>
ffffffff804c0fa7:        2 	83 4c 24 50 04       	orl    $0x4,0x50(%rsp)
ffffffff804c0fac:        0 	eb 0f                	jmp    ffffffff804c0fbd <tcp_ack+0x4a6>
ffffffff804c0fae:        0 	83 4c 24 50 10       	orl    $0x10,0x50(%rsp)
ffffffff804c0fb3:        0 	c7 85 74 05 00 00 00 	movl   $0x0,0x574(%rbp)
ffffffff804c0fba:        0 	00 00 00 
ffffffff804c0fbd:      517 	83 7c 24 44 00       	cmpl   $0x0,0x44(%rsp)
ffffffff804c0fc2:     6012 	0f 84 bb 00 00 00    	je     ffffffff804c1083 <tcp_ack+0x56c>
ffffffff804c0fc8:     1111 	48 8b 34 24          	mov    (%rsp),%rsi
ffffffff804c0fcc:        0 	4c 89 ef             	mov    %r13,%rdi
ffffffff804c0fcf:      184 	e8 0d d8 ff ff       	callq  ffffffff804be7e1 <__skb_unlink>
ffffffff804c0fd4:        5 	41 8b 45 68          	mov    0x68(%r13),%eax
ffffffff804c0fd8:      517 	05 e8 00 00 00       	add    $0xe8,%eax
ffffffff804c0fdd:        0 	41 39 85 e0 00 00 00 	cmp    %eax,0xe0(%r13)
ffffffff804c0fe4:       31 	7d 08                	jge    ffffffff804c0fee <tcp_ack+0x4d7>
ffffffff804c0fe6:        0 	4c 89 ef             	mov    %r13,%rdi
ffffffff804c0fe9:        0 	e8 d4 66 fc ff       	callq  ffffffff804876c2 <skb_truesize_bug>
ffffffff804c0fee:     1142 	0f ba ad 10 01 00 00 	btsl   $0xe,0x110(%rbp)
ffffffff804c0ff5:        0 	0e 
ffffffff804c0ff6:     2576 	8b 85 f0 00 00 00    	mov    0xf0(%rbp),%eax
ffffffff804c0ffc:      433 	41 2b 85 e0 00 00 00 	sub    0xe0(%r13),%eax
ffffffff804c1003:     4843 	89 85 f0 00 00 00    	mov    %eax,0xf0(%rbp)
ffffffff804c1009:     1730 	48 8b 45 30          	mov    0x30(%rbp),%rax
ffffffff804c100d:      311 	41 8b 95 e0 00 00 00 	mov    0xe0(%r13),%edx
ffffffff804c1014:        0 	48 83 b8 b0 00 00 00 	cmpq   $0x0,0xb0(%rax)
ffffffff804c101b:        0 	00 
ffffffff804c101c:      418 	74 06                	je     ffffffff804c1024 <tcp_ack+0x50d>
ffffffff804c101e:       37 	01 95 f4 00 00 00    	add    %edx,0xf4(%rbp)
ffffffff804c1024:        2 	4c 89 ef             	mov    %r13,%rdi
ffffffff804c1027:      432 	e8 56 7b fc ff       	callq  ffffffff80488b82 <__kfree_skb>
ffffffff804c102c:       44 	4c 3b ad f0 04 00 00 	cmp    0x4f0(%rbp),%r13
ffffffff804c1033:      511 	48 c7 85 e8 04 00 00 	movq   $0x0,0x4e8(%rbp)
ffffffff804c103a:        0 	00 00 00 00 
ffffffff804c103e:        1 	75 0b                	jne    ffffffff804c104b <tcp_ack+0x534>
ffffffff804c1040:        0 	48 c7 85 f0 04 00 00 	movq   $0x0,0x4f0(%rbp)
ffffffff804c1047:        0 	00 00 00 00 
ffffffff804c104b:        0 	4c 3b ad e0 04 00 00 	cmp    0x4e0(%rbp),%r13
ffffffff804c1052:      518 	75 0b                	jne    ffffffff804c105f <tcp_ack+0x548>
ffffffff804c1054:        0 	48 c7 85 e0 04 00 00 	movq   $0x0,0x4e0(%rbp)
ffffffff804c105b:        0 	00 00 00 00 
ffffffff804c105f:      439 	4c 8b ad c0 00 00 00 	mov    0xc0(%rbp),%r13
ffffffff804c1066:     5655 	4c 3b 2c 24          	cmp    (%rsp),%r13
ffffffff804c106a:        0 	75 05                	jne    ffffffff804c1071 <tcp_ack+0x55a>
ffffffff804c106c:        0 	45 31 ed             	xor    %r13d,%r13d
ffffffff804c106f:      810 	eb 12                	jmp    ffffffff804c1083 <tcp_ack+0x56c>
ffffffff804c1071:        0 	4d 85 ed             	test   %r13,%r13
ffffffff804c1074:     2574 	74 0d                	je     ffffffff804c1083 <tcp_ack+0x56c>
ffffffff804c1076:        0 	4c 3b ad d8 01 00 00 	cmp    0x1d8(%rbp),%r13
ffffffff804c107d:        0 	0f 85 51 fd ff ff    	jne    ffffffff804c0dd4 <tcp_ack+0x2bd>
ffffffff804c1083:      454 	8b 8d 00 04 00 00    	mov    0x400(%rbp),%ecx
ffffffff804c1089:      497 	8b 85 80 04 00 00    	mov    0x480(%rbp),%eax
ffffffff804c108f:        0 	2b 44 24 18          	sub    0x18(%rsp),%eax
ffffffff804c1093:        0 	89 ca                	mov    %ecx,%edx
ffffffff804c1095:      534 	2b 54 24 18          	sub    0x18(%rsp),%edx
ffffffff804c1099:        0 	39 c2                	cmp    %eax,%edx
ffffffff804c109b:        0 	72 06                	jb     ffffffff804c10a3 <tcp_ack+0x58c>
ffffffff804c109d:      458 	89 8d 80 04 00 00    	mov    %ecx,0x480(%rbp)
ffffffff804c10a3:        0 	4d 85 ed             	test   %r13,%r13
ffffffff804c10a6:        0 	74 15                	je     ffffffff804c10bd <tcp_ack+0x5a6>
ffffffff804c10a8:        0 	8b 44 24 50          	mov    0x50(%rsp),%eax
ffffffff804c10ac:        2 	80 cc 20             	or     $0x20,%ah
ffffffff804c10af:        3 	41 f6 45 5d 01       	testb  $0x1,0x5d(%r13)
ffffffff804c10b4:        0 	0f 44 44 24 50       	cmove  0x50(%rsp),%eax
ffffffff804c10b9:        0 	89 44 24 50          	mov    %eax,0x50(%rsp)
ffffffff804c10bd:      444 	f6 44 24 50 14       	testb  $0x14,0x50(%rsp)
ffffffff804c10c2:      551 	0f 84 e1 01 00 00    	je     ffffffff804c12a9 <tcp_ack+0x792>
ffffffff804c10c8:        1 	f6 85 9c 04 00 00 01 	testb  $0x1,0x49c(%rbp)
ffffffff804c10cf:        2 	48 8b 9d 60 03 00 00 	mov    0x360(%rbp),%rbx
ffffffff804c10d6:      462 	74 17                	je     ffffffff804c10ef <tcp_ack+0x5d8>
ffffffff804c10d8:        0 	83 bd 98 04 00 00 00 	cmpl   $0x0,0x498(%rbp)
ffffffff804c10df:        0 	74 0e                	je     ffffffff804c10ef <tcp_ack+0x5d8>
ffffffff804c10e1:      451 	8b 74 24 50          	mov    0x50(%rsp),%esi
ffffffff804c10e5:       43 	48 89 ef             	mov    %rbp,%rdi
ffffffff804c10e8:        0 	e8 ea e8 ff ff       	callq  ffffffff804bf9d7 <tcp_ack_saw_tstamp>
ffffffff804c10ed:       66 	eb 47                	jmp    ffffffff804c1136 <tcp_ack+0x61f>
ffffffff804c10ef:        0 	83 7c 24 4c 00       	cmpl   $0x0,0x4c(%rsp)
ffffffff804c10f4:        0 	78 40                	js     ffffffff804c1136 <tcp_ack+0x61f>
ffffffff804c10f6:        0 	f6 44 24 50 08       	testb  $0x8,0x50(%rsp)
ffffffff804c10fb:        0 	75 39                	jne    ffffffff804c1136 <tcp_ack+0x61f>
ffffffff804c10fd:        0 	8b 74 24 4c          	mov    0x4c(%rsp),%esi
ffffffff804c1101:        0 	48 89 ef             	mov    %rbp,%rdi
ffffffff804c1104:        0 	e8 b5 e7 ff ff       	callq  ffffffff804bf8be <tcp_rtt_estimator>
ffffffff804c1109:        0 	8b 85 60 04 00 00    	mov    0x460(%rbp),%eax
ffffffff804c110f:        0 	c6 85 7b 03 00 00 00 	movb   $0x0,0x37b(%rbp)
ffffffff804c1116:        0 	c1 e8 03             	shr    $0x3,%eax
ffffffff804c1119:        0 	03 85 6c 04 00 00    	add    0x46c(%rbp),%eax
ffffffff804c111f:        0 	3d 30 75 00 00       	cmp    $0x7530,%eax
ffffffff804c1124:        0 	89 85 58 03 00 00    	mov    %eax,0x358(%rbp)
ffffffff804c112a:        0 	76 0a                	jbe    ffffffff804c1136 <tcp_ack+0x61f>
ffffffff804c112c:        0 	c7 85 58 03 00 00 30 	movl   $0x7530,0x358(%rbp)
ffffffff804c1133:        0 	75 00 00 
ffffffff804c1136:      732 	83 bd 74 04 00 00 00 	cmpl   $0x0,0x474(%rbp)
ffffffff804c113d:     1833 	75 0f                	jne    ffffffff804c114e <tcp_ack+0x637>
ffffffff804c113f:        0 	be 01 00 00 00       	mov    $0x1,%esi
ffffffff804c1144:      493 	48 89 ef             	mov    %rbp,%rdi
ffffffff804c1147:        0 	e8 07 d7 ff ff       	callq  ffffffff804be853 <inet_csk_clear_xmit_timer>
ffffffff804c114c:        0 	eb 18                	jmp    ffffffff804c1166 <tcp_ack+0x64f>
ffffffff804c114e:        0 	8b 95 58 03 00 00    	mov    0x358(%rbp),%edx
ffffffff804c1154:        0 	b9 30 75 00 00       	mov    $0x7530,%ecx
ffffffff804c1159:        0 	be 01 00 00 00       	mov    $0x1,%esi
ffffffff804c115e:        0 	48 89 ef             	mov    %rbp,%rdi
ffffffff804c1161:        0 	e8 7d e4 ff ff       	callq  ffffffff804bf5e3 <inet_csk_reset_xmit_timer>
ffffffff804c1166:      881 	8a 85 9c 04 00 00    	mov    0x49c(%rbp),%al
ffffffff804c116c:      845 	c0 e8 04             	shr    $0x4,%al
ffffffff804c116f:        1 	75 63                	jne    ffffffff804c11d4 <tcp_ack+0x6bd>
ffffffff804c1171:        0 	83 7c 24 38 00       	cmpl   $0x0,0x38(%rsp)
ffffffff804c1176:        0 	7e 29                	jle    ffffffff804c11a1 <tcp_ack+0x68a>
ffffffff804c1178:        0 	8b 44 24 38          	mov    0x38(%rsp),%eax
ffffffff804c117c:        0 	8b 95 d0 04 00 00    	mov    0x4d0(%rbp),%edx
ffffffff804c1182:        0 	ff c8                	dec    %eax
ffffffff804c1184:        0 	39 d0                	cmp    %edx,%eax
ffffffff804c1186:        0 	72 0c                	jb     ffffffff804c1194 <tcp_ack+0x67d>
ffffffff804c1188:        0 	c7 85 d0 04 00 00 00 	movl   $0x0,0x4d0(%rbp)
ffffffff804c118f:        0 	00 00 00 
ffffffff804c1192:        0 	eb 0d                	jmp    ffffffff804c11a1 <tcp_ack+0x68a>
ffffffff804c1194:        0 	8d 42 01             	lea    0x1(%rdx),%eax
ffffffff804c1197:        0 	2b 44 24 38          	sub    0x38(%rsp),%eax
ffffffff804c119b:        0 	89 85 d0 04 00 00    	mov    %eax,0x4d0(%rbp)
ffffffff804c11a1:        0 	8b 74 24 38          	mov    0x38(%rsp),%esi
ffffffff804c11a5:        0 	48 89 ef             	mov    %rbp,%rdi
ffffffff804c11a8:        0 	e8 2d dd ff ff       	callq  ffffffff804beeda <tcp_check_reno_reordering>
ffffffff804c11ad:        0 	8b 85 cc 04 00 00    	mov    0x4cc(%rbp),%eax
ffffffff804c11b3:        0 	03 85 d0 04 00 00    	add    0x4d0(%rbp),%eax
ffffffff804c11b9:        0 	3b 85 74 04 00 00    	cmp    0x474(%rbp),%eax
ffffffff804c11bf:        0 	76 5e                	jbe    ffffffff804c121f <tcp_ack+0x708>
ffffffff804c11c1:        0 	be b0 06 00 00       	mov    $0x6b0,%esi
ffffffff804c11c6:        0 	48 c7 c7 9d d9 6a 80 	mov    $0xffffffff806ad99d,%rdi
ffffffff804c11cd:        0 	e8 e3 4f d7 ff       	callq  ffffffff802361b5 <warn_on_slowpath>
ffffffff804c11d2:        0 	eb 4b                	jmp    ffffffff804c121f <tcp_ack+0x708>
ffffffff804c11d4:      414 	8b 44 24 20          	mov    0x20(%rsp),%eax
ffffffff804c11d8:     1591 	39 44 24 34          	cmp    %eax,0x34(%rsp)
ffffffff804c11dc:        2 	73 14                	jae    ffffffff804c11f2 <tcp_ack+0x6db>
ffffffff804c11de:        0 	8b b5 d4 04 00 00    	mov    0x4d4(%rbp),%esi
ffffffff804c11e4:        0 	2b 74 24 34          	sub    0x34(%rsp),%esi
ffffffff804c11e8:        0 	31 d2                	xor    %edx,%edx
ffffffff804c11ea:        0 	48 89 ef             	mov    %rbp,%rdi
ffffffff804c11ed:        0 	e8 9c db ff ff       	callq  ffffffff804bed8e <tcp_update_reordering>
ffffffff804c11f2:        0 	8a 85 9c 04 00 00    	mov    0x49c(%rbp),%al
ffffffff804c11f8:      865 	c0 e8 04             	shr    $0x4,%al
ffffffff804c11fb:        3 	a8 02                	test   $0x2,%al
ffffffff804c11fd:        0 	8b 85 60 05 00 00    	mov    0x560(%rbp),%eax
ffffffff804c1203:      453 	74 06                	je     ffffffff804c120b <tcp_ack+0x6f4>
ffffffff804c1205:        8 	2b 44 24 38          	sub    0x38(%rsp),%eax
ffffffff804c1209:        0 	eb 0e                	jmp    ffffffff804c1219 <tcp_ack+0x702>
ffffffff804c120b:        0 	8b 95 d0 04 00 00    	mov    0x4d0(%rbp),%edx
ffffffff804c1211:        0 	29 54 24 40          	sub    %edx,0x40(%rsp)
ffffffff804c1215:        0 	2b 44 24 40          	sub    0x40(%rsp),%eax
ffffffff804c1219:      423 	89 85 60 05 00 00    	mov    %eax,0x560(%rbp)
ffffffff804c121f:      492 	8b 85 d4 04 00 00    	mov    0x4d4(%rbp),%eax
ffffffff804c1225:      489 	39 44 24 38          	cmp    %eax,0x38(%rsp)
ffffffff804c1229:        0 	8b 54 24 38          	mov    0x38(%rsp),%edx
ffffffff804c122d:        0 	0f 47 d0             	cmova  %eax,%edx
ffffffff804c1230:      438 	29 d0                	sub    %edx,%eax
ffffffff804c1232:        0 	89 85 d4 04 00 00    	mov    %eax,0x4d4(%rbp)
ffffffff804c1238:        1 	48 83 7b 58 00       	cmpq   $0x0,0x58(%rbx)
ffffffff804c123d:      446 	74 6a                	je     ffffffff804c12a9 <tcp_ack+0x792>
ffffffff804c123f:        0 	f6 44 24 50 08       	testb  $0x8,0x50(%rsp)
ffffffff804c1244:        3 	75 54                	jne    ffffffff804c129a <tcp_ack+0x783>
ffffffff804c1246:      441 	f6 43 10 02          	testb  $0x2,0x10(%rbx)
ffffffff804c124a:        8 	74 3f                	je     ffffffff804c128b <tcp_ack+0x774>
ffffffff804c124c:        0 	e8 33 e4 ff ff       	callq  ffffffff804bf684 <net_invalid_timestamp>
ffffffff804c1251:        0 	48 39 44 24 08       	cmp    %rax,0x8(%rsp)
ffffffff804c1256:        0 	74 33                	je     ffffffff804c128b <tcp_ack+0x774>
ffffffff804c1258:        0 	e8 17 8b d8 ff       	callq  ffffffff80249d74 <ktime_get_real>
ffffffff804c125d:        0 	48 89 c7             	mov    %rax,%rdi
ffffffff804c1260:        0 	48 2b 7c 24 08       	sub    0x8(%rsp),%rdi
ffffffff804c1265:        0 	e8 e3 8e d7 ff       	callq  ffffffff8023a14d <ns_to_timeval>
ffffffff804c126a:        0 	48 89 44 24 60       	mov    %rax,0x60(%rsp)
ffffffff804c126f:        0 	48 89 44 24 70       	mov    %rax,0x70(%rsp)
ffffffff804c1274:        0 	48 69 c0 40 42 0f 00 	imul   $0xf4240,%rax,%rax
ffffffff804c127b:        0 	48 89 54 24 78       	mov    %rdx,0x78(%rsp)
ffffffff804c1280:        0 	48 89 54 24 68       	mov    %rdx,0x68(%rsp)
ffffffff804c1285:        0 	03 44 24 78          	add    0x78(%rsp),%eax
ffffffff804c1289:        0 	eb 12                	jmp    ffffffff804c129d <tcp_ack+0x786>
ffffffff804c128b:       89 	45 85 e4             	test   %r12d,%r12d
ffffffff804c128e:      414 	7e 0a                	jle    ffffffff804c129a <tcp_ack+0x783>
ffffffff804c1290:        0 	49 63 fc             	movslq %r12d,%rdi
ffffffff804c1293:       65 	e8 a8 8b d7 ff       	callq  ffffffff80239e40 <jiffies_to_usecs>
ffffffff804c1298:        0 	eb 03                	jmp    ffffffff804c129d <tcp_ack+0x786>
ffffffff804c129a:        0 	83 c8 ff             	or     $0xffffffffffffffff,%eax
ffffffff804c129d:     1136 	89 c2                	mov    %eax,%edx
ffffffff804c129f:        7 	8b 74 24 38          	mov    0x38(%rsp),%esi
ffffffff804c12a3:      444 	48 89 ef             	mov    %rbp,%rdi
ffffffff804c12a6:        1 	ff 53 58             	callq  *0x58(%rbx)
ffffffff804c12a9:      305 	83 bd d0 04 00 00 00 	cmpl   $0x0,0x4d0(%rbp)
ffffffff804c12b0:      518 	79 11                	jns    ffffffff804c12c3 <tcp_ack+0x7ac>
ffffffff804c12b2:        0 	be ac 0b 00 00       	mov    $0xbac,%esi
ffffffff804c12b7:        0 	48 c7 c7 9d d9 6a 80 	mov    $0xffffffff806ad99d,%rdi
ffffffff804c12be:        0 	e8 f2 4e d7 ff       	callq  ffffffff802361b5 <warn_on_slowpath>
ffffffff804c12c3:      415 	83 bd cc 04 00 00 00 	cmpl   $0x0,0x4cc(%rbp)
ffffffff804c12ca:     2204 	79 11                	jns    ffffffff804c12dd <tcp_ack+0x7c6>
ffffffff804c12cc:        0 	be ad 0b 00 00       	mov    $0xbad,%esi
ffffffff804c12d1:        0 	48 c7 c7 9d d9 6a 80 	mov    $0xffffffff806ad99d,%rdi
ffffffff804c12d8:        0 	e8 d8 4e d7 ff       	callq  ffffffff802361b5 <warn_on_slowpath>
ffffffff804c12dd:        0 	83 bd 78 04 00 00 00 	cmpl   $0x0,0x478(%rbp)
ffffffff804c12e4:     1747 	79 11                	jns    ffffffff804c12f7 <tcp_ack+0x7e0>
ffffffff804c12e6:        0 	be ae 0b 00 00       	mov    $0xbae,%esi
ffffffff804c12eb:        0 	48 c7 c7 9d d9 6a 80 	mov    $0xffffffff806ad99d,%rdi
ffffffff804c12f2:        0 	e8 be 4e d7 ff       	callq  ffffffff802361b5 <warn_on_slowpath>
ffffffff804c12f7:        0 	83 bd 74 04 00 00 00 	cmpl   $0x0,0x474(%rbp)
ffffffff804c12fe:      878 	0f 85 86 00 00 00    	jne    ffffffff804c138a <tcp_ack+0x873>
ffffffff804c1304:     4721 	8a 85 9c 04 00 00    	mov    0x49c(%rbp),%al
ffffffff804c130a:      968 	c0 e8 04             	shr    $0x4,%al
ffffffff804c130d:        2 	74 7b                	je     ffffffff804c138a <tcp_ack+0x873>
ffffffff804c130f:      171 	8b b5 cc 04 00 00    	mov    0x4cc(%rbp),%esi
ffffffff804c1315:      282 	85 f6                	test   %esi,%esi
ffffffff804c1317:        0 	74 1f                	je     ffffffff804c1338 <tcp_ack+0x821>
ffffffff804c1319:        0 	0f b6 95 78 03 00 00 	movzbl 0x378(%rbp),%edx
ffffffff804c1320:        0 	48 c7 c7 b2 d9 6a 80 	mov    $0xffffffff806ad9b2,%rdi
ffffffff804c1327:        0 	31 c0                	xor    %eax,%eax
ffffffff804c1329:        0 	e8 46 5a d7 ff       	callq  ffffffff80236d74 <printk>
ffffffff804c132e:        0 	c7 85 cc 04 00 00 00 	movl   $0x0,0x4cc(%rbp)
ffffffff804c1335:        0 	00 00 00 
ffffffff804c1338:      198 	8b b5 d0 04 00 00    	mov    0x4d0(%rbp),%esi
ffffffff804c133e:      257 	85 f6                	test   %esi,%esi
ffffffff804c1340:        0 	74 1f                	je     ffffffff804c1361 <tcp_ack+0x84a>
ffffffff804c1342:        0 	0f b6 95 78 03 00 00 	movzbl 0x378(%rbp),%edx
ffffffff804c1349:        0 	48 c7 c7 c3 d9 6a 80 	mov    $0xffffffff806ad9c3,%rdi
ffffffff804c1350:        0 	31 c0                	xor    %eax,%eax
ffffffff804c1352:        0 	e8 1d 5a d7 ff       	callq  ffffffff80236d74 <printk>
ffffffff804c1357:        0 	c7 85 d0 04 00 00 00 	movl   $0x0,0x4d0(%rbp)
ffffffff804c135e:        0 	00 00 00 
ffffffff804c1361:     2524 	8b b5 78 04 00 00    	mov    0x478(%rbp),%esi
ffffffff804c1367:     1825 	85 f6                	test   %esi,%esi
ffffffff804c1369:        0 	74 1f                	je     ffffffff804c138a <tcp_ack+0x873>
ffffffff804c136b:        0 	0f b6 95 78 03 00 00 	movzbl 0x378(%rbp),%edx
ffffffff804c1372:        0 	48 c7 c7 d4 d9 6a 80 	mov    $0xffffffff806ad9d4,%rdi
ffffffff804c1379:        0 	31 c0                	xor    %eax,%eax
ffffffff804c137b:        0 	e8 f4 59 d7 ff       	callq  ffffffff80236d74 <printk>
ffffffff804c1380:        0 	c7 85 78 04 00 00 00 	movl   $0x0,0x478(%rbp)
ffffffff804c1387:        0 	00 00 00 
ffffffff804c138a:       46 	44 8b 64 24 50       	mov    0x50(%rsp),%r12d
ffffffff804c138f:     7369 	31 c9                	xor    %ecx,%ecx
ffffffff804c1391:      348 	44 0b 64 24 5c       	or     0x5c(%rsp),%r12d
ffffffff804c1396:        0 	80 bd 5e 04 00 00 00 	cmpb   $0x0,0x45e(%rbp)
ffffffff804c139d:       96 	0f 84 26 02 00 00    	je     ffffffff804c15c9 <tcp_ack+0xab2>
ffffffff804c13a3:        0 	8b 85 cc 04 00 00    	mov    0x4cc(%rbp),%eax
ffffffff804c13a9:        0 	03 85 d0 04 00 00    	add    0x4d0(%rbp),%eax
ffffffff804c13af:        0 	3b 85 74 04 00 00    	cmp    0x474(%rbp),%eax
ffffffff804c13b5:        0 	76 11                	jbe    ffffffff804c13c8 <tcp_ack+0x8b1>
ffffffff804c13b7:        0 	be 58 0c 00 00       	mov    $0xc58,%esi
ffffffff804c13bc:        0 	48 c7 c7 9d d9 6a 80 	mov    $0xffffffff806ad99d,%rdi
ffffffff804c13c3:        0 	e8 ed 4d d7 ff       	callq  ffffffff802361b5 <warn_on_slowpath>
ffffffff804c13c8:        0 	44 89 e3             	mov    %r12d,%ebx
ffffffff804c13cb:        0 	83 e3 04             	and    $0x4,%ebx
ffffffff804c13ce:        0 	74 07                	je     ffffffff804c13d7 <tcp_ack+0x8c0>
ffffffff804c13d0:        0 	c6 85 79 03 00 00 00 	movb   $0x0,0x379(%rbp)
ffffffff804c13d7:        0 	41 f7 c4 00 10 00 00 	test   $0x1000,%r12d
ffffffff804c13de:        0 	75 0f                	jne    ffffffff804c13ef <tcp_ack+0x8d8>
ffffffff804c13e0:        0 	80 bd 5e 04 00 00 01 	cmpb   $0x1,0x45e(%rbp)
ffffffff804c13e7:        0 	76 10                	jbe    ffffffff804c13f9 <tcp_ack+0x8e2>
ffffffff804c13e9:        0 	41 f6 c4 08          	test   $0x8,%r12b
ffffffff804c13ed:        0 	74 0a                	je     ffffffff804c13f9 <tcp_ack+0x8e2>
ffffffff804c13ef:        0 	c7 85 78 05 00 00 00 	movl   $0x0,0x578(%rbp)
ffffffff804c13f6:        0 	00 00 00 
ffffffff804c13f9:        0 	8b 85 58 04 00 00    	mov    0x458(%rbp),%eax
ffffffff804c13ff:        0 	39 85 00 04 00 00    	cmp    %eax,0x400(%rbp)
ffffffff804c1405:        0 	78 12                	js     ffffffff804c1419 <tcp_ack+0x902>
ffffffff804c1407:        0 	31 f6                	xor    %esi,%esi
ffffffff804c1409:        0 	80 bd 5e 04 00 00 01 	cmpb   $0x1,0x45e(%rbp)
ffffffff804c1410:        0 	40 0f 95 c6          	setne  %sil
ffffffff804c1414:        0 	83 c6 02             	add    $0x2,%esi
ffffffff804c1417:        0 	eb 37                	jmp    ffffffff804c1450 <tcp_ack+0x939>
ffffffff804c1419:        0 	48 89 ef             	mov    %rbp,%rdi
ffffffff804c141c:        0 	e8 e0 da ff ff       	callq  ffffffff804bef01 <tcp_is_sackfrto>
ffffffff804c1421:        0 	85 c0                	test   %eax,%eax
ffffffff804c1423:        0 	75 3b                	jne    ffffffff804c1460 <tcp_ack+0x949>
ffffffff804c1425:        0 	41 f7 c4 34 04 00 00 	test   $0x434,%r12d
ffffffff804c142c:        0 	75 0a                	jne    ffffffff804c1438 <tcp_ack+0x921>
ffffffff804c142e:        0 	41 f6 c4 17          	test   $0x17,%r12b
ffffffff804c1432:        0 	0f 85 8c 01 00 00    	jne    ffffffff804c15c4 <tcp_ack+0xaad>
ffffffff804c1438:        0 	85 db                	test   %ebx,%ebx
ffffffff804c143a:        0 	0f 85 8d 00 00 00    	jne    ffffffff804c14cd <tcp_ack+0x9b6>
ffffffff804c1440:        0 	31 f6                	xor    %esi,%esi
ffffffff804c1442:        0 	80 bd 5e 04 00 00 01 	cmpb   $0x1,0x45e(%rbp)
ffffffff804c1449:        0 	40 0f 95 c6          	setne  %sil
ffffffff804c144d:        0 	8d 34 76             	lea    (%rsi,%rsi,2),%esi
ffffffff804c1450:        0 	44 89 e2             	mov    %r12d,%edx
ffffffff804c1453:        0 	48 89 ef             	mov    %rbp,%rdi
ffffffff804c1456:        0 	e8 b8 e7 ff ff       	callq  ffffffff804bfc13 <tcp_enter_frto_loss>
ffffffff804c145b:        0 	e9 64 01 00 00       	jmpq   ffffffff804c15c4 <tcp_ack+0xaad>
ffffffff804c1460:        0 	85 db                	test   %ebx,%ebx
ffffffff804c1462:        0 	75 37                	jne    ffffffff804c149b <tcp_ack+0x984>
ffffffff804c1464:        0 	80 bd 5e 04 00 00 01 	cmpb   $0x1,0x45e(%rbp)
ffffffff804c146b:        0 	75 2e                	jne    ffffffff804c149b <tcp_ack+0x984>
ffffffff804c146d:        0 	8b 85 78 04 00 00    	mov    0x478(%rbp),%eax
ffffffff804c1473:        0 	03 85 74 04 00 00    	add    0x474(%rbp),%eax
ffffffff804c1479:        0 	2b 85 d0 04 00 00    	sub    0x4d0(%rbp),%eax
ffffffff804c147f:        0 	8b 95 ac 04 00 00    	mov    0x4ac(%rbp),%edx
ffffffff804c1485:        0 	2b 85 cc 04 00 00    	sub    0x4cc(%rbp),%eax
ffffffff804c148b:        0 	39 d0                	cmp    %edx,%eax
ffffffff804c148d:        0 	0f 47 c2             	cmova  %edx,%eax
ffffffff804c1490:        0 	89 85 ac 04 00 00    	mov    %eax,0x4ac(%rbp)
ffffffff804c1496:        0 	e9 29 01 00 00       	jmpq   ffffffff804c15c4 <tcp_ack+0xaad>
ffffffff804c149b:        0 	80 bd 5e 04 00 00 01 	cmpb   $0x1,0x45e(%rbp)
ffffffff804c14a2:        0 	76 29                	jbe    ffffffff804c14cd <tcp_ack+0x9b6>
ffffffff804c14a4:        0 	41 f6 c4 34          	test   $0x34,%r12b
ffffffff804c14a8:        0 	74 0f                	je     ffffffff804c14b9 <tcp_ack+0x9a2>
ffffffff804c14aa:        0 	44 89 e0             	mov    %r12d,%eax
ffffffff804c14ad:        0 	25 20 02 00 00       	and    $0x220,%eax
ffffffff804c14b2:        0 	83 f8 20             	cmp    $0x20,%eax
ffffffff804c14b5:        0 	75 16                	jne    ffffffff804c14cd <tcp_ack+0x9b6>
ffffffff804c14b7:        0 	eb 0a                	jmp    ffffffff804c14c3 <tcp_ack+0x9ac>
ffffffff804c14b9:        0 	41 f6 c4 17          	test   $0x17,%r12b
ffffffff804c14bd:        0 	0f 85 01 01 00 00    	jne    ffffffff804c15c4 <tcp_ack+0xaad>
ffffffff804c14c3:        0 	44 89 e2             	mov    %r12d,%edx
ffffffff804c14c6:        0 	be 03 00 00 00       	mov    $0x3,%esi
ffffffff804c14cb:        0 	eb 86                	jmp    ffffffff804c1453 <tcp_ack+0x93c>
ffffffff804c14cd:        0 	80 bd 5e 04 00 00 01 	cmpb   $0x1,0x45e(%rbp)
ffffffff804c14d4:        0 	75 45                	jne    ffffffff804c151b <tcp_ack+0xa04>
ffffffff804c14d6:        0 	8b 85 78 04 00 00    	mov    0x478(%rbp),%eax
ffffffff804c14dc:        0 	03 85 74 04 00 00    	add    0x474(%rbp),%eax
ffffffff804c14e2:        0 	48 89 ef             	mov    %rbp,%rdi
ffffffff804c14e5:        0 	c6 85 5e 04 00 00 02 	movb   $0x2,0x45e(%rbp)
ffffffff804c14ec:        0 	83 c0 02             	add    $0x2,%eax
ffffffff804c14ef:        0 	2b 85 cc 04 00 00    	sub    0x4cc(%rbp),%eax
ffffffff804c14f5:        0 	2b 85 d0 04 00 00    	sub    0x4d0(%rbp),%eax
ffffffff804c14fb:        0 	89 85 ac 04 00 00    	mov    %eax,0x4ac(%rbp)
ffffffff804c1501:        0 	e8 0a 3e 00 00       	callq  ffffffff804c5310 <tcp_may_send_now>
ffffffff804c1506:        0 	85 c0                	test   %eax,%eax
ffffffff804c1508:        0 	0f 85 b6 00 00 00    	jne    ffffffff804c15c4 <tcp_ack+0xaad>
ffffffff804c150e:        0 	44 89 e2             	mov    %r12d,%edx
ffffffff804c1511:        0 	be 02 00 00 00       	mov    $0x2,%esi
ffffffff804c1516:        0 	e9 38 ff ff ff       	jmpq   ffffffff804c1453 <tcp_ack+0x93c>
ffffffff804c151b:        0 	8b 05 3f 6f 3f 00    	mov    0x3f6f3f(%rip),%eax        # ffffffff808b8460 <sysctl_tcp_frto_response>
ffffffff804c1521:        0 	83 f8 01             	cmp    $0x1,%eax
ffffffff804c1524:        0 	74 1a                	je     ffffffff804c1540 <tcp_ack+0xa29>
ffffffff804c1526:        0 	83 f8 02             	cmp    $0x2,%eax
ffffffff804c1529:        0 	75 5d                	jne    ffffffff804c1588 <tcp_ack+0xa71>
ffffffff804c152b:        0 	41 f6 c4 40          	test   $0x40,%r12b
ffffffff804c152f:        0 	75 57                	jne    ffffffff804c1588 <tcp_ack+0xa71>
ffffffff804c1531:        0 	be 01 00 00 00       	mov    $0x1,%esi
ffffffff804c1536:        0 	48 89 ef             	mov    %rbp,%rdi
ffffffff804c1539:        0 	e8 5a db ff ff       	callq  ffffffff804bf098 <tcp_undo_cwr>
ffffffff804c153e:        0 	eb 50                	jmp    ffffffff804c1590 <tcp_ack+0xa79>
ffffffff804c1540:        0 	8b 85 ac 04 00 00    	mov    0x4ac(%rbp),%eax
ffffffff804c1546:        0 	8b 95 a8 04 00 00    	mov    0x4a8(%rbp),%edx
ffffffff804c154c:        0 	c7 85 b0 04 00 00 00 	movl   $0x0,0x4b0(%rbp)
ffffffff804c1553:        0 	00 00 00 
ffffffff804c1556:        0 	c7 85 dc 04 00 00 00 	movl   $0x0,0x4dc(%rbp)
ffffffff804c155d:        0 	00 00 00 
ffffffff804c1560:        0 	39 c2                	cmp    %eax,%edx
ffffffff804c1562:        0 	0f 46 c2             	cmovbe %edx,%eax
ffffffff804c1565:        0 	89 85 ac 04 00 00    	mov    %eax,0x4ac(%rbp)
ffffffff804c156b:        0 	8a 85 7e 04 00 00    	mov    0x47e(%rbp),%al
ffffffff804c1571:        0 	a8 01                	test   $0x1,%al
ffffffff804c1573:        0 	74 09                	je     ffffffff804c157e <tcp_ack+0xa67>
ffffffff804c1575:        0 	83 c8 02             	or     $0x2,%eax
ffffffff804c1578:        0 	88 85 7e 04 00 00    	mov    %al,0x47e(%rbp)
ffffffff804c157e:        0 	48 89 ef             	mov    %rbp,%rdi
ffffffff804c1581:        0 	e8 27 da ff ff       	callq  ffffffff804befad <tcp_moderate_cwnd>
ffffffff804c1586:        0 	eb 08                	jmp    ffffffff804c1590 <tcp_ack+0xa79>
ffffffff804c1588:        0 	48 89 ef             	mov    %rbp,%rdi
ffffffff804c158b:        0 	e8 78 dd ff ff       	callq  ffffffff804bf308 <tcp_ratehalving_spur_to_response>
ffffffff804c1590:        0 	c6 85 5e 04 00 00 00 	movb   $0x0,0x45e(%rbp)
ffffffff804c1597:        0 	c7 85 78 05 00 00 00 	movl   $0x0,0x578(%rbp)
ffffffff804c159e:        0 	00 00 00 
ffffffff804c15a1:        0 	31 c9                	xor    %ecx,%ecx
ffffffff804c15a3:        0 	48 8b 05 0e 01 5f 00 	mov    0x5f010e(%rip),%rax        # ffffffff80ab16b8 <init_net+0xe8>
ffffffff804c15aa:        0 	65 8b 14 25 24 00 00 	mov    %gs:0x24,%edx
ffffffff804c15b1:        0 	00 
ffffffff804c15b2:        0 	89 d2                	mov    %edx,%edx
ffffffff804c15b4:        0 	48 f7 d0             	not    %rax
ffffffff804c15b7:        0 	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
ffffffff804c15bb:        0 	48 ff 80 28 02 00 00 	incq   0x228(%rax)
ffffffff804c15c2:        0 	eb 05                	jmp    ffffffff804c15c9 <tcp_ack+0xab2>
ffffffff804c15c4:        0 	b9 01 00 00 00       	mov    $0x1,%ecx
ffffffff804c15c9:      466 	8b 95 00 04 00 00    	mov    0x400(%rbp),%edx
ffffffff804c15cf:     5645 	39 95 58 04 00 00    	cmp    %edx,0x458(%rbp)
ffffffff804c15d5:      176 	79 0a                	jns    ffffffff804c15e1 <tcp_ack+0xaca>
ffffffff804c15d7:       24 	c7 85 58 04 00 00 00 	movl   $0x0,0x458(%rbp)
ffffffff804c15de:        0 	00 00 00 
ffffffff804c15e1:      620 	8b 54 24 2c          	mov    0x2c(%rsp),%edx
ffffffff804c15e5:      639 	03 54 24 30          	add    0x30(%rsp),%edx
ffffffff804c15e9:        2 	44 89 e3             	mov    %r12d,%ebx
ffffffff804c15ec:      283 	2b 54 24 28          	sub    0x28(%rsp),%edx
ffffffff804c15f0:      154 	2b 54 24 24          	sub    0x24(%rsp),%edx
ffffffff804c15f4:        0 	83 e3 17             	and    $0x17,%ebx
ffffffff804c15f7:      266 	89 5c 24 54          	mov    %ebx,0x54(%rsp)
ffffffff804c15fb:      168 	74 13                	je     ffffffff804c1610 <tcp_ack+0xaf9>
ffffffff804c15fd:        0 	41 f6 c4 60          	test   $0x60,%r12b
ffffffff804c1601:     6575 	75 0d                	jne    ffffffff804c1610 <tcp_ack+0xaf9>
ffffffff804c1603:       20 	80 bd 78 03 00 00 00 	cmpb   $0x0,0x378(%rbp)
ffffffff804c160a:     1417 	0f 84 3a 09 00 00    	je     ffffffff804c1f4a <tcp_ack+0x1433>
ffffffff804c1610:        0 	44 89 e0             	mov    %r12d,%eax
ffffffff804c1613:        0 	c1 e8 02             	shr    $0x2,%eax
ffffffff804c1616:        0 	88 c3                	mov    %al,%bl
ffffffff804c1618:        0 	80 e3 01             	and    $0x1,%bl
ffffffff804c161b:        0 	41 88 de             	mov    %bl,%r14b
ffffffff804c161e:        0 	74 36                	je     ffffffff804c1656 <tcp_ack+0xb3f>
ffffffff804c1620:        0 	85 c9                	test   %ecx,%ecx
ffffffff804c1622:        0 	75 32                	jne    ffffffff804c1656 <tcp_ack+0xb3f>
ffffffff804c1624:        0 	41 f6 c4 40          	test   $0x40,%r12b
ffffffff804c1628:        0 	74 0e                	je     ffffffff804c1638 <tcp_ack+0xb21>
ffffffff804c162a:        0 	8b 85 a8 04 00 00    	mov    0x4a8(%rbp),%eax
ffffffff804c1630:        0 	39 85 ac 04 00 00    	cmp    %eax,0x4ac(%rbp)
ffffffff804c1636:        0 	73 1e                	jae    ffffffff804c1656 <tcp_ack+0xb3f>
ffffffff804c1638:        0 	0f b6 8d 78 03 00 00 	movzbl 0x378(%rbp),%ecx
ffffffff804c163f:        0 	b8 0c 00 00 00       	mov    $0xc,%eax
ffffffff804c1644:        0 	d3 f8                	sar    %cl,%eax
ffffffff804c1646:        0 	a8 01                	test   $0x1,%al
ffffffff804c1648:        0 	75 0c                	jne    ffffffff804c1656 <tcp_ack+0xb3f>
ffffffff804c164a:        0 	8b 74 24 1c          	mov    0x1c(%rsp),%esi
ffffffff804c164e:        0 	48 89 ef             	mov    %rbp,%rdi
ffffffff804c1651:        0 	e8 6b dc ff ff       	callq  ffffffff804bf2c1 <tcp_cong_avoid>
ffffffff804c1656:        0 	31 db                	xor    %ebx,%ebx
ffffffff804c1658:        0 	41 f7 c4 17 04 00 00 	test   $0x417,%r12d
ffffffff804c165f:        0 	44 8b bd 74 04 00 00 	mov    0x474(%rbp),%r15d
ffffffff804c1666:        0 	0f 94 c3             	sete   %bl
ffffffff804c1669:        0 	41 bd 01 00 00 00    	mov    $0x1,%r13d
ffffffff804c166f:        0 	85 db                	test   %ebx,%ebx
ffffffff804c1671:        0 	75 21                	jne    ffffffff804c1694 <tcp_ack+0xb7d>
ffffffff804c1673:        0 	45 30 ed             	xor    %r13b,%r13b
ffffffff804c1676:        0 	41 f6 c4 20          	test   $0x20,%r12b
ffffffff804c167a:        0 	74 18                	je     ffffffff804c1694 <tcp_ack+0xb7d>
ffffffff804c167c:        0 	48 89 ef             	mov    %rbp,%rdi
ffffffff804c167f:        0 	45 31 ed             	xor    %r13d,%r13d
ffffffff804c1682:        0 	e8 cf d8 ff ff       	callq  ffffffff804bef56 <tcp_fackets_out>
ffffffff804c1687:        0 	0f b6 95 7f 04 00 00 	movzbl 0x47f(%rbp),%edx
ffffffff804c168e:        0 	39 d0                	cmp    %edx,%eax
ffffffff804c1690:        0 	41 0f 9f c5          	setg   %r13b
ffffffff804c1694:        0 	83 bd 74 04 00 00 00 	cmpl   $0x0,0x474(%rbp)
ffffffff804c169b:        0 	75 24                	jne    ffffffff804c16c1 <tcp_ack+0xbaa>
ffffffff804c169d:        0 	83 bd d0 04 00 00 00 	cmpl   $0x0,0x4d0(%rbp)
ffffffff804c16a4:        0 	74 1b                	je     ffffffff804c16c1 <tcp_ack+0xbaa>
ffffffff804c16a6:        0 	be 16 0a 00 00       	mov    $0xa16,%esi
ffffffff804c16ab:        0 	48 c7 c7 9d d9 6a 80 	mov    $0xffffffff806ad99d,%rdi
ffffffff804c16b2:        0 	e8 fe 4a d7 ff       	callq  ffffffff802361b5 <warn_on_slowpath>
ffffffff804c16b7:        0 	c7 85 d0 04 00 00 00 	movl   $0x0,0x4d0(%rbp)
ffffffff804c16be:        0 	00 00 00 
ffffffff804c16c1:        0 	83 bd d0 04 00 00 00 	cmpl   $0x0,0x4d0(%rbp)
ffffffff804c16c8:        0 	75 24                	jne    ffffffff804c16ee <tcp_ack+0xbd7>
ffffffff804c16ca:        0 	83 bd d4 04 00 00 00 	cmpl   $0x0,0x4d4(%rbp)
ffffffff804c16d1:        0 	74 1b                	je     ffffffff804c16ee <tcp_ack+0xbd7>
ffffffff804c16d3:        0 	be 18 0a 00 00       	mov    $0xa18,%esi
ffffffff804c16d8:        0 	48 c7 c7 9d d9 6a 80 	mov    $0xffffffff806ad99d,%rdi
ffffffff804c16df:        0 	e8 d1 4a d7 ff       	callq  ffffffff802361b5 <warn_on_slowpath>
ffffffff804c16e4:        0 	c7 85 d4 04 00 00 00 	movl   $0x0,0x4d4(%rbp)
ffffffff804c16eb:        0 	00 00 00 
ffffffff804c16ee:        0 	44 89 e0             	mov    %r12d,%eax
ffffffff804c16f1:        0 	83 e0 40             	and    $0x40,%eax
ffffffff804c16f4:        0 	89 44 24 58          	mov    %eax,0x58(%rsp)
ffffffff804c16f8:        0 	74 0a                	je     ffffffff804c1704 <tcp_ack+0xbed>
ffffffff804c16fa:        0 	c7 85 6c 05 00 00 00 	movl   $0x0,0x56c(%rbp)
ffffffff804c1701:        0 	00 00 00 
ffffffff804c1704:        0 	41 f7 c4 00 20 00 00 	test   $0x2000,%r12d
ffffffff804c170b:        0 	0f 84 50 08 00 00    	je     ffffffff804c1f61 <tcp_ack+0x144a>
ffffffff804c1711:        0 	48 8b 15 a0 ff 5e 00 	mov    0x5effa0(%rip),%rdx        # ffffffff80ab16b8 <init_net+0xe8>
ffffffff804c1718:        0 	48 89 ef             	mov    %rbp,%rdi
ffffffff804c171b:        0 	be 01 00 00 00       	mov    $0x1,%esi
ffffffff804c1720:        0 	65 8b 04 25 24 00 00 	mov    %gs:0x24,%eax
ffffffff804c1727:        0 	00 
ffffffff804c1728:        0 	89 c0                	mov    %eax,%eax
ffffffff804c172a:        0 	48 f7 d2             	not    %rdx
ffffffff804c172d:        0 	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
ffffffff804c1731:        0 	48 ff 80 00 01 00 00 	incq   0x100(%rax)
ffffffff804c1738:        0 	e8 df e2 ff ff       	callq  ffffffff804bfa1c <tcp_enter_loss>
ffffffff804c173d:        0 	48 8b b5 c0 00 00 00 	mov    0xc0(%rbp),%rsi
ffffffff804c1744:        0 	fe 85 79 03 00 00    	incb   0x379(%rbp)
ffffffff804c174a:        0 	48 8d 85 c0 00 00 00 	lea    0xc0(%rbp),%rax
ffffffff804c1751:        0 	48 89 ef             	mov    %rbp,%rdi
ffffffff804c1754:        0 	48 39 c6             	cmp    %rax,%rsi
ffffffff804c1757:        0 	b8 00 00 00 00       	mov    $0x0,%eax
ffffffff804c175c:        0 	48 0f 44 f0          	cmove  %rax,%rsi
ffffffff804c1760:        0 	e8 2d 4b 00 00       	callq  ffffffff804c6292 <tcp_retransmit_skb>
ffffffff804c1765:        0 	8b 95 58 03 00 00    	mov    0x358(%rbp),%edx
ffffffff804c176b:        0 	b9 30 75 00 00       	mov    $0x7530,%ecx
ffffffff804c1770:        0 	be 01 00 00 00       	mov    $0x1,%esi
ffffffff804c1775:        0 	48 89 ef             	mov    %rbp,%rdi
ffffffff804c1778:        0 	e8 66 de ff ff       	callq  ffffffff804bf5e3 <inet_csk_reset_xmit_timer>
ffffffff804c177d:        0 	e9 dd 06 00 00       	jmpq   ffffffff804c1e5f <tcp_ack+0x1348>
ffffffff804c1782:        0 	45 84 e4             	test   %r12b,%r12b
ffffffff804c1785:        0 	79 51                	jns    ffffffff804c17d8 <tcp_ack+0xcc1>
ffffffff804c1787:        0 	8b 95 70 05 00 00    	mov    0x570(%rbp),%edx
ffffffff804c178d:        0 	39 95 00 04 00 00    	cmp    %edx,0x400(%rbp)
ffffffff804c1793:        0 	79 43                	jns    ffffffff804c17d8 <tcp_ack+0xcc1>
ffffffff804c1795:        0 	80 bd 78 03 00 00 00 	cmpb   $0x0,0x378(%rbp)
ffffffff804c179c:        0 	74 3a                	je     ffffffff804c17d8 <tcp_ack+0xcc1>
ffffffff804c179e:        0 	0f b6 85 7f 04 00 00 	movzbl 0x47f(%rbp),%eax
ffffffff804c17a5:        0 	8b b5 d4 04 00 00    	mov    0x4d4(%rbp),%esi
ffffffff804c17ab:        0 	39 c6                	cmp    %eax,%esi
ffffffff804c17ad:        0 	76 29                	jbe    ffffffff804c17d8 <tcp_ack+0xcc1>
ffffffff804c17af:        0 	29 c6                	sub    %eax,%esi
ffffffff804c17b1:        0 	48 89 ef             	mov    %rbp,%rdi
ffffffff804c17b4:        0 	e8 58 e6 ff ff       	callq  ffffffff804bfe11 <tcp_mark_head_lost>
ffffffff804c17b9:        0 	48 8b 05 f8 fe 5e 00 	mov    0x5efef8(%rip),%rax        # ffffffff80ab16b8 <init_net+0xe8>
ffffffff804c17c0:        0 	65 8b 14 25 24 00 00 	mov    %gs:0x24,%edx
ffffffff804c17c7:        0 	00 
ffffffff804c17c8:        0 	89 d2                	mov    %edx,%edx
ffffffff804c17ca:        0 	48 f7 d0             	not    %rax
ffffffff804c17cd:        0 	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
ffffffff804c17d1:        0 	48 ff 80 48 01 00 00 	incq   0x148(%rax)
ffffffff804c17d8:        0 	8b 85 cc 04 00 00    	mov    0x4cc(%rbp),%eax
ffffffff804c17de:        0 	03 85 d0 04 00 00    	add    0x4d0(%rbp),%eax
ffffffff804c17e4:        0 	3b 85 74 04 00 00    	cmp    0x474(%rbp),%eax
ffffffff804c17ea:        0 	76 11                	jbe    ffffffff804c17fd <tcp_ack+0xce6>
ffffffff804c17ec:        0 	be 2e 0a 00 00       	mov    $0xa2e,%esi
ffffffff804c17f1:        0 	48 c7 c7 9d d9 6a 80 	mov    $0xffffffff806ad99d,%rdi
ffffffff804c17f8:        0 	e8 b8 49 d7 ff       	callq  ffffffff802361b5 <warn_on_slowpath>
ffffffff804c17fd:        0 	8a 85 78 03 00 00    	mov    0x378(%rbp),%al
ffffffff804c1803:        0 	84 c0                	test   %al,%al
ffffffff804c1805:        0 	75 29                	jne    ffffffff804c1830 <tcp_ack+0xd19>
ffffffff804c1807:        0 	83 bd 78 04 00 00 00 	cmpl   $0x0,0x478(%rbp)
ffffffff804c180e:        0 	74 11                	je     ffffffff804c1821 <tcp_ack+0xd0a>
ffffffff804c1810:        0 	be 33 0a 00 00       	mov    $0xa33,%esi
ffffffff804c1815:        0 	48 c7 c7 9d d9 6a 80 	mov    $0xffffffff806ad99d,%rdi
ffffffff804c181c:        0 	e8 94 49 d7 ff       	callq  ffffffff802361b5 <warn_on_slowpath>
ffffffff804c1821:        0 	c7 85 74 05 00 00 00 	movl   $0x0,0x574(%rbp)
ffffffff804c1828:        0 	00 00 00 
ffffffff804c182b:        0 	e9 c4 00 00 00       	jmpq   ffffffff804c18f4 <tcp_ack+0xddd>
ffffffff804c1830:        0 	8b 8d 70 05 00 00    	mov    0x570(%rbp),%ecx
ffffffff804c1836:        0 	8b 95 00 04 00 00    	mov    0x400(%rbp),%edx
ffffffff804c183c:        0 	39 ca                	cmp    %ecx,%edx
ffffffff804c183e:        0 	0f 88 b0 00 00 00    	js     ffffffff804c18f4 <tcp_ack+0xddd>
ffffffff804c1844:        0 	3c 02                	cmp    $0x2,%al
ffffffff804c1846:        0 	74 31                	je     ffffffff804c1879 <tcp_ack+0xd62>
ffffffff804c1848:        0 	77 0a                	ja     ffffffff804c1854 <tcp_ack+0xd3d>
ffffffff804c184a:        0 	fe c8                	dec    %al
ffffffff804c184c:        0 	0f 85 a2 00 00 00    	jne    ffffffff804c18f4 <tcp_ack+0xddd>
ffffffff804c1852:        0 	eb 33                	jmp    ffffffff804c1887 <tcp_ack+0xd70>
ffffffff804c1854:        0 	3c 03                	cmp    $0x3,%al
ffffffff804c1856:        0 	74 6f                	je     ffffffff804c18c7 <tcp_ack+0xdb0>
ffffffff804c1858:        0 	3c 04                	cmp    $0x4,%al
ffffffff804c185a:        0 	0f 85 94 00 00 00    	jne    ffffffff804c18f4 <tcp_ack+0xddd>
ffffffff804c1860:        0 	c6 85 79 03 00 00 00 	movb   $0x0,0x379(%rbp)
ffffffff804c1867:        0 	48 89 ef             	mov    %rbp,%rdi
ffffffff804c186a:        0 	e8 fb d8 ff ff       	callq  ffffffff804bf16a <tcp_try_undo_recovery>
ffffffff804c186f:        0 	85 c0                	test   %eax,%eax
ffffffff804c1871:        0 	0f 85 e8 05 00 00    	jne    ffffffff804c1e5f <tcp_ack+0x1348>
ffffffff804c1877:        0 	eb 7b                	jmp    ffffffff804c18f4 <tcp_ack+0xddd>
ffffffff804c1879:        0 	39 ca                	cmp    %ecx,%edx
ffffffff804c187b:        0 	74 77                	je     ffffffff804c18f4 <tcp_ack+0xddd>
ffffffff804c187d:        0 	48 89 ef             	mov    %rbp,%rdi
ffffffff804c1880:        0 	e8 b8 d9 ff ff       	callq  ffffffff804bf23d <tcp_complete_cwr>
ffffffff804c1885:        0 	eb 34                	jmp    ffffffff804c18bb <tcp_ack+0xda4>
ffffffff804c1887:        0 	48 89 ef             	mov    %rbp,%rdi
ffffffff804c188a:        0 	e8 63 d9 ff ff       	callq  ffffffff804bf1f2 <tcp_try_undo_dsack>
ffffffff804c188f:        0 	83 bd 78 05 00 00 00 	cmpl   $0x0,0x578(%rbp)
ffffffff804c1896:        0 	74 19                	je     ffffffff804c18b1 <tcp_ack+0xd9a>
ffffffff804c1898:        0 	8a 85 9c 04 00 00    	mov    0x49c(%rbp),%al
ffffffff804c189e:        0 	c0 e8 04             	shr    $0x4,%al
ffffffff804c18a1:        0 	74 0e                	je     ffffffff804c18b1 <tcp_ack+0xd9a>
ffffffff804c18a3:        0 	8b 85 70 05 00 00    	mov    0x570(%rbp),%eax
ffffffff804c18a9:        0 	39 85 00 04 00 00    	cmp    %eax,0x400(%rbp)
ffffffff804c18af:        0 	74 43                	je     ffffffff804c18f4 <tcp_ack+0xddd>
ffffffff804c18b1:        0 	c7 85 78 05 00 00 00 	movl   $0x0,0x578(%rbp)
ffffffff804c18b8:        0 	00 00 00 
ffffffff804c18bb:        0 	31 f6                	xor    %esi,%esi
ffffffff804c18bd:        0 	48 89 ef             	mov    %rbp,%rdi
ffffffff804c18c0:        0 	e8 b4 cf ff ff       	callq  ffffffff804be879 <tcp_set_ca_state>
ffffffff804c18c5:        0 	eb 2d                	jmp    ffffffff804c18f4 <tcp_ack+0xddd>
ffffffff804c18c7:        0 	8a 85 9c 04 00 00    	mov    0x49c(%rbp),%al
ffffffff804c18cd:        0 	c0 e8 04             	shr    $0x4,%al
ffffffff804c18d0:        0 	75 0a                	jne    ffffffff804c18dc <tcp_ack+0xdc5>
ffffffff804c18d2:        0 	c7 85 d0 04 00 00 00 	movl   $0x0,0x4d0(%rbp)
ffffffff804c18d9:        0 	00 00 00 
ffffffff804c18dc:        0 	48 89 ef             	mov    %rbp,%rdi
ffffffff804c18df:        0 	e8 86 d8 ff ff       	callq  ffffffff804bf16a <tcp_try_undo_recovery>
ffffffff804c18e4:        0 	85 c0                	test   %eax,%eax
ffffffff804c18e6:        0 	0f 85 73 05 00 00    	jne    ffffffff804c1e5f <tcp_ack+0x1348>
ffffffff804c18ec:        0 	48 89 ef             	mov    %rbp,%rdi
ffffffff804c18ef:        0 	e8 49 d9 ff ff       	callq  ffffffff804bf23d <tcp_complete_cwr>
ffffffff804c18f4:        0 	8a 85 78 03 00 00    	mov    0x378(%rbp),%al
ffffffff804c18fa:        0 	3c 03                	cmp    $0x3,%al
ffffffff804c18fc:        0 	74 0d                	je     ffffffff804c190b <tcp_ack+0xdf4>
ffffffff804c18fe:        0 	3c 04                	cmp    $0x4,%al
ffffffff804c1900:        0 	0f 85 b8 01 00 00    	jne    ffffffff804c1abe <tcp_ack+0xfa7>
ffffffff804c1906:        0 	e9 c4 00 00 00       	jmpq   ffffffff804c19cf <tcp_ack+0xeb8>
ffffffff804c190b:        0 	41 f7 c4 00 04 00 00 	test   $0x400,%r12d
ffffffff804c1912:        0 	8a 85 9c 04 00 00    	mov    0x49c(%rbp),%al
ffffffff804c1918:        0 	75 1e                	jne    ffffffff804c1938 <tcp_ack+0xe21>
ffffffff804c191a:        0 	c0 e8 04             	shr    $0x4,%al
ffffffff804c191d:        0 	0f 85 fd 03 00 00    	jne    ffffffff804c1d20 <tcp_ack+0x1209>
ffffffff804c1923:        0 	85 db                	test   %ebx,%ebx
ffffffff804c1925:        0 	0f 84 f5 03 00 00    	je     ffffffff804c1d20 <tcp_ack+0x1209>
ffffffff804c192b:        0 	48 89 ef             	mov    %rbp,%rdi
ffffffff804c192e:        0 	e8 54 dd ff ff       	callq  ffffffff804bf687 <tcp_add_reno_sack>
ffffffff804c1933:        0 	e9 e8 03 00 00       	jmpq   ffffffff804c1d20 <tcp_ack+0x1209>
ffffffff804c1938:        0 	c0 e8 04             	shr    $0x4,%al
ffffffff804c193b:        0 	41 bd 01 00 00 00    	mov    $0x1,%r13d
ffffffff804c1941:        0 	74 18                	je     ffffffff804c195b <tcp_ack+0xe44>
ffffffff804c1943:        0 	48 89 ef             	mov    %rbp,%rdi
ffffffff804c1946:        0 	45 31 ed             	xor    %r13d,%r13d
ffffffff804c1949:        0 	e8 08 d6 ff ff       	callq  ffffffff804bef56 <tcp_fackets_out>
ffffffff804c194e:        0 	0f b6 95 7f 04 00 00 	movzbl 0x47f(%rbp),%edx
ffffffff804c1955:        0 	39 d0                	cmp    %edx,%eax
ffffffff804c1957:        0 	41 0f 9f c5          	setg   %r13b
ffffffff804c195b:        0 	48 89 ef             	mov    %rbp,%rdi
ffffffff804c195e:        0 	e8 c9 d7 ff ff       	callq  ffffffff804bf12c <tcp_may_undo>
ffffffff804c1963:        0 	85 c0                	test   %eax,%eax
ffffffff804c1965:        0 	0f 84 b5 03 00 00    	je     ffffffff804c1d20 <tcp_ack+0x1209>
ffffffff804c196b:        0 	83 bd 78 04 00 00 00 	cmpl   $0x0,0x478(%rbp)
ffffffff804c1972:        0 	75 0a                	jne    ffffffff804c197e <tcp_ack+0xe67>
ffffffff804c1974:        0 	c7 85 74 05 00 00 00 	movl   $0x0,0x574(%rbp)
ffffffff804c197b:        0 	00 00 00 
ffffffff804c197e:        0 	48 89 ef             	mov    %rbp,%rdi
ffffffff804c1981:        0 	45 31 ed             	xor    %r13d,%r13d
ffffffff804c1984:        0 	e8 cd d5 ff ff       	callq  ffffffff804bef56 <tcp_fackets_out>
ffffffff804c1989:        0 	44 29 7c 24 14       	sub    %r15d,0x14(%rsp)
ffffffff804c198e:        0 	ba 01 00 00 00       	mov    $0x1,%edx
ffffffff804c1993:        0 	48 89 ef             	mov    %rbp,%rdi
ffffffff804c1996:        0 	8b 74 24 14          	mov    0x14(%rsp),%esi
ffffffff804c199a:        0 	01 c6                	add    %eax,%esi
ffffffff804c199c:        0 	e8 ed d3 ff ff       	callq  ffffffff804bed8e <tcp_update_reordering>
ffffffff804c19a1:        0 	31 f6                	xor    %esi,%esi
ffffffff804c19a3:        0 	48 89 ef             	mov    %rbp,%rdi
ffffffff804c19a6:        0 	e8 ed d6 ff ff       	callq  ffffffff804bf098 <tcp_undo_cwr>
ffffffff804c19ab:        0 	48 8b 15 06 fd 5e 00 	mov    0x5efd06(%rip),%rdx        # ffffffff80ab16b8 <init_net+0xe8>
ffffffff804c19b2:        0 	65 8b 04 25 24 00 00 	mov    %gs:0x24,%eax
ffffffff804c19b9:        0 	00 
ffffffff804c19ba:        0 	89 c0                	mov    %eax,%eax
ffffffff804c19bc:        0 	48 f7 d2             	not    %rdx
ffffffff804c19bf:        0 	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
ffffffff804c19c3:        0 	48 ff 80 30 01 00 00 	incq   0x130(%rax)
ffffffff804c19ca:        0 	e9 51 03 00 00       	jmpq   ffffffff804c1d20 <tcp_ack+0x1209>
ffffffff804c19cf:        0 	45 84 f6             	test   %r14b,%r14b
ffffffff804c19d2:        0 	74 07                	je     ffffffff804c19db <tcp_ack+0xec4>
ffffffff804c19d4:        0 	c6 85 79 03 00 00 00 	movb   $0x0,0x379(%rbp)
ffffffff804c19db:        0 	8a 85 9c 04 00 00    	mov    0x49c(%rbp),%al
ffffffff804c19e1:        0 	c0 e8 04             	shr    $0x4,%al
ffffffff804c19e4:        0 	75 13                	jne    ffffffff804c19f9 <tcp_ack+0xee2>
ffffffff804c19e6:        0 	41 f7 c4 00 04 00 00 	test   $0x400,%r12d
ffffffff804c19ed:        0 	74 0a                	je     ffffffff804c19f9 <tcp_ack+0xee2>
ffffffff804c19ef:        0 	c7 85 d0 04 00 00 00 	movl   $0x0,0x4d0(%rbp)
ffffffff804c19f6:        0 	00 00 00 
ffffffff804c19f9:        0 	48 89 ef             	mov    %rbp,%rdi
ffffffff804c19fc:        0 	e8 2b d7 ff ff       	callq  ffffffff804bf12c <tcp_may_undo>
ffffffff804c1a01:        0 	85 c0                	test   %eax,%eax
ffffffff804c1a03:        0 	0f 84 6e 05 00 00    	je     ffffffff804c1f77 <tcp_ack+0x1460>
ffffffff804c1a09:        0 	48 8b 95 c0 00 00 00 	mov    0xc0(%rbp),%rdx
ffffffff804c1a10:        0 	48 8d 8d c0 00 00 00 	lea    0xc0(%rbp),%rcx
ffffffff804c1a17:        0 	eb 10                	jmp    ffffffff804c1a29 <tcp_ack+0xf12>
ffffffff804c1a19:        0 	48 3b 95 d8 01 00 00 	cmp    0x1d8(%rbp),%rdx
ffffffff804c1a20:        0 	74 12                	je     ffffffff804c1a34 <tcp_ack+0xf1d>
ffffffff804c1a22:        0 	80 62 5d fb          	andb   $0xfb,0x5d(%rdx)
ffffffff804c1a26:        0 	48 8b 12             	mov    (%rdx),%rdx
ffffffff804c1a29:        0 	48 8b 02             	mov    (%rdx),%rax
ffffffff804c1a2c:        0 	48 39 ca             	cmp    %rcx,%rdx
ffffffff804c1a2f:        0 	0f 18 08             	prefetcht0 (%rax)
ffffffff804c1a32:        0 	75 e5                	jne    ffffffff804c1a19 <tcp_ack+0xf02>
ffffffff804c1a34:        0 	48 c7 85 e0 04 00 00 	movq   $0x0,0x4e0(%rbp)
ffffffff804c1a3b:        0 	00 00 00 00 
ffffffff804c1a3f:        0 	48 c7 85 e8 04 00 00 	movq   $0x0,0x4e8(%rbp)
ffffffff804c1a46:        0 	00 00 00 00 
ffffffff804c1a4a:        0 	be 01 00 00 00       	mov    $0x1,%esi
ffffffff804c1a4f:        0 	48 c7 85 f0 04 00 00 	movq   $0x0,0x4f0(%rbp)
ffffffff804c1a56:        0 	00 00 00 00 
ffffffff804c1a5a:        0 	c7 85 cc 04 00 00 00 	movl   $0x0,0x4cc(%rbp)
ffffffff804c1a61:        0 	00 00 00 
ffffffff804c1a64:        0 	48 89 ef             	mov    %rbp,%rdi
ffffffff804c1a67:        0 	e8 2c d6 ff ff       	callq  ffffffff804bf098 <tcp_undo_cwr>
ffffffff804c1a6c:        0 	48 8b 15 45 fc 5e 00 	mov    0x5efc45(%rip),%rdx        # ffffffff80ab16b8 <init_net+0xe8>
ffffffff804c1a73:        0 	65 8b 04 25 24 00 00 	mov    %gs:0x24,%eax
ffffffff804c1a7a:        0 	00 
ffffffff804c1a7b:        0 	89 c0                	mov    %eax,%eax
ffffffff804c1a7d:        0 	48 f7 d2             	not    %rdx
ffffffff804c1a80:        0 	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
ffffffff804c1a84:        0 	48 ff 80 40 01 00 00 	incq   0x140(%rax)
ffffffff804c1a8b:        0 	c6 85 79 03 00 00 00 	movb   $0x0,0x379(%rbp)
ffffffff804c1a92:        0 	8a 85 9c 04 00 00    	mov    0x49c(%rbp),%al
ffffffff804c1a98:        0 	c7 85 78 05 00 00 00 	movl   $0x0,0x578(%rbp)
ffffffff804c1a9f:        0 	00 00 00 
ffffffff804c1aa2:        0 	c0 e8 04             	shr    $0x4,%al
ffffffff804c1aa5:        0 	74 0a                	je     ffffffff804c1ab1 <tcp_ack+0xf9a>
ffffffff804c1aa7:        0 	31 f6                	xor    %esi,%esi
ffffffff804c1aa9:        0 	48 89 ef             	mov    %rbp,%rdi
ffffffff804c1aac:        0 	e8 c8 cd ff ff       	callq  ffffffff804be879 <tcp_set_ca_state>
ffffffff804c1ab1:        0 	80 bd 78 03 00 00 00 	cmpb   $0x0,0x378(%rbp)
ffffffff804c1ab8:        0 	0f 85 a1 03 00 00    	jne    ffffffff804c1e5f <tcp_ack+0x1348>
ffffffff804c1abe:        0 	8a 85 9c 04 00 00    	mov    0x49c(%rbp),%al
ffffffff804c1ac4:        0 	c0 e8 04             	shr    $0x4,%al
ffffffff804c1ac7:        0 	75 1f                	jne    ffffffff804c1ae8 <tcp_ack+0xfd1>
ffffffff804c1ac9:        0 	41 f7 c4 00 04 00 00 	test   $0x400,%r12d
ffffffff804c1ad0:        0 	74 0a                	je     ffffffff804c1adc <tcp_ack+0xfc5>
ffffffff804c1ad2:        0 	c7 85 d0 04 00 00 00 	movl   $0x0,0x4d0(%rbp)
ffffffff804c1ad9:        0 	00 00 00 
ffffffff804c1adc:        0 	85 db                	test   %ebx,%ebx
ffffffff804c1ade:        0 	74 08                	je     ffffffff804c1ae8 <tcp_ack+0xfd1>
ffffffff804c1ae0:        0 	48 89 ef             	mov    %rbp,%rdi
ffffffff804c1ae3:        0 	e8 9f db ff ff       	callq  ffffffff804bf687 <tcp_add_reno_sack>
ffffffff804c1ae8:        0 	80 bd 78 03 00 00 01 	cmpb   $0x1,0x378(%rbp)
ffffffff804c1aef:        0 	75 08                	jne    ffffffff804c1af9 <tcp_ack+0xfe2>
ffffffff804c1af1:        0 	48 89 ef             	mov    %rbp,%rdi
ffffffff804c1af4:        0 	e8 f9 d6 ff ff       	callq  ffffffff804bf1f2 <tcp_try_undo_dsack>
ffffffff804c1af9:        0 	80 bd 5e 04 00 00 00 	cmpb   $0x0,0x45e(%rbp)
ffffffff804c1b00:        0 	0f 85 90 00 00 00    	jne    ffffffff804c1b96 <tcp_ack+0x107f>
ffffffff804c1b06:        0 	83 bd cc 04 00 00 00 	cmpl   $0x0,0x4cc(%rbp)
ffffffff804c1b0d:        0 	0f 85 79 04 00 00    	jne    ffffffff804c1f8c <tcp_ack+0x1475>
ffffffff804c1b13:        0 	8a 85 9c 04 00 00    	mov    0x49c(%rbp),%al
ffffffff804c1b19:        0 	c0 e8 04             	shr    $0x4,%al
ffffffff804c1b1c:        0 	a8 02                	test   $0x2,%al
ffffffff804c1b1e:        0 	74 08                	je     ffffffff804c1b28 <tcp_ack+0x1011>
ffffffff804c1b20:        0 	8b 95 d4 04 00 00    	mov    0x4d4(%rbp),%edx
ffffffff804c1b26:        0 	eb 08                	jmp    ffffffff804c1b30 <tcp_ack+0x1019>
ffffffff804c1b28:        0 	8b 95 d0 04 00 00    	mov    0x4d0(%rbp),%edx
ffffffff804c1b2e:        0 	ff c2                	inc    %edx
ffffffff804c1b30:        0 	0f b6 85 7f 04 00 00 	movzbl 0x47f(%rbp),%eax
ffffffff804c1b37:        0 	39 c2                	cmp    %eax,%edx
ffffffff804c1b39:        0 	0f 8f 4d 04 00 00    	jg     ffffffff804c1f8c <tcp_ack+0x1475>
ffffffff804c1b3f:        0 	8a 85 9c 04 00 00    	mov    0x49c(%rbp),%al
ffffffff804c1b45:        0 	c0 e8 04             	shr    $0x4,%al
ffffffff804c1b48:        0 	a8 02                	test   $0x2,%al
ffffffff804c1b4a:        0 	74 10                	je     ffffffff804c1b5c <tcp_ack+0x1045>
ffffffff804c1b4c:        0 	48 89 ef             	mov    %rbp,%rdi
ffffffff804c1b4f:        0 	e8 1d d4 ff ff       	callq  ffffffff804bef71 <tcp_head_timedout>
ffffffff804c1b54:        0 	85 c0                	test   %eax,%eax
ffffffff804c1b56:        0 	0f 85 30 04 00 00    	jne    ffffffff804c1f8c <tcp_ack+0x1475>
ffffffff804c1b5c:        0 	0f b6 85 7f 04 00 00 	movzbl 0x47f(%rbp),%eax
ffffffff804c1b63:        0 	8b 95 74 04 00 00    	mov    0x474(%rbp),%edx
ffffffff804c1b69:        0 	39 c2                	cmp    %eax,%edx
ffffffff804c1b6b:        0 	77 29                	ja     ffffffff804c1b96 <tcp_ack+0x107f>
ffffffff804c1b6d:        0 	89 d0                	mov    %edx,%eax
ffffffff804c1b6f:        0 	d1 e8                	shr    %eax
ffffffff804c1b71:        0 	39 05 c1 68 3f 00    	cmp    %eax,0x3f68c1(%rip)        # ffffffff808b8438 <sysctl_tcp_reordering>
ffffffff804c1b77:        0 	0f 43 05 ba 68 3f 00 	cmovae 0x3f68ba(%rip),%eax        # ffffffff808b8438 <sysctl_tcp_reordering>
ffffffff804c1b7e:        0 	39 85 d0 04 00 00    	cmp    %eax,0x4d0(%rbp)
ffffffff804c1b84:        0 	72 10                	jb     ffffffff804c1b96 <tcp_ack+0x107f>
ffffffff804c1b86:        0 	48 89 ef             	mov    %rbp,%rdi
ffffffff804c1b89:        0 	e8 82 37 00 00       	callq  ffffffff804c5310 <tcp_may_send_now>
ffffffff804c1b8e:        0 	85 c0                	test   %eax,%eax
ffffffff804c1b90:        0 	0f 84 f6 03 00 00    	je     ffffffff804c1f8c <tcp_ack+0x1475>
ffffffff804c1b96:        0 	8b 85 cc 04 00 00    	mov    0x4cc(%rbp),%eax
ffffffff804c1b9c:        0 	03 85 d0 04 00 00    	add    0x4d0(%rbp),%eax
ffffffff804c1ba2:        0 	3b 85 74 04 00 00    	cmp    0x474(%rbp),%eax
ffffffff804c1ba8:        0 	76 11                	jbe    ffffffff804c1bbb <tcp_ack+0x10a4>
ffffffff804c1baa:        0 	be d7 09 00 00       	mov    $0x9d7,%esi
ffffffff804c1baf:        0 	48 c7 c7 9d d9 6a 80 	mov    $0xffffffff806ad99d,%rdi
ffffffff804c1bb6:        0 	e8 fa 45 d7 ff       	callq  ffffffff802361b5 <warn_on_slowpath>
ffffffff804c1bbb:        0 	80 bd 5e 04 00 00 00 	cmpb   $0x0,0x45e(%rbp)
ffffffff804c1bc2:        0 	75 13                	jne    ffffffff804c1bd7 <tcp_ack+0x10c0>
ffffffff804c1bc4:        0 	83 bd 78 04 00 00 00 	cmpl   $0x0,0x478(%rbp)
ffffffff804c1bcb:        0 	75 0a                	jne    ffffffff804c1bd7 <tcp_ack+0x10c0>
ffffffff804c1bcd:        0 	c7 85 74 05 00 00 00 	movl   $0x0,0x574(%rbp)
ffffffff804c1bd4:        0 	00 00 00 
ffffffff804c1bd7:        0 	83 7c 24 58 00       	cmpl   $0x0,0x58(%rsp)
ffffffff804c1bdc:        0 	74 0d                	je     ffffffff804c1beb <tcp_ack+0x10d4>
ffffffff804c1bde:        0 	be 01 00 00 00       	mov    $0x1,%esi
ffffffff804c1be3:        0 	48 89 ef             	mov    %rbp,%rdi
ffffffff804c1be6:        0 	e8 cf d0 ff ff       	callq  ffffffff804becba <tcp_enter_cwr>
ffffffff804c1beb:        0 	80 bd 78 03 00 00 02 	cmpb   $0x2,0x378(%rbp)
ffffffff804c1bf2:        0 	74 15                	je     ffffffff804c1c09 <tcp_ack+0x10f2>
ffffffff804c1bf4:        0 	48 89 ef             	mov    %rbp,%rdi
ffffffff804c1bf7:        0 	e8 71 d6 ff ff       	callq  ffffffff804bf26d <tcp_try_keep_open>
ffffffff804c1bfc:        0 	48 89 ef             	mov    %rbp,%rdi
ffffffff804c1bff:        0 	e8 a9 d3 ff ff       	callq  ffffffff804befad <tcp_moderate_cwnd>
ffffffff804c1c04:        0 	e9 56 02 00 00       	jmpq   ffffffff804c1e5f <tcp_ack+0x1348>
ffffffff804c1c09:        0 	44 89 e6             	mov    %r12d,%esi
ffffffff804c1c0c:        0 	48 89 ef             	mov    %rbp,%rdi
ffffffff804c1c0f:        0 	e8 d9 d3 ff ff       	callq  ffffffff804befed <tcp_cwnd_down>
ffffffff804c1c14:        0 	e9 46 02 00 00       	jmpq   ffffffff804c1e5f <tcp_ack+0x1348>
ffffffff804c1c19:        0 	8b 95 a4 03 00 00    	mov    0x3a4(%rbp),%edx
ffffffff804c1c1f:        0 	85 d2                	test   %edx,%edx
ffffffff804c1c21:        0 	74 34                	je     ffffffff804c1c57 <tcp_ack+0x1140>
ffffffff804c1c23:        0 	8b 85 b0 05 00 00    	mov    0x5b0(%rbp),%eax
ffffffff804c1c29:        0 	39 85 00 04 00 00    	cmp    %eax,0x400(%rbp)
ffffffff804c1c2f:        0 	75 26                	jne    ffffffff804c1c57 <tcp_ack+0x1140>
ffffffff804c1c31:        0 	ff 85 ac 04 00 00    	incl   0x4ac(%rbp)
ffffffff804c1c37:        0 	8d 42 ff             	lea    -0x1(%rdx),%eax
ffffffff804c1c3a:        0 	c7 85 a4 03 00 00 00 	movl   $0x0,0x3a4(%rbp)
ffffffff804c1c41:        0 	00 00 00 
ffffffff804c1c44:        0 	48 89 ef             	mov    %rbp,%rdi
ffffffff804c1c47:        0 	89 85 9c 03 00 00    	mov    %eax,0x39c(%rbp)
ffffffff804c1c4d:        0 	e8 86 54 00 00       	callq  ffffffff804c70d8 <tcp_simple_retransmit>
ffffffff804c1c52:        0 	e9 08 02 00 00       	jmpq   ffffffff804c1e5f <tcp_ack+0x1348>
ffffffff804c1c57:        0 	8a 85 9c 04 00 00    	mov    0x49c(%rbp),%al
ffffffff804c1c5d:        0 	48 8b 15 54 fa 5e 00 	mov    0x5efa54(%rip),%rdx        # ffffffff80ab16b8 <init_net+0xe8>
ffffffff804c1c64:        0 	c0 e8 04             	shr    $0x4,%al
ffffffff804c1c67:        0 	48 f7 d2             	not    %rdx
ffffffff804c1c6a:        0 	3c 01                	cmp    $0x1,%al
ffffffff804c1c6c:        0 	19 c9                	sbb    %ecx,%ecx
ffffffff804c1c6e:        0 	65 8b 04 25 24 00 00 	mov    %gs:0x24,%eax
ffffffff804c1c75:        0 	00 
ffffffff804c1c76:        0 	89 c0                	mov    %eax,%eax
ffffffff804c1c78:        0 	83 c1 1f             	add    $0x1f,%ecx
ffffffff804c1c7b:        0 	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
ffffffff804c1c7f:        0 	48 63 c9             	movslq %ecx,%rcx
ffffffff804c1c82:        0 	48 ff 04 c8          	incq   (%rax,%rcx,8)
ffffffff804c1c86:        0 	c7 85 6c 05 00 00 00 	movl   $0x0,0x56c(%rbp)
ffffffff804c1c8d:        0 	00 00 00 
ffffffff804c1c90:        0 	8b 85 fc 03 00 00    	mov    0x3fc(%rbp),%eax
ffffffff804c1c96:        0 	80 bd 78 03 00 00 01 	cmpb   $0x1,0x378(%rbp)
ffffffff804c1c9d:        0 	89 85 70 05 00 00    	mov    %eax,0x570(%rbp)
ffffffff804c1ca3:        0 	8b 85 00 04 00 00    	mov    0x400(%rbp),%eax
ffffffff804c1ca9:        0 	89 85 78 05 00 00    	mov    %eax,0x578(%rbp)
ffffffff804c1caf:        0 	8b 85 78 04 00 00    	mov    0x478(%rbp),%eax
ffffffff804c1cb5:        0 	89 85 7c 05 00 00    	mov    %eax,0x57c(%rbp)
ffffffff804c1cbb:        0 	77 3b                	ja     ffffffff804c1cf8 <tcp_ack+0x11e1>
ffffffff804c1cbd:        0 	83 7c 24 58 00       	cmpl   $0x0,0x58(%rsp)
ffffffff804c1cc2:        0 	75 0e                	jne    ffffffff804c1cd2 <tcp_ack+0x11bb>
ffffffff804c1cc4:        0 	48 89 ef             	mov    %rbp,%rdi
ffffffff804c1cc7:        0 	e8 f0 cb ff ff       	callq  ffffffff804be8bc <tcp_current_ssthresh>
ffffffff804c1ccc:        0 	89 85 6c 05 00 00    	mov    %eax,0x56c(%rbp)
ffffffff804c1cd2:        0 	48 8b 85 60 03 00 00 	mov    0x360(%rbp),%rax
ffffffff804c1cd9:        0 	48 89 ef             	mov    %rbp,%rdi
ffffffff804c1cdc:        0 	ff 50 28             	callq  *0x28(%rax)
ffffffff804c1cdf:        0 	89 85 a8 04 00 00    	mov    %eax,0x4a8(%rbp)
ffffffff804c1ce5:        0 	8a 85 7e 04 00 00    	mov    0x47e(%rbp),%al
ffffffff804c1ceb:        0 	a8 01                	test   $0x1,%al
ffffffff804c1ced:        0 	74 09                	je     ffffffff804c1cf8 <tcp_ack+0x11e1>
ffffffff804c1cef:        0 	83 c8 02             	or     $0x2,%eax
ffffffff804c1cf2:        0 	88 85 7e 04 00 00    	mov    %al,0x47e(%rbp)
ffffffff804c1cf8:        0 	c7 85 dc 04 00 00 00 	movl   $0x0,0x4dc(%rbp)
ffffffff804c1cff:        0 	00 00 00 
ffffffff804c1d02:        0 	c7 85 b0 04 00 00 00 	movl   $0x0,0x4b0(%rbp)
ffffffff804c1d09:        0 	00 00 00 
ffffffff804c1d0c:        0 	be 03 00 00 00       	mov    $0x3,%esi
ffffffff804c1d11:        0 	48 89 ef             	mov    %rbp,%rdi
ffffffff804c1d14:        0 	bb 01 00 00 00       	mov    $0x1,%ebx
ffffffff804c1d19:        0 	e8 5b cb ff ff       	callq  ffffffff804be879 <tcp_set_ca_state>
ffffffff804c1d1e:        0 	eb 02                	jmp    ffffffff804c1d22 <tcp_ack+0x120b>
ffffffff804c1d20:        0 	31 db                	xor    %ebx,%ebx
ffffffff804c1d22:        0 	45 85 ed             	test   %r13d,%r13d
ffffffff804c1d25:        0 	75 21                	jne    ffffffff804c1d48 <tcp_ack+0x1231>
ffffffff804c1d27:        0 	8a 85 9c 04 00 00    	mov    0x49c(%rbp),%al
ffffffff804c1d2d:        0 	c0 e8 04             	shr    $0x4,%al
ffffffff804c1d30:        0 	a8 02                	test   $0x2,%al
ffffffff804c1d32:        0 	0f 84 0b 01 00 00    	je     ffffffff804c1e43 <tcp_ack+0x132c>
ffffffff804c1d38:        0 	48 89 ef             	mov    %rbp,%rdi
ffffffff804c1d3b:        0 	e8 31 d2 ff ff       	callq  ffffffff804bef71 <tcp_head_timedout>
ffffffff804c1d40:        0 	85 c0                	test   %eax,%eax
ffffffff804c1d42:        0 	0f 84 fb 00 00 00    	je     ffffffff804c1e43 <tcp_ack+0x132c>
ffffffff804c1d48:        0 	8a 85 9c 04 00 00    	mov    0x49c(%rbp),%al
ffffffff804c1d4e:        0 	c0 e8 04             	shr    $0x4,%al
ffffffff804c1d51:        0 	75 07                	jne    ffffffff804c1d5a <tcp_ack+0x1243>
ffffffff804c1d53:        0 	be 01 00 00 00       	mov    $0x1,%esi
ffffffff804c1d58:        0 	eb 31                	jmp    ffffffff804c1d8b <tcp_ack+0x1274>
ffffffff804c1d5a:        0 	a8 02                	test   $0x2,%al
ffffffff804c1d5c:        0 	8a 85 7f 04 00 00    	mov    0x47f(%rbp),%al
ffffffff804c1d62:        0 	74 17                	je     ffffffff804c1d7b <tcp_ack+0x1264>
ffffffff804c1d64:        0 	8b b5 d4 04 00 00    	mov    0x4d4(%rbp),%esi
ffffffff804c1d6a:        0 	0f b6 c0             	movzbl %al,%eax
ffffffff804c1d6d:        0 	29 c6                	sub    %eax,%esi
ffffffff804c1d6f:        0 	b8 01 00 00 00       	mov    $0x1,%eax
ffffffff804c1d74:        0 	85 f6                	test   %esi,%esi
ffffffff804c1d76:        0 	0f 4e f0             	cmovle %eax,%esi
ffffffff804c1d79:        0 	eb 10                	jmp    ffffffff804c1d8b <tcp_ack+0x1274>
ffffffff804c1d7b:        0 	8b b5 d0 04 00 00    	mov    0x4d0(%rbp),%esi
ffffffff804c1d81:        0 	0f b6 c0             	movzbl %al,%eax
ffffffff804c1d84:        0 	29 c6                	sub    %eax,%esi
ffffffff804c1d86:        0 	39 f3                	cmp    %esi,%ebx
ffffffff804c1d88:        0 	0f 4d f3             	cmovge %ebx,%esi
ffffffff804c1d8b:        0 	48 89 ef             	mov    %rbp,%rdi
ffffffff804c1d8e:        0 	e8 7e e0 ff ff       	callq  ffffffff804bfe11 <tcp_mark_head_lost>
ffffffff804c1d93:        0 	8a 85 9c 04 00 00    	mov    0x49c(%rbp),%al
ffffffff804c1d99:        0 	c0 e8 04             	shr    $0x4,%al
ffffffff804c1d9c:        0 	a8 02                	test   $0x2,%al
ffffffff804c1d9e:        0 	0f 84 9f 00 00 00    	je     ffffffff804c1e43 <tcp_ack+0x132c>
ffffffff804c1da4:        0 	48 89 ef             	mov    %rbp,%rdi
ffffffff804c1da7:        0 	e8 c5 d1 ff ff       	callq  ffffffff804bef71 <tcp_head_timedout>
ffffffff804c1dac:        0 	85 c0                	test   %eax,%eax
ffffffff804c1dae:        0 	0f 84 8f 00 00 00    	je     ffffffff804c1e43 <tcp_ack+0x132c>
ffffffff804c1db4:        0 	48 8b 85 e8 04 00 00 	mov    0x4e8(%rbp),%rax
ffffffff804c1dbb:        0 	48 85 c0             	test   %rax,%rax
ffffffff804c1dbe:        0 	48 89 c3             	mov    %rax,%rbx
ffffffff804c1dc1:        0 	75 42                	jne    ffffffff804c1e05 <tcp_ack+0x12ee>
ffffffff804c1dc3:        0 	48 8b 9d c0 00 00 00 	mov    0xc0(%rbp),%rbx
ffffffff804c1dca:        0 	48 8d 85 c0 00 00 00 	lea    0xc0(%rbp),%rax
ffffffff804c1dd1:        0 	48 39 c3             	cmp    %rax,%rbx
ffffffff804c1dd4:        0 	75 2f                	jne    ffffffff804c1e05 <tcp_ack+0x12ee>
ffffffff804c1dd6:        0 	31 db                	xor    %ebx,%ebx
ffffffff804c1dd8:        0 	eb 2b                	jmp    ffffffff804c1e05 <tcp_ack+0x12ee>
ffffffff804c1dda:        0 	48 3b 9d d8 01 00 00 	cmp    0x1d8(%rbp),%rbx
ffffffff804c1de1:        0 	74 34                	je     ffffffff804c1e17 <tcp_ack+0x1300>
ffffffff804c1de3:        0 	48 8b 05 96 7a 3f 00 	mov    0x3f7a96(%rip),%rax        # ffffffff808b9880 <jiffies>
ffffffff804c1dea:        0 	2b 43 58             	sub    0x58(%rbx),%eax
ffffffff804c1ded:        0 	3b 85 58 03 00 00    	cmp    0x358(%rbp),%eax
ffffffff804c1df3:        0 	76 22                	jbe    ffffffff804c1e17 <tcp_ack+0x1300>
ffffffff804c1df5:        0 	48 89 de             	mov    %rbx,%rsi
ffffffff804c1df8:        0 	48 89 ef             	mov    %rbp,%rdi
ffffffff804c1dfb:        0 	e8 28 d0 ff ff       	callq  ffffffff804bee28 <tcp_skb_mark_lost>
ffffffff804c1e00:        0 	48 8b 1b             	mov    (%rbx),%rbx
ffffffff804c1e03:        0 	eb 07                	jmp    ffffffff804c1e0c <tcp_ack+0x12f5>
ffffffff804c1e05:        0 	4c 8d ad c0 00 00 00 	lea    0xc0(%rbp),%r13
ffffffff804c1e0c:        0 	48 8b 03             	mov    (%rbx),%rax
ffffffff804c1e0f:        0 	4c 39 eb             	cmp    %r13,%rbx
ffffffff804c1e12:        0 	0f 18 08             	prefetcht0 (%rax)
ffffffff804c1e15:        0 	75 c3                	jne    ffffffff804c1dda <tcp_ack+0x12c3>
ffffffff804c1e17:        0 	8b 85 cc 04 00 00    	mov    0x4cc(%rbp),%eax
ffffffff804c1e1d:        0 	03 85 d0 04 00 00    	add    0x4d0(%rbp),%eax
ffffffff804c1e23:        0 	3b 85 74 04 00 00    	cmp    0x474(%rbp),%eax
ffffffff804c1e29:        0 	48 89 9d e8 04 00 00 	mov    %rbx,0x4e8(%rbp)
ffffffff804c1e30:        0 	76 11                	jbe    ffffffff804c1e43 <tcp_ack+0x132c>
ffffffff804c1e32:        0 	be e5 08 00 00       	mov    $0x8e5,%esi
ffffffff804c1e37:        0 	48 c7 c7 9d d9 6a 80 	mov    $0xffffffff806ad99d,%rdi
ffffffff804c1e3e:        0 	e8 72 43 d7 ff       	callq  ffffffff802361b5 <warn_on_slowpath>
ffffffff804c1e43:        0 	44 89 e6             	mov    %r12d,%esi
ffffffff804c1e46:        0 	48 89 ef             	mov    %rbp,%rdi
ffffffff804c1e49:        0 	e8 9f d1 ff ff       	callq  ffffffff804befed <tcp_cwnd_down>
ffffffff804c1e4e:        0 	e9 2c 01 00 00       	jmpq   ffffffff804c1f7f <tcp_ack+0x1468>
ffffffff804c1e53:       47 	8b 74 24 1c          	mov    0x1c(%rsp),%esi
ffffffff804c1e57:      513 	48 89 ef             	mov    %rbp,%rdi
ffffffff804c1e5a:        0 	e8 62 d4 ff ff       	callq  ffffffff804bf2c1 <tcp_cong_avoid>
ffffffff804c1e5f:      427 	41 80 e4 34          	and    $0x34,%r12b
ffffffff804c1e63:     1234 	75 07                	jne    ffffffff804c1e6c <tcp_ack+0x1355>
ffffffff804c1e65:        0 	83 7c 24 54 00       	cmpl   $0x0,0x54(%rsp)
ffffffff804c1e6a:        0 	75 3c                	jne    ffffffff804c1ea8 <tcp_ack+0x1391>
ffffffff804c1e6c:        0 	48 8b 7d 78          	mov    0x78(%rbp),%rdi
ffffffff804c1e70:      916 	e8 8d c9 ff ff       	callq  ffffffff804be802 <dst_confirm>
ffffffff804c1e75:        3 	eb 31                	jmp    ffffffff804c1ea8 <tcp_ack+0x1391>
ffffffff804c1e77:        0 	48 8b 95 d8 01 00 00 	mov    0x1d8(%rbp),%rdx
ffffffff804c1e7e:       99 	48 85 d2             	test   %rdx,%rdx
ffffffff804c1e81:       16 	74 25                	je     ffffffff804c1ea8 <tcp_ack+0x1391>
ffffffff804c1e83:        0 	8b 85 44 04 00 00    	mov    0x444(%rbp),%eax
ffffffff804c1e89:        0 	03 85 00 04 00 00    	add    0x400(%rbp),%eax
ffffffff804c1e8f:        0 	3b 42 54             	cmp    0x54(%rdx),%eax
ffffffff804c1e92:        0 	78 1e                	js     ffffffff804c1eb2 <tcp_ack+0x139b>
ffffffff804c1e94:        0 	c6 85 7b 03 00 00 00 	movb   $0x0,0x37b(%rbp)
ffffffff804c1e9b:        0 	be 03 00 00 00       	mov    $0x3,%esi
ffffffff804c1ea0:        0 	48 89 ef             	mov    %rbp,%rdi
ffffffff804c1ea3:        0 	e8 ab c9 ff ff       	callq  ffffffff804be853 <inet_csk_clear_xmit_timer>
ffffffff804c1ea8:      520 	b8 01 00 00 00       	mov    $0x1,%eax
ffffffff804c1ead:      994 	e9 ec 00 00 00       	jmpq   ffffffff804c1f9e <tcp_ack+0x1487>
ffffffff804c1eb2:        0 	0f b6 8d 7b 03 00 00 	movzbl 0x37b(%rbp),%ecx
ffffffff804c1eb9:        0 	8b 95 58 03 00 00    	mov    0x358(%rbp),%edx
ffffffff804c1ebf:        0 	b8 30 75 00 00       	mov    $0x7530,%eax
ffffffff804c1ec4:        0 	be 03 00 00 00       	mov    $0x3,%esi
ffffffff804c1ec9:        0 	48 89 ef             	mov    %rbp,%rdi
ffffffff804c1ecc:        0 	d3 e2                	shl    %cl,%edx
ffffffff804c1ece:        0 	b9 30 75 00 00       	mov    $0x7530,%ecx
ffffffff804c1ed3:        0 	81 fa 30 75 00 00    	cmp    $0x7530,%edx
ffffffff804c1ed9:        0 	0f 47 d0             	cmova  %eax,%edx
ffffffff804c1edc:        0 	89 d2                	mov    %edx,%edx
ffffffff804c1ede:        0 	e8 00 d7 ff ff       	callq  ffffffff804bf5e3 <inet_csk_reset_xmit_timer>
ffffffff804c1ee3:        0 	eb c3                	jmp    ffffffff804c1ea8 <tcp_ack+0x1391>
ffffffff804c1ee5:        0 	80 78 25 00          	cmpb   $0x0,0x25(%rax)
ffffffff804c1ee9:        0 	74 1a                	je     ffffffff804c1f05 <tcp_ack+0x13ee>
ffffffff804c1eeb:        0 	8b 54 24 18          	mov    0x18(%rsp),%edx
ffffffff804c1eef:        0 	e8 cc e3 ff ff       	callq  ffffffff804c02c0 <tcp_sacktag_write_queue>
ffffffff804c1ef4:        0 	80 bd 78 03 00 00 00 	cmpb   $0x0,0x378(%rbp)
ffffffff804c1efb:        0 	75 08                	jne    ffffffff804c1f05 <tcp_ack+0x13ee>
ffffffff804c1efd:        0 	48 89 ef             	mov    %rbp,%rdi
ffffffff804c1f00:        0 	e8 68 d3 ff ff       	callq  ffffffff804bf26d <tcp_try_keep_open>
ffffffff804c1f05:        0 	48 85 ed             	test   %rbp,%rbp
ffffffff804c1f08:        0 	74 2f                	je     ffffffff804c1f39 <tcp_ack+0x1422>
ffffffff804c1f0a:        0 	be 0a 00 00 00       	mov    $0xa,%esi
ffffffff804c1f0f:        0 	48 89 ef             	mov    %rbp,%rdi
ffffffff804c1f12:        0 	e8 f1 d5 ff ff       	callq  ffffffff804bf508 <sock_flag>
ffffffff804c1f17:        0 	85 c0                	test   %eax,%eax
ffffffff804c1f19:        0 	74 1e                	je     ffffffff804c1f39 <tcp_ack+0x1422>
ffffffff804c1f1b:        0 	8b 8d fc 03 00 00    	mov    0x3fc(%rbp),%ecx
ffffffff804c1f21:        0 	8b 95 00 04 00 00    	mov    0x400(%rbp),%edx
ffffffff804c1f27:        0 	48 c7 c7 e5 d9 6a 80 	mov    $0xffffffff806ad9e5,%rdi
ffffffff804c1f2e:        0 	8b 74 24 1c          	mov    0x1c(%rsp),%esi
ffffffff804c1f32:        0 	31 c0                	xor    %eax,%eax
ffffffff804c1f34:        0 	e8 3b 4e d7 ff       	callq  ffffffff80236d74 <printk>
ffffffff804c1f39:        0 	31 c0                	xor    %eax,%eax
ffffffff804c1f3b:        0 	eb 61                	jmp    ffffffff804c1f9e <tcp_ack+0x1487>
ffffffff804c1f3d:        0 	c7 44 24 44 00 00 00 	movl   $0x0,0x44(%rsp)
ffffffff804c1f44:        0 	00 
ffffffff804c1f45:        0 	e9 c3 ef ff ff       	jmpq   ffffffff804c0f0d <tcp_ack+0x3f6>
ffffffff804c1f4a:       54 	41 f6 c4 04          	test   $0x4,%r12b
ffffffff804c1f4e:      424 	0f 84 0b ff ff ff    	je     ffffffff804c1e5f <tcp_ack+0x1348>
ffffffff804c1f54:      364 	85 c9                	test   %ecx,%ecx
ffffffff804c1f56:        0 	0f 84 f7 fe ff ff    	je     ffffffff804c1e53 <tcp_ack+0x133c>
ffffffff804c1f5c:        0 	e9 fe fe ff ff       	jmpq   ffffffff804c1e5f <tcp_ack+0x1348>
ffffffff804c1f61:        0 	8a 85 9c 04 00 00    	mov    0x49c(%rbp),%al
ffffffff804c1f67:        0 	c0 e8 04             	shr    $0x4,%al
ffffffff804c1f6a:        0 	a8 02                	test   $0x2,%al
ffffffff804c1f6c:        0 	0f 85 10 f8 ff ff    	jne    ffffffff804c1782 <tcp_ack+0xc6b>
ffffffff804c1f72:        0 	e9 61 f8 ff ff       	jmpq   ffffffff804c17d8 <tcp_ack+0xcc1>
ffffffff804c1f77:        0 	48 89 ef             	mov    %rbp,%rdi
ffffffff804c1f7a:        0 	e8 2e d0 ff ff       	callq  ffffffff804befad <tcp_moderate_cwnd>
ffffffff804c1f7f:        0 	48 89 ef             	mov    %rbp,%rdi
ffffffff804c1f82:        0 	e8 f7 47 00 00       	callq  ffffffff804c677e <tcp_xmit_retransmit_queue>
ffffffff804c1f87:        0 	e9 d3 fe ff ff       	jmpq   ffffffff804c1e5f <tcp_ack+0x1348>
ffffffff804c1f8c:        0 	80 bd 78 03 00 00 01 	cmpb   $0x1,0x378(%rbp)
ffffffff804c1f93:        0 	0f 87 be fc ff ff    	ja     ffffffff804c1c57 <tcp_ack+0x1140>
ffffffff804c1f99:        0 	e9 7b fc ff ff       	jmpq   ffffffff804c1c19 <tcp_ack+0x1102>
ffffffff804c1f9e:      493 	48 81 c4 88 00 00 00 	add    $0x88,%rsp
ffffffff804c1fa5:     1288 	5b                   	pop    %rbx
ffffffff804c1fa6:        0 	5d                   	pop    %rbp
ffffffff804c1fa7:      446 	41 5c                	pop    %r12
ffffffff804c1fa9:        0 	41 5d                	pop    %r13
ffffffff804c1fab:        2 	41 5e                	pop    %r14
ffffffff804c1fad:      447 	41 5f                	pop    %r15
ffffffff804c1faf:        0 	c3                   	retq   

No real obvious single-instruction hotspots i can see.

But i can see another problem: the function is too large and its flow 
is not fall-through in any way. As you can see it from the profile 
distribution it is broken into 25-30 separate code sequences.

The function consists of more than 1200 instructions and is 5200 bytes 
large. According to the profile above, only 350 instructions are used 
and about 850 of those instructions are never used by this workload. 
So in theory this function should only take up ~1.5K of the 
instruction cache.

But because execution is spread out into 25+ smaller pieces, it takes 
up ~4K of the instruction cache instead (there's a single ~1.2K hole 
in the middle, i subtracted that) - 2-3 times larger than it should.

So this code could make good use of the (brand-new ;-) branch-tracer 
ftrace plugin and grow a few well-placed likely()/unlikely() places - 
at least for this workload. I think.

	Ingo
