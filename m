Return-Path: <linux-kernel-owner+w=401wt.eu-S1759538AbYGDOsf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759538AbYGDOsf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2008 10:48:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754392AbYGDOsZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jul 2008 10:48:25 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:37233 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754292AbYGDOsX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2008 10:48:23 -0400
Date: Fri, 4 Jul 2008 16:48:10 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Richard Kennedy <richard@rsk.demon.co.uk>
Cc: lkml <linux-kernel@vger.kernel.org>,
       the arch/x86 maintainers <x86@kernel.org>
Subject: Re: [PATCH] x86: cacheline_align tss_struct
Message-ID: <20080704144810.GB23651@elte.hu>
References: <1215082049.3026.15.camel@castor.localdomain> <20080703113925.GA5594@elte.hu> <1215176176.3144.5.camel@castor.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1215176176.3144.5.camel@castor.localdomain>
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


* Richard Kennedy <richard@rsk.demon.co.uk> wrote:

> The manual padding to align on cacheline size only worked in 32 bit
> In 64 bit the structure was not aligned and contained wasted space.
>     
> use the compiler ____cachline_aligned to save space & properly align
> this structure.
>     
> x86_64_default size goes from 9136 -> 8960
> x86_64_AMD     size goes from 9136 -> 8896

applied to tip/x86/cleanups - thanks Richard!

	Ingo
