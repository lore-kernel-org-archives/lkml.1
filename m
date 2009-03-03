Return-Path: <linux-kernel-owner+w=401wt.eu-S1754422AbZCCObU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754422AbZCCObU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 09:31:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752641AbZCCObM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 09:31:12 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:36141 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750915AbZCCObM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 09:31:12 -0500
Date: Tue, 3 Mar 2009 15:31:06 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Mike Galbraith <efault@gmx.de>
Cc: Tejun Heo <tj@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: x86-tip: cpufreq breakage - bisection fingers
	89c9215165ca609096e845926d9a18f1306176a4
Message-ID: <20090303143106.GA12248@elte.hu>
References: <1236085632.5958.8.camel@marge.simson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1236085632.5958.8.camel@marge.simson.net>
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


* Mike Galbraith <efault@gmx.de> wrote:

> Box is Q6600, X86_64.  I haven't poked at it other than to 
> verify the bisection result via patchlet below data.
> 
> [    1.672700] overflow in relocation type 11 val 3a000f06b588
> [    1.681051] `processor' likely not compiled with -mcmodel=kernel

btw., the .config you used, and the output of ld -v and gcc -v 
would be nice as well.

	Ingo
