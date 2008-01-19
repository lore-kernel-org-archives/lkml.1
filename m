Return-Path: <linux-kernel-owner+w=401wt.eu-S1754411AbYASSxn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754411AbYASSxn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jan 2008 13:53:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753248AbYASSxd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jan 2008 13:53:33 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:56198 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753776AbYASSx2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jan 2008 13:53:28 -0500
Date: Sat, 19 Jan 2008 19:53:14 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <ak@suse.de>
Cc: tglx@linutronix.de, linux-kernel@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] [7/8] CPA: Implement GBpages support in
	change_page_attr()
Message-ID: <20080119185314.GB3751@elte.hu>
References: <20080119748.170864000@suse.de> <20080119064835.A68D614EAD@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080119064835.A68D614EAD@wotan.suse.de>
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


* Andi Kleen <ak@suse.de> wrote:

>  arch/x86/mm/pageattr_64.c | 150 
>  ++++++++++++++++++++++++++++++++++++----------
>  1 file changed, 119 insertions(+), 31 deletions(-)

please unify the files first, we dont want to let pageattr_32.c and 
pageattr_64.c diverge even more. Once we get these files unified we 
layer more features ontop of it. While gbpages is not available on 
32-bit and probably wont ever be, this code has been historically very 
fragile, so having a single codebase to look at is very important.

	Ingo
