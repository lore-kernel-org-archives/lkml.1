Return-Path: <linux-kernel-owner+w=401wt.eu-S1757435AbZABQ12@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757435AbZABQ12 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 11:27:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758547AbZABQ1R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 11:27:17 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:40868 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758525AbZABQ1Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 11:27:16 -0500
Date: Fri, 2 Jan 2009 17:27:04 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Cliff Wickman <cpw@sgi.com>
Cc: linux-kernel@vger.kernel.org, gregkh@suse.de, dcn@sgi.com
Subject: Re: [PATCH] UV: remove erroneous BAU initialization
Message-ID: <20090102162704.GI1180@elte.hu>
References: <E1LI6cc-00045u-4i@eag09.americas.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1LI6cc-00045u-4i@eag09.americas.sgi.com>
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


* Cliff Wickman <cpw@sgi.com> wrote:

> From: Cliff Wickman <cpw@sgi.com>
> 
> UV is the SGI "UltraViolet" machine, which is x86_64 based.
> BAU is the "Broadcast Assist Unit", used for TLB shootdown in UV.
> 
> This patch removes the allocation and initialization of an unused table.
> 
> This table is left over from a development test mode.  It is unused in
> the present code.
> And it was incorrectly initialized: 8 entries allocated but 17 initialized,
> causing slab corruption.
> 
> This patch should go into 2.6.27 and 2.6.28 as well as the current tree.
> 
> Diffed against 2.6.28 (linux-next, 12/30/08)
> 
> Signed-off-by: Cliff Wickman <cpw@sgi.com>
> ---
>  arch/x86/kernel/tlb_uv.c |    9 ---------
>  1 file changed, 9 deletions(-)

applied to tip/x86/urgent with a Cc: stable tag, thanks Cliff,

	Ingo
