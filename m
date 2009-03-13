Return-Path: <linux-kernel-owner+w=401wt.eu-S1757935AbZCMFcy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757935AbZCMFcy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 01:32:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753064AbZCMFcp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 01:32:45 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:55881 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753048AbZCMFco (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 01:32:44 -0400
Date: Fri, 13 Mar 2009 06:32:14 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, Mike Travis <travis@sgi.com>
Subject: Re: [PULL] x86 cpumask work
Message-ID: <20090313053214.GA21183@elte.hu>
References: <200903121453.45163.rusty@rustcorp.com.au> <200903131316.26455.rusty@rustcorp.com.au> <20090313032015.GD18760@elte.hu> <200903131504.09388.rusty@rustcorp.com.au> <20090313045516.GA27326@elte.hu> <20090313052754.GA20389@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090313052754.GA20389@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


another box crashed too, with:

Total of 1 processors activated (1994.75 BogoMIPS).                                 
BUG: unable to handle kernel NULL pointer dereference at (null)                     
IP: [<ffffffff8025931c>] cpu_attach_domain+0x77/0x1f9                               
PGD 0                                                                        
Call Trace:                                                                         
 [<ffffffff80258b2a>] ? init_numa_sched_groups_power+0x7a/0x9c                      
 [<ffffffff80259d19>] __build_sched_domains+0x87b/0x970                             
 [<ffffffff8025a348>] arch_init_sched_domains+0xaf/0xc0                             
 [<ffffffff809a2827>] ? mutex_lock_nested+0x35/0x3a                                 
 [<ffffffff80e42117>] sched_init_smp+0x5d/0x185                                     
 [<ffffffff80e2e68c>] ? smp_init+0x105/0x10d                                        
 [<ffffffff80e2e71a>] kernel_init+0x86/0xfc                                         
 [<ffffffff809a336b>] ? trace_hardirqs_on_thunk+0x3a/0x3f                           
 [<ffffffff80228dba>] child_rip+0xa/0x20                                            
 [<ffffffff8022877c>] ? restore_args+0x0/0x30                                       
 [<ffffffff80e2e694>] ? kernel_init+0x0/0xfc                                        
 [<ffffffff80228db0>] ? child_rip+0x0/0x20              

	Ingo
