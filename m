Return-Path: <linux-kernel-owner+w=401wt.eu-S1756081AbZAKEGX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756081AbZAKEGX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2009 23:06:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752749AbZAKEGM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Jan 2009 23:06:12 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:57191 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752295AbZAKEGK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2009 23:06:10 -0500
Date: Sun, 11 Jan 2009 05:05:57 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Benjamin LaHaise <bcrl@kvack.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Alexander van Heukelum <heukelum@mailshack.com>
Subject: Re: [PATCH] x86-64: remove locked instruction from switch_to()
Message-ID: <20090111040557.GG28520@elte.hu>
References: <20090110212625.GE13467@kvack.org> <20090110223616.GB16719@elte.hu> <20090111040022.GG13467@kvack.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090111040022.GG13467@kvack.org>
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


* Benjamin LaHaise <bcrl@kvack.org> wrote:

> Here is a rediffed and test booted version of the patch against linus' git 
> tree as of a couple of hours ago.
> 
> The patch below removes an unnecessary locked instruction from 
> switch_to().  TIF_FORK is only ever set in copy_thread() on initial 
> process creation, and gets cleared during the first scheduling of the 
> process.  As such, it is safe to use an unlocked test for the flag 
> within switch_to()./
> 
> Signed-off-by: Benjamin LaHaise <bcrl@kvack.org>

applied to tip/x86/asm, thanks Ben!

	Ingo
