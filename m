Return-Path: <linux-kernel-owner+w=401wt.eu-S1754576AbZAENPs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754576AbZAENPs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 08:15:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751292AbZAENPg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 08:15:36 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:39385 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750849AbZAENPg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 08:15:36 -0500
Date: Mon, 5 Jan 2009 14:15:21 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jaswinder Singh Rajput <jaswinder@infradead.org>
Cc: Jaswinder Singh Rajput <jaswinderlinux@gmail.com>,
       x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -tip] x86: setup.c fix style problems
Message-ID: <20090105131521.GC6014@elte.hu>
References: <1231066898.27852.29.camel@jaswinder.satnam> <20090104172114.GA32425@elte.hu> <3f9a31f40901040957g5a391408u5cda93c4acb66e9d@mail.gmail.com> <20090104203433.GC1132@elte.hu> <1231131855.16019.2.camel@jaswinder.satnam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1231131855.16019.2.camel@jaswinder.satnam>
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


* Jaswinder Singh Rajput <jaswinder@infradead.org> wrote:

> On Sun, 2009-01-04 at 21:34 +0100, Ingo Molnar wrote:
> > yeah - i mentioned it to you before that there are such cases.
> > 
> 
> OK, so here is new patch excluding smp.h:

Could you please instead fix the smp.h assumption so that we dont hit this 
in the future? Then we can apply your original patch. [ Do you need the 
specific .config that hits this? Can dig it out if necessary. ]

	Ingo
