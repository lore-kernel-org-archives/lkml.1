Return-Path: <linux-kernel-owner+w=401wt.eu-S1754162AbYHVE3B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754162AbYHVE3B (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2008 00:29:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751810AbYHVE2x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Aug 2008 00:28:53 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:47598 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751519AbYHVE2w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2008 00:28:52 -0400
Date: Fri, 22 Aug 2008 06:28:31 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Alex Nixon <alex.nixon@citrix.com>
Subject: Re: [PATCH] x86: fix probe_nr_irqs for xen
Message-ID: <20080822042831.GB15212@elte.hu>
References: <1219349409-15698-1-git-send-email-yhlu.kernel@gmail.com> <48ADFB33.8010204@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48ADFB33.8010204@goop.org>
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


* Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> Yinghai Lu wrote:
> > otherwise Xen is _completely_ unusable with 5 or more VCPUs.
> > ( when !CONFIG_HAVE_SPARSE_IRQ)
> >
> > based on Alex's patch
> >
> > also add +1 offset after redir_entries
> >
> > Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
> > Cc: Alex Nixon <alex.nixon@citrix.com>
> >   
> 
> Looks good to me.  We can fix this in a better way later.
> 
> Acked-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

applied to tip/irq/sparseirq. 

Alex, does this approach work for you too?

	Ingo
