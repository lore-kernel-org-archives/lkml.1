Return-Path: <linux-kernel-owner+w=401wt.eu-S1754521AbZBIJbY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754521AbZBIJbY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 04:31:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752514AbZBIJbP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 04:31:15 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:54086 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752461AbZBIJbO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 04:31:14 -0500
Date: Mon, 9 Feb 2009 10:31:00 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Brian Gerst <brgerst@gmail.com>
Cc: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 3/3] x86: Fix abuse of per_cpu_offset
Message-ID: <20090209093100.GC7930@elte.hu>
References: <1234105120-19731-1-git-send-email-brgerst@gmail.com> <1234105120-19731-3-git-send-email-brgerst@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1234105120-19731-3-git-send-email-brgerst@gmail.com>
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

> Impact: bug fix
> 
> Don't use per_cpu_offset() to determine if it valid to access a
> per-cpu variable for a given cpu number.  It is not a valid assumption
> on x86-64 anymore.  Use cpu_possible() instead.
> 
> Signed-off-by: Brian Gerst <brgerst@gmail.com>
> ---
>  arch/x86/mm/numa_64.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)

Applied to tip/core/perpcu, thanks Brian!

	Ingo
