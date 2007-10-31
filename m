Return-Path: <linux-kernel-owner+w=401wt.eu-S1758585AbXJaKUz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758585AbXJaKUz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 06:20:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753716AbXJaKUr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 06:20:47 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:33450 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753653AbXJaKUq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 06:20:46 -0400
Date: Wed, 31 Oct 2007 11:20:35 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Eric Dumazet <dada1@cosmosbay.com>
Cc: Paul Menage <menage@google.com>,
       Linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] CFS : Use NSEC_PER_MSEC and NSEC_PER_SEC in
	kernel/sched.c and kernel/sysctl.c
Message-ID: <20071031102035.GD5817@elte.hu>
References: <47280DE6.7030606@cosmosbay.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47280DE6.7030606@cosmosbay.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Eric Dumazet <dada1@cosmosbay.com> wrote:

> 1) hardcoded 1000000000 value is used five times in places where 
> NSEC_PER_SEC might be more readable.
>
> 2) A conversion from nsec to msec uses the hardcoded 1000000 value, which 
> is a candidate for NSEC_PER_MSEC.
>
> Signed-off-by: Eric Dumazet <dada1@cosmosbay.com>

thanks, applied.

	Ingo
