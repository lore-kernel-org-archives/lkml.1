Return-Path: <linux-kernel-owner+w=401wt.eu-S1759536AbZBDVNK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759536AbZBDVNK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 16:13:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752353AbZBDVM4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 16:12:56 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:37343 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752351AbZBDVMz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 16:12:55 -0500
Date: Wed, 4 Feb 2009 22:12:43 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Kyle McMartin <kyle@infradead.org>
Cc: mingo@redhat.com, arjan@linux.intel.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86_64: print DMI info in the oops trace
Message-ID: <20090204211243.GJ22608@elte.hu>
References: <20090204205445.GA17963@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090204205445.GA17963@bombadil.infradead.org>
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


* Kyle McMartin <kyle@infradead.org> wrote:

> From: Kyle McMartin <kyle@redhat.com>
> 
> This patch echoes what we already do on 32-bit since
> 90f7d25c6b672137344f447a30a9159945ffea72, and prints the DMI
> product name in show_regs, so that system specific problems can be
> easily identified.
> 
> Signed-off-by: Kyle McMartin <kyle@redhat.com>

Applied to tip/x86/urgent, thanks Kyle!

> Noticed we weren't doing this on x86_64 while backporting this change to 
> 2.6.27 for Fedora... Any reason for it?

No reason, simple oversight. Also, a good 75% of the x86 testers are still 
on 32-bit and covering the main volume is what such changes tend to aim for 
primarily. The remaining 25% is nice to have too :)

If you notice such things - or if you have anything in the Fedora srpm that 
you think is worth mainlining, just drop us a patch - it's apprecitated.

	Ingo
