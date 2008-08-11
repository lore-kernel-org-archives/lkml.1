Return-Path: <linux-kernel-owner+w=401wt.eu-S1756443AbYHKTbx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756443AbYHKTbx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 15:31:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752989AbYHKTbn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 15:31:43 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:53451 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752035AbYHKTbm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 15:31:42 -0400
Date: Mon, 11 Aug 2008 21:31:29 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andreas Herrmann <andreas.herrmann3@amd.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org
Subject: Re: x86:  compile pat debugfs interface only if CONFIG_X86_PAT is
	set
Message-ID: <20080811193129.GH12788@elte.hu>
References: <20080806133016.GH5427@alberich.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080806133016.GH5427@alberich.amd.com>
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


* Andreas Herrmann <andreas.herrmann3@amd.com> wrote:

> 
> Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
> ---
>  arch/x86/mm/pat.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> Recently I've run a kernel w/o PAT support and wondered why there was
> a file "x86/pat_memtype_list" in debugfs. Of course it's empty if PAT
> is disabled ... so just get rid of this interface if PAT is disabled.

applied to tip/x86/pat - thanks Andreas.

	Ingo
