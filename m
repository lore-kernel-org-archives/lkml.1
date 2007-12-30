Return-Path: <linux-kernel-owner+w=401wt.eu-S1753615AbXL3RXQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753615AbXL3RXQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2007 12:23:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751808AbXL3RXA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Dec 2007 12:23:00 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:59223 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751803AbXL3RW7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2007 12:22:59 -0500
Date: Sun, 30 Dec 2007 18:22:50 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [x86] is checkpatch.pl broken
Message-ID: <20071230172250.GD22833@elte.hu>
References: <20071225170737.GA3887@cvg.org> <477196DC.9000704@zytor.com> <aa79d98a0712260238n4848e812l4a66f86b414cc277@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aa79d98a0712260238n4848e812l4a66f86b414cc277@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0004]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Cyrill Gorcunov <gorcunov@gmail.com> wrote:

> orig:
> mbr_base = (buf_base+sector_size-1) & ~(sector_size-1);
> new (could be):
> mbr_base = (buf_base + sector_size - 1) & ~(sector_size - 1);
> 
> Is a new version that bad?

it's certainly acceptable as newly introduced code but only borderline 
better than the original code. I'd suggest to stick to the problem areas 
that checkpatch.pl complains about at the moment - we have really 
obvious bad looking pieces of code that checkpatch.pl reports, and going 
after the borderline cases will only result in coding-style lawyering 
and flamewars, not any genuine increase in code quality ;-)

for example:

  arch/x86/kernel/bootflag.c:

  total: 19 errors, 2 warnings, 98 lines checked

or:

  arch/x86/kernel/apm_32.c:

  total: 56 errors, 31 warnings, 2402 lines checked

and once we have nothing but the borderline cases and if we get really 
bored we can start coding style flamewars ;-)

	Ingo
