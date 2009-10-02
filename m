Return-Path: <linux-kernel-owner+w=401wt.eu-S1757446AbZJBJfy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757446AbZJBJfy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 05:35:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757411AbZJBJfy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 05:35:54 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:56888 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757410AbZJBJfx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 05:35:53 -0400
Date: Fri, 2 Oct 2009 11:34:53 +0200
From: Ingo Molnar <mingo@elte.hu>
To: cl@linux-foundation.org
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       David Howells <dhowells@redhat.com>, Tejun Heo <tj@kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Eric Dumazet <dada1@cosmosbay.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [this_cpu_xx V4 01/20] Introduce this_cpu_ptr() and generic
	this_cpu_* operations
Message-ID: <20091002093453.GA21427@elte.hu>
References: <20091001212521.123389189@gentwo.org> <20091001212557.773205427@gentwo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091001212557.773205427@gentwo.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0002]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* cl@linux-foundation.org <cl@linux-foundation.org> wrote:

> --- linux-2.6.orig/include/asm-generic/percpu.h	2009-10-01 14:14:00.000000000 -0500
> +++ linux-2.6/include/asm-generic/percpu.h	2009-10-01 14:14:02.000000000 -0500

> @@ -66,6 +69,8 @@ extern void setup_per_cpu_areas(void);
>  #define per_cpu(var, cpu)			(*((void)(cpu), &per_cpu_var(var)))
>  #define __get_cpu_var(var)			per_cpu_var(var)
>  #define __raw_get_cpu_var(var)			per_cpu_var(var)
> +#define this_cpu_ptr(ptr) per_cpu_ptr(ptr, 0)
> +#define __this_cpu_ptr(ptr) this_cpu_ptr(ptr)

Small detail: please have a look at the existing vertical alignment 
style of the code there and follow it with new entries.

Thanks,

	Ingo
