Return-Path: <linux-kernel-owner+w=401wt.eu-S1755166AbYFBKrc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755166AbYFBKrc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 06:47:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758908AbYFBKrU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 06:47:20 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:60712 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758897AbYFBKrT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 06:47:19 -0400
Date: Mon, 2 Jun 2008 12:47:06 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: linux-kernel@vger.kernel.org, the arch/x86 maintainers <x86@kernel.org>
Subject: Re: [PATCH] x86: fix incomplete include guard
Message-ID: <20080602104706.GC898@elte.hu>
References: <20080527190346.GA16422@damson.getinternet.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080527190346.GA16422@damson.getinternet.no>
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

> Hi,
> 
> It seems that suspend_32.h and xor_32.h are missing include guards 
> too, but I'm not touching those since I don't know if that's intended 
> or not :-)

it's not intended - could you send a patch for those too?

> --- a/include/asm-x86/seccomp_32.h
> +++ b/include/asm-x86/seccomp_32.h
> @@ -1,4 +1,5 @@
>  #ifndef _ASM_SECCOMP_H
> +#define _ASM_SECCOMP_H

applied to tip/x86/cleanups. Thanks,

	Ingo
