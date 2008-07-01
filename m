Return-Path: <linux-kernel-owner+w=401wt.eu-S1760061AbYGAU1L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760061AbYGAU1L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 16:27:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754825AbYGAU06
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 16:26:58 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:55018 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754207AbYGAU05 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 16:26:57 -0400
Date: Tue, 1 Jul 2008 22:26:45 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: small unifications of address printing
Message-ID: <20080701202645.GF4896@elte.hu>
References: <20080701155217.GA22318@damson.getinternet.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080701155217.GA22318@damson.getinternet.no>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0017]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Vegard Nossum <vegard.nossum@gmail.com> wrote:

> (resend to lkml)
> 
> From: Vegard Nossum <vegard.nossum@gmail.com>
> Date: Tue, 1 Jul 2008 14:51:08 +0200
> Subject: [PATCH] x86: small unifications of address printing
> 
> 'man 3 printf' tells me that %p should be printed as if by %#x, but
> this is not true for the kernel, which does not use the '0x' prefix
> for the %p conversion specifier.
> 
> A small cast to (void *) is also prettier than #ifdef/#else/#endif.

applied to tip/x86/debug - thanks Vegard.

	Ingo
