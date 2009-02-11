Return-Path: <linux-kernel-owner+w=401wt.eu-S1756713AbZBKO7B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756713AbZBKO7B (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 09:59:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754700AbZBKO6x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 09:58:53 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:34326 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752546AbZBKO6w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 09:58:52 -0500
Date: Wed, 11 Feb 2009 15:58:48 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Tejun Heo <htejun@gmail.com>
Cc: Brian Gerst <brgerst@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] x86: Pass in pt_regs pointer for syscalls that
	need it
Message-ID: <20090211145848.GC10525@elte.hu>
References: <1234277507-4987-1-git-send-email-brgerst@gmail.com> <1234277507-4987-3-git-send-email-brgerst@gmail.com> <4992812B.1050800@kernel.org> <73c1f2160902110631j68e58202h3e49288cfe613d66@mail.gmail.com> <4992E396.6000205@kernel.org> <4992E551.4060901@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4992E551.4060901@gmail.com>
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


* Tejun Heo <htejun@gmail.com> wrote:

> Tejun Heo wrote:
> >> I checked the disassembly of these functions and didn't see this
> >> happen on gcc 4.3.0.
> > 
> > Well, tracking down why run_init_process() is returning 0 with
> > -fstack-protector wasn't much of fun.  These breakages are very subtle
> > and if we're gonna pass in pointer to pt_regs anyway and thus can
> > guarantee such breakage can't happen at no additional cost, I think we
> > should do that even if it means slightly more argument fetching in a
> > few places.
> 
> In addition, if we do that, we can remove the horrible
> asmlinkage_protect() thing altogether.

Agreed.

	Ingo
