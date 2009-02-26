Return-Path: <linux-kernel-owner+w=401wt.eu-S1759445AbZBZD0u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759445AbZBZD0u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 22:26:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753679AbZBZD0l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 22:26:41 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:43434 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751590AbZBZD0k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 22:26:40 -0500
Date: Thu, 26 Feb 2009 04:26:18 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Tejun Heo <tj@kernel.org>
Cc: Yinghai Lu <yinghai@kernel.org>, rusty@rustcorp.com.au, tglx@linutronix.de,
       x86@kernel.org, linux-kernel@vger.kernel.org, hpa@zytor.com,
       jeremy@goop.org, cpw@sgi.com, nickpiggin@yahoo.com.au,
       ink@jurassic.park.msu.ru
Subject: Re: [PATCH core/percpu] percpu: fix too low alignment restriction
	on UP
Message-ID: <20090226032618.GC22223@elte.hu>
References: <1235445101-7882-1-git-send-email-tj@kernel.org> <20090224201718.GE28772@elte.hu> <20090224205105.GA19460@elte.hu> <20090224211659.GA3687@elte.hu> <49A4ABAC.90602@kernel.org> <20090225125935.GG26273@elte.hu> <20090225134343.GA30279@elte.hu> <49A5F876.2080607@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49A5F876.2080607@kernel.org>
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


* Tejun Heo <tj@kernel.org> wrote:

> UP __alloc_percpu() triggered WARN_ON_ONCE() if the requested
> alignment is larger than that of unsigned long long, which is too
> small for all the cacheline aligned allocations.  Bump it up to
> SMP_CACHE_BYTES which kmalloc allocations generally guarantee.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Reported-by: Ingo Molnar <mingo@elte.hu>
> ---
> Hello, Ingo.
> 
> I somehow completely forgot about testing UP.  Sorry about that. :-)
> The following patch should do it.  Also available in the #tj-percpu
> tree.

Pulled into tip:core/percpu, thanks Tejun!

	Ingo
