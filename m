Return-Path: <linux-kernel-owner+w=401wt.eu-S1757912AbYFBKtW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757912AbYFBKtW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 06:49:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753360AbYFBKtE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 06:49:04 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:32856 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759025AbYFBKtB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 06:49:01 -0400
Date: Mon, 2 Jun 2008 12:48:51 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: Adrian Bunk <bunk@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [#2][PATCH] x86: break mutual header inclusion
Message-ID: <20080602104851.GD898@elte.hu>
References: <20080528074619.GA9235@damson.getinternet.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080528074619.GA9235@damson.getinternet.no>
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


* Vegard Nossum <vegard.nossum@gmail.com> wrote:

> From: Vegard Nossum <vegard.nossum@gmail.com>
> Date: Tue, 27 May 2008 21:38:35 +0200
> Subject: [PATCH] x86: break mutual header inclusion
> 
> This breaks up the mutual inclusion between headers ptrace.h and vm86.h
> by moving some small part of vm86.h which is needed by ptrace.h into
> processor-flags.h.
> 
> We also try to move #include lines to the top.
> 
> This has been compile tested on x86_32 and x86_64 defconfig, and run
> through 'make headers_check'.

applied to tip/x86/cleanups. Thanks,

	Ingo
