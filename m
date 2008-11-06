Return-Path: <linux-kernel-owner+w=401wt.eu-S1753845AbYKFHMj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753845AbYKFHMj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 02:12:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752433AbYKFHMb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 02:12:31 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:58790 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752231AbYKFHMa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 02:12:30 -0500
Date: Thu, 6 Nov 2008 08:12:06 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: akpm@linux-foundation.org, Pekka Enberg <penberg@cs.helsinki.fi>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org, travis@sgi.com,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Vegard Nossum <vegard.nossum@gmail.com>
Subject: Re: [patch 5/7] x86_64: Support for cpu ops
Message-ID: <20081106071206.GH15731@elte.hu>
References: <20081105231634.133252042@quilx.com> <20081105231649.108433550@quilx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081105231649.108433550@quilx.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Christoph Lameter <cl@linux-foundation.org> wrote:

> +#
> +# X86_64's spare segment register points to the PDA instead of the per
> +# cpu area. Therefore x86_64 is not able to generate atomic vs. interrupt
> +# per cpu instructions.
> +#
> +config HAVE_CPU_OPS
> +	def_bool y
> +	depends on X86_32
> +

hm, what happened to the rebase-PDA-to-percpu-area optimization 
patches you guys were working on? I remember there was some binutils 
flakiness - weird crashes and things like that. Did you ever manage to 
stabilize it? It would be sad if only 32-bit could take advantage of 
the optimized ops.

	Ingo
