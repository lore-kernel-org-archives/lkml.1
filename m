Return-Path: <linux-kernel-owner+w=401wt.eu-S1756043AbYFBLZl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756043AbYFBLZl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 07:25:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751703AbYFBLZd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 07:25:33 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:42682 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750986AbYFBLZc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 07:25:32 -0400
Date: Mon, 2 Jun 2008 13:25:08 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: x86@kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jan Beulich <jbeulich@novell.com>,
       Xen-devel <xen-devel@lists.xensource.com>
Subject: Re: [PATCH] xen: avoid hypercalls when updating unpinned pud/pmd
Message-ID: <20080602112508.GD18586@elte.hu>
References: <48409ABB.20301@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48409ABB.20301@goop.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0075]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> When operating on an unpinned pagetable (ie, one under construction or 
> destruction), it isn't necessary to use a hypercall to update a 
> pud/pmd entry.  Jan Beulich observed that a similar optimisation 
> avoided many thousands of hypercalls while doing a kernel build.
>
> One tricky part is that early in the kernel boot there's no page 
> structure, so we can't check to see if the page is pinned.  In that 
> case, we just always use the hypercall.
>
> Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
> Cc: Jan Beulich <jbeulich@novell.com>

applied to tip/x86/xen, thanks Jeremy.

	Ingo
