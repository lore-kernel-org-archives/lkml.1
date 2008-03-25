Return-Path: <linux-kernel-owner+w=401wt.eu-S1756568AbYCYPHe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756568AbYCYPHe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 11:07:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754768AbYCYPHY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 11:07:24 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:55943 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754549AbYCYPHY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 11:07:24 -0400
Date: Tue, 25 Mar 2008 16:06:30 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Glauber Costa <gcosta@redhat.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, glommer@gmail.com,
       tglx@linutronix.de, yhlu.kernel@gmail.com
Subject: Re: [PATCH 1/2] move ipi definitions to mach_ipi.h
Message-ID: <20080325150630.GA13828@elte.hu>
References: <1206388361-17265-1-git-send-email-gcosta@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1206388361-17265-1-git-send-email-gcosta@redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-0.5 required=5.9 tests=BAYES_20 autolearn=no SpamAssassin version=3.2.3
	-0.5 BAYES_20               BODY: Bayesian spam probability is 5 to 20%
	[score: 0.0580]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Glauber Costa <gcosta@redhat.com> wrote:

> +++ b/include/asm-x86/mach-default/mach_ipi.h

> -static inline void send_IPI_mask(cpumask_t mask, int vector)
> -{
> -	send_IPI_mask_bitmask(mask, vector);
> -}
> +void send_IPI_mask(cpumask_t mask, int vector);

> +#else
> +static inline void send_IPI_mask(cpumask_t mask, int vector);
> +{
> +	send_IPI_mask_bitmask(mask, vector);
> +}

this trivially doesnt build on 32-bit, for multiple reasons...

	Ingo
