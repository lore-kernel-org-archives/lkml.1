Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752178Ab0BVKue (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 05:50:34 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:54493 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750953Ab0BVKud (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 05:50:33 -0500
Date: Mon, 22 Feb 2010 11:50:25 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jan Engelhardt <jengelh@medozas.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?unknown-8bit?B?RnLDqWTDqXJpYw==?= Weisbecker 
	<fweisbec@gmail.com>
Subject: Re: tools/perf: libraries must come after objects
Message-ID: <20100222105025.GA25661@elte.hu>
References: <alpine.LSU.2.01.1002110124030.13770@obet.zrqbmnf.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.01.1002110124030.13770@obet.zrqbmnf.qr>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jan Engelhardt <jengelh@medozas.de> wrote:

> parent b4bdd73ce865213a5653dc424873e8da37e858cc (v2.6.32.7)
> commit 588424af1a51fa41ea4811200889d6a03219c6fd
> Author: Jan Engelhardt <jengelh@medozas.de>
> Date:   Thu Feb 11 01:20:54 2010 +0100
> 
> tools/perf: libraries must come after objects
> 
> Link order matters, especially now since distributions are
> using -Wl,--as-needed.
> 
> Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
> ---
>  tools/perf/Makefile |   16 ++++++++--------
>  1 files changed, 8 insertions(+), 8 deletions(-)

FYI, this patch doesnt apply to the latest version of perf:

 patching file tools/perf/Makefile
 Hunk #1 FAILED at 201.
 Hunk #2 FAILED at 421.
 Hunk #3 FAILED at 432.
 Hunk #4 succeeded at 770 (offset 93 lines).
 3 out of 4 hunks FAILED -- rejects in file tools/perf/Makefile

you can find the devel tree at:

  http://people.redhat.com/mingo/tip.git/README

Thanks,

	Ingo
