Return-Path: <linux-kernel-owner+w=401wt.eu-S1754530AbZBIJaX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754530AbZBIJaX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 04:30:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752637AbZBIJaF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 04:30:05 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:53700 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752625AbZBIJaE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 04:30:04 -0500
Date: Mon, 9 Feb 2009 10:29:51 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Brian Gerst <brgerst@gmail.com>
Cc: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org,
       Jiri Slaby <jirislaby@gmail.com>
Subject: Re: [PATCH 2/3] x86: Use linker to offset symbols by __per_cpu_load
Message-ID: <20090209092951.GB7930@elte.hu>
References: <1234105120-19731-1-git-send-email-brgerst@gmail.com> <1234105120-19731-2-git-send-email-brgerst@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1234105120-19731-2-git-send-email-brgerst@gmail.com>
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


* Brian Gerst <brgerst@gmail.com> wrote:

> Impact: cleanup and bug fix
> 
> Use the linker to create symbols for certain per-cpu variables
> that are offset by __per_cpu_load.  This allows the removal of
> the runtime fixup of the GDT pointer, which fixes a bug with
> resume reported by Jiri Slaby.
> 
> Signed-off-by: Brian Gerst <brgerst@gmail.com>
> Cc: Jiri Slaby <jirislaby@gmail.com>
> ---
>  arch/x86/include/asm/percpu.h    |   22 ++++++++++++++++++++++
>  arch/x86/include/asm/processor.h |    2 ++
>  arch/x86/kernel/cpu/common.c     |    6 +-----
>  arch/x86/kernel/head_64.S        |   21 ++-------------------
>  arch/x86/kernel/vmlinux_64.lds.S |    8 ++++++++
>  5 files changed, 35 insertions(+), 24 deletions(-)

applied to tip/core/percpu, thanks!

Also added these tags:

Reported-by: Jiri Slaby <jirislaby@gmail.com>
Acked-by: Jiri Slaby <jirislaby@gmail.com>

	Ingo
