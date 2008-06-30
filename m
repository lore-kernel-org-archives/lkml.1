Return-Path: <linux-kernel-owner+w=401wt.eu-S1759848AbYF3MTF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759848AbYF3MTF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 08:19:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756566AbYF3MSx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 08:18:53 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:46918 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755751AbYF3MSx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 08:18:53 -0400
Date: Mon, 30 Jun 2008 14:18:23 +0200
From: Ingo Molnar <mingo@elte.hu>
To: TAKADA Yoshihito <takada@mbf.nifty.com>
Cc: linux-kernel@vger.kernel.org, Roland McGrath <roland@redhat.com>,
       the arch/x86 maintainers <x86@kernel.org>
Subject: Re: [PATCH] ptrace GET/SET FPXREGS broken
Message-ID: <20080630121823.GB25092@elte.hu>
References: <20080630.134445.193700135.takada@mbf.nifty.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080630.134445.193700135.takada@mbf.nifty.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: 0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.5 required=5.9 tests=BAYES_40 autolearn=no SpamAssassin version=3.2.3
	0.5 BAYES_40               BODY: Bayesian spam probability is 20 to 40%
	[score: 0.2061]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* TAKADA Yoshihito <takada@mbf.nifty.com> wrote:

> Hi
> When I update kernel 2.6.25 from 2.6.24, gdb does not work.
> On 2.6.25, ptrace(PTRACE_GETFPXREGS, ...) returns ENODEV.
> But 2.6.24 kernel's ptrace() returns EIO.
> It is issue of compatibility.
> I attached test program as pt.c and patch for fix it.

this is a side-effect of the "x86: x86 i387 user_regset" commit, 
v2.6.24-4379-g4421011. Roland Cc:-ed.

	Ingo
