Return-Path: <linux-kernel-owner+w=401wt.eu-S1752188AbXBEJKg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752188AbXBEJKg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 04:10:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752191AbXBEJKg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 04:10:36 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:57444 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752188AbXBEJKf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 04:10:35 -0500
Date: Mon, 5 Feb 2007 09:18:33 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Sunil Naidu <akula2.shark@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: linux-2.6.20-rc7-rt3 - compile error!
Message-ID: <20070205081830.GA18130@elte.hu>
References: <8355959a0702040433v51cb5e45o24609d4d2cea6545@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8355959a0702040433v51cb5e45o24609d4d2cea6545@mail.gmail.com>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -5.3
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-5.3 required=5.9 tests=ALL_TRUSTED,BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-3.3 ALL_TRUSTED            Did not pass through any untrusted hosts
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0001]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Sunil Naidu <akula2.shark@gmail.com> wrote:

> Hi Ingo,
> 
> This is what am getting:-
> 

> arch/i386/mm/built-in.o: In function `flush_cr3_cache':
> (.text+0x25c): undefined reference to `paravirt_enabled'
> arch/i386/mm/built-in.o: In function `flush_cr3_cache':
> (.text+0x26c): undefined reference to `hypercall'
> make: *** [.tmp_vmlinux1] Error 1

could you try 2.6.20-rt1? It should have this fixed.

	Ingo
