Return-Path: <linux-kernel-owner+w=401wt.eu-S1755080AbZKIJ0q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755080AbZKIJ0q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 04:26:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755007AbZKIJ0p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 04:26:45 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:49828 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755001AbZKIJ0o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 04:26:44 -0500
Date: Mon, 9 Nov 2009 10:26:29 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Neil Horman <nhorman@tuxdriver.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, marcin.slusarz@gmail.com, tglx@linutronix.de,
       mingo@redhat.com, hpa@zytor.com,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 0/3] extend get/setrlimit to support setting rlimits
 external to a process (v7)
Message-ID: <20091109092629.GA26890@elte.hu>
References: <20091102152520.GG23776@elte.hu>
 <20091102175407.GE4075@hmsreliant.think-freely.org>
 <20091102185137.GA28803@elte.hu>
 <20091103002355.GB19891@localhost.localdomain>
 <20091104112632.GA9243@elte.hu>
 <20091105204843.GA2980@hmsreliant.think-freely.org>
 <20091106092600.GC22505@elte.hu>
 <4AF7D8C2.60807@gmail.com>
 <20091109090143.GB24020@elte.hu>
 <4AF7DF41.5080100@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AF7DF41.5080100@gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jiri Slaby <jirislaby@gmail.com> wrote:

> On 11/09/2009 10:01 AM, Ingo Molnar wrote:
> > So i guess renaming setrlimit to do_setrlimit and adding the syscall 
> > from Neil's patch should bring the two series into sync, right?
> 
> Looks like that. I have a nit, 32-bit programs on 64-bit x86 won't 
> work. I think we should add compat handlers for ia32 emulation too?

Yeah.

	Ingo
