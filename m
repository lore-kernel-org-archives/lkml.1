Return-Path: <linux-kernel-owner+w=401wt.eu-S1755977AbZCJPUq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755977AbZCJPUq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 11:20:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752941AbZCJPUi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 11:20:38 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:39400 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751999AbZCJPUh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 11:20:37 -0400
Date: Tue, 10 Mar 2009 16:20:29 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [git-pull -tip V2] x86: cpu architecture debug code
Message-ID: <20090310152029.GN3850@elte.hu>
References: <1236684201.3301.11.camel@localhost.localdomain> <20090310122806.GE5794@elte.hu> <1236697752.3387.2.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1236697752.3387.2.camel@localhost.localdomain>
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


* Jaswinder Singh Rajput <jaswinder@kernel.org> wrote:

> +#include <linux/interrupt.h>
> +#include <linux/compiler.h>
> +#include <linux/kprobes.h>
> +#include <linux/signal.h>
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/errno.h>
> +#include <linux/sched.h>
> +#include <linux/types.h>
> +#include <linux/init.h>
> +#include <linux/smp.h>
> +#include <linux/slab.h>
> +#include <linux/percpu.h>
> +#include <linux/debugfs.h>
> +#include <linux/seq_file.h>

If you look at arch/x86/mm/fault.c, they are sorted by length, 
and within the same length they are sorted alphabetically.

> +
> +#include <asm/system.h>
> +#include <asm/traps.h>
> +#include <asm/apic.h>
> +#include <asm/desc.h>
> +#include <asm/cpu_debug.h>

ditto.

	Ingo
