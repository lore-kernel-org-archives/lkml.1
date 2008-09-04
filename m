Return-Path: <linux-kernel-owner+w=401wt.eu-S1755146AbYIDPck@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755146AbYIDPck (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 11:32:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751516AbYIDPc2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 11:32:28 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:40025 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754258AbYIDPc1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 11:32:27 -0400
Date: Thu, 4 Sep 2008 17:32:06 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andreas Herrmann <andreas.herrmann3@amd.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Revert commit e8aa4667baf74dfd85fbaab86861465acb811085
Message-ID: <20080904153206.GB7120@elte.hu>
References: <20080904144657.GC15987@alberich.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080904144657.GC15987@alberich.amd.com>
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


* Andreas Herrmann <andreas.herrmann3@amd.com> wrote:

> This reverts commit e8aa4667baf74dfd85fbaab86861465acb811085
>  (x86: enable hpet=force for AMD SB400)
> 
> Since ATI/AMD decided not to support HPET on SB4xx it doesn't
> make sense to enable this unsupported feature.
> (I was not aware of this when submitting the quirk.)
> 
> If a system with SB4xx chipset provides an ACPI HPET table and does
> not boot, "nohpet" should be used as kernel parameter.
> 
> Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>

applied to tip/x86/urgent, thanks Andreas. I guess a system broke due to 
this commit?

	Ingo
