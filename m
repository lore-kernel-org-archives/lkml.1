Return-Path: <linux-kernel-owner+w=401wt.eu-S1753615AbYAYA0R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753615AbYAYA0R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 19:26:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751346AbYAYA0E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 19:26:04 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:56697 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750714AbYAYA0D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 19:26:03 -0500
Date: Fri, 25 Jan 2008 01:25:43 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Mike Travis <travis@sgi.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       Christoph Lameter <clameter@sgi.com>, jeremy@goop.org,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] percpu: Optimize percpu accesses
Message-ID: <20080125002543.GA931@elte.hu>
References: <20080123044924.508382000@sgi.com> <20080124224613.GA24855@elte.hu> <47992AA8.6040804@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47992AA8.6040804@sgi.com>
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


* Mike Travis <travis@sgi.com> wrote:

> > tried it on x86.git and 1/3 did not build and 2/3 causes a boot hang 
> > with the attached .config.
> 
> The build error was fixed with the note I sent to you yesterday with a 
> "fixup" patch for changes in -mm but not in x86.git (attached).

no, that build error was in patch #2, and your later patch made it 
possible for me to bisect down to that point. #1 failed differently. 
(and not in module.c - dont remember the details - let me know if you 
cannot reproduce - the hang in #2 was the more significant bug.) The 
hang gave no messages on the earlyprintk serial console.

	Ingo
