Return-Path: <linux-kernel-owner+w=401wt.eu-S1756817AbYHKTZk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756817AbYHKTZk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 15:25:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756701AbYHKTZ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 15:25:29 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:45988 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756606AbYHKTZ1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 15:25:27 -0400
Date: Mon, 11 Aug 2008 21:25:09 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Oruba <peter.oruba@amd.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Max Krasnyansky <maxk@qualcomm.com>,
       Tigran Aivazian <tigran@aivazian.fsnet.co.uk>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [patch 2/5] [PATCH 2/5] x86: Minor correction to header file
Message-ID: <20080811192509.GE12788@elte.hu>
References: <20080806152117.198754464@amd.com> <20080806152319.479475593@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080806152319.479475593@amd.com>
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


* Peter Oruba <peter.oruba@amd.com> wrote:

> Signed-off-by: Peter Oruba <peter.oruba@amd.com>
> ---
>  include/asm-x86/microcode.h |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/include/asm-x86/microcode.h b/include/asm-x86/microcode.h
> index 072bef1..fb08022 100644
> --- a/include/asm-x86/microcode.h
> +++ b/include/asm-x86/microcode.h
> @@ -1,5 +1,5 @@
> -extern int microcode_init(void *opaque, struct module *module);
> -extern void microcode_exit(void);
> +int microcode_init(void *opaque, struct module *module);
> +void microcode_exit(void);

why? extern is the typical way to specify interfaces.

	Ingo
