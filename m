Return-Path: <linux-kernel-owner+w=401wt.eu-S1758894AbYDDIeR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758894AbYDDIeR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2008 04:34:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756377AbYDDIeG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Apr 2008 04:34:06 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:35587 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755215AbYDDIeF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2008 04:34:05 -0400
Date: Fri, 4 Apr 2008 10:33:50 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Hugh Dickins <hugh@veritas.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: MPSC should use P6 NOPs
Message-ID: <20080404083350.GE31320@elte.hu>
References: <Pine.LNX.4.64.0804032344260.28157@blonde.site>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0804032344260.28157@blonde.site>
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


* Hugh Dickins <hugh@veritas.com> wrote:

> I've now noticed that the machine I call MPENTIUM4 for 32-bit kernels 
> is called MPSC for 64-bit kernels, and in that case it still doesn't 
> get the P6 NOPs it ought to.  hpa explains that MK8 should still be 
> excluded, so it's just a matter of including MPSC along with 
> MPENTIUM4.

>  config X86_P6_NOP
>  	def_bool y
> -	depends on (X86_64 || !X86_GENERIC) && (M686 || MPENTIUMII || MPENTIUMIII || MPENTIUMM || MCORE2 || MPENTIUM4)
> +	depends on (X86_64 || !X86_GENERIC) && (M686 || MPENTIUMII || MPENTIUMIII || MPENTIUMM || MCORE2 || MPENTIUM4 || MPSC)

thanks Hugh, applied.

	Ingo
