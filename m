Return-Path: <linux-kernel-owner+w=401wt.eu-S1761365AbYARUql@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761365AbYARUql (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 15:46:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759564AbYARUqe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 15:46:34 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:40388 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758568AbYARUqd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 15:46:33 -0500
Date: Fri, 18 Jan 2008 21:46:05 +0100
From: Ingo Molnar <mingo@elte.hu>
To: travis@sgi.com
Cc: Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       Christoph Lameter <clameter@sgi.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH 4/5] x86: Add config variables for SMP_MAX
Message-ID: <20080118204605.GC3079@elte.hu>
References: <20080118183011.354965000@sgi.com> <20080118183011.917801000@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080118183011.917801000@sgi.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* travis@sgi.com <travis@sgi.com> wrote:

> +config THREAD_ORDER
> +	int "Kernel stack size (in page order)"
> +	range 1 3
> +	depends on X86_64_SMP
> +	default "3" if X86_SMP_MAX
> +	default "1"
> +	help
> +	  Increases kernel stack size.

nack on kernel stack bloat. We worked hard to get the kernel stack 
footprint down to 4K on x86. (and it is 4K on most distros, despite 
there still being a legacy 8K stack size) No way are we going to throw 
away all that now ...

	Ingo
