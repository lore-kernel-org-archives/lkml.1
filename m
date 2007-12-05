Return-Path: <linux-kernel-owner+w=401wt.eu-S1753891AbXLEOv6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753891AbXLEOv6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 09:51:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751936AbXLEOvv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 09:51:51 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:39678 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751902AbXLEOvu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 09:51:50 -0500
Date: Wed, 5 Dec 2007 15:51:37 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: tglx@linutronix.de, hpa@zytor.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86_64: some whitespace cleanups in paging code
Message-ID: <20071205145137.GA26700@elte.hu>
References: <20071205123033.GA15394@elte.hu> <1196865612128-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1196865612128-git-send-email-joerg.roedel@amd.com>
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


* Joerg Roedel <joerg.roedel@amd.com> wrote:

> This patch does some whitespace cleanups in the paging code to fix 
> some checkpatch.pl warnings of my formerly merged cleanup patches.

thanks, applied.

btw., if there's any file you are particularly interested in cleaning up 
as a whole, you can use the --file option:

  scripts/checkpatch.pl --file include/asm-x86/pgtable_64.h

there's no hard policy on whether cleanups should be done 
pre-unification or post-unification. I've been using the following 
pretty sensible 3-step path when doing manual unifications:

- clean up the _32 and _64 file first (this is also easy to check - the 
  resulting .o or vmlinux must not differ with/without the patch)

- remove artificial differences (in a separate patch)

- do the unification (in a third patch)

the general rule, more patches are better than fewer patches. Most of 
our testing/bisetion infrastructure is per-patch/per-commit, so if some 
mistake happens (and mistakes happen all the time), the finer grained 
approach is always easier to sort out.

	Ingo
