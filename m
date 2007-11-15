Return-Path: <linux-kernel-owner+w=401wt.eu-S932786AbXKOUM5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932786AbXKOUM5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 15:12:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752269AbXKOUMs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 15:12:48 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:46228 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758170AbXKOUMr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 15:12:47 -0500
Date: Thu, 15 Nov 2007 21:12:27 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Ulrich Drepper <drepper@redhat.com>
Cc: Frederik Deweerdt <deweerdt@free.fr>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, tglx@linutronix.de,
       torvalds@linux-foundation.org
Subject: Re: [PATCHv2 2/4] x86&x86-64 support for sys_indirect
Message-ID: <20071115201226.GA25641@elte.hu>
References: <200711151822.lAFIMVvW028590@devserv.devel.redhat.com> <20071115192947.GF1299@slug> <473CA729.5010906@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <473CA729.5010906@redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Ulrich Drepper <drepper@redhat.com> wrote:

> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> Frederik Deweerdt wrote:
> \>> +     sys_call_table[INDIRECT_SYSCALL(regs)->eax] ((regs)->ebx,
> (regs)->ecx, \
> >                                              ^^^^^-> I take it that ->eax is wrong here? 
> 
> Yep, my bad.  I've retired the 32-bit machines around here.

weird - i built it on 32-bit and it should have failed the build?

	Ingo
