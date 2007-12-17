Return-Path: <linux-kernel-owner+w=401wt.eu-S1759982AbXLQN4X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759982AbXLQN4X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 08:56:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753988AbXLQN4Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 08:56:16 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:36914 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753648AbXLQN4P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 08:56:15 -0500
Date: Mon, 17 Dec 2007 14:55:49 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jan Beulich <jbeulich@novell.com>
Cc: olaf@aepfle.de, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, mingo@redhat.com,
       linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] x86-64: also define AT_VECTOR_SIZE_ARCH
Message-ID: <20071217135549.GA9171@elte.hu>
References: <475D6C91.76E4.0078.0@novell.com> <20071217134235.GI1870@elte.hu> <47668D71.76E4.0078.0@novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47668D71.76E4.0078.0@novell.com>
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


* Jan Beulich <jbeulich@novell.com> wrote:

> >>> Ingo Molnar <mingo@elte.hu> 17.12.07 14:42 >>>
> >
> >* Jan Beulich <jbeulich@novell.com> wrote:
> >
> >> The patch introducing this left out x86-64, despite it also having 
> >> extra entries.
> >
> >thanks, applied. Is there any 2.6.24 urgency for this?
> 
> While I haven't seen x86-64 to break due to this (it appears that 
> 32-bit apps would be more susceptible), I know that we had major 
> problems with the respective piece missing from the 32-bit Xen kernels 
> in openSuSE 10.3, so I would strongly suggest putting this into .24.

ok, queued it up for the next push.

	Ingo
