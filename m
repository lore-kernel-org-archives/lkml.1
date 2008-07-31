Return-Path: <linux-kernel-owner+w=401wt.eu-S1759161AbYGaV5a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759161AbYGaV5a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 17:57:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755964AbYGaV5W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 17:57:22 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:44673 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754732AbYGaV5V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 17:57:21 -0400
Date: Thu, 31 Jul 2008 23:57:12 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Krzysztof Helt <krzysztof.h1@wp.pl>
Cc: hpa@zytor.com, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] x86: fdiv bug detection fix
Message-ID: <20080731215712.GC23801@elte.hu>
References: <20080731234344.eb3c4ed2.krzysztof.h1@wp.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080731234344.eb3c4ed2.krzysztof.h1@wp.pl>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0010]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Krzysztof Helt <krzysztof.h1@wp.pl> wrote:

> From: Krzysztof Helt <krzysztof.h1@wp.pl>
> 
> The fdiv detection code writes s32 integer into
> the boot_cpu_data.fdiv_bug. 
> However, the boot_cpu_data.fdiv_bug is only char (s8)
> field so the detection overwrites already set fields for
> other bugs, e.g. the f00f bug field.
> 
> Use local s32 variable to receive result.

applied to tip/x86/urgent, thanks Krzysztof!

this bug seems to be rather old - i guess new kernels rarely get tested 
with those CPUs that are affected by those bugs?

	Ingo
