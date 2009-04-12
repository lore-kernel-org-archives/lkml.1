Return-Path: <linux-kernel-owner+w=401wt.eu-S1758544AbZDLLNq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758544AbZDLLNq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Apr 2009 07:13:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752315AbZDLLNg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Apr 2009 07:13:36 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:32849 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750779AbZDLLNg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Apr 2009 07:13:36 -0400
Date: Sun, 12 Apr 2009 13:13:14 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: hpa@linux.intel.com, tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: Re: [patch] x86: add linux kernel support for YMM state
Message-ID: <20090412111314.GF25392@elte.hu>
References: <1239402084.27006.8057.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1239402084.27006.8057.camel@localhost.localdomain>
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


* Suresh Siddha <suresh.b.siddha@intel.com> wrote:

> From: Suresh Siddha <suresh.b.siddha@intel.com>
> Subject: x86: add linux kernel support for YMM state
> 
> Intel Advanced Vector Extensions (AVX) introduce 256-bit vector 
> processing capability. More about AVX at 
> http://software.intel.com/sites/avx
> 
> Add OS support for YMM state management using xsave/xrstor 
> infrastructure to support AVX.
> 
> Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>

This looks very straightforward - if a CPU announces this capability 
we save/restore that state via xsave/xrstor.

So i've applied it to x86/urgent - looks uncontroversial enough to 
still go into 2.6.30. Have you tested it on real silicon too?

	Ingo

