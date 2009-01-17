Return-Path: <linux-kernel-owner+w=401wt.eu-S1757780AbZAQIWJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757780AbZAQIWJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2009 03:22:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752265AbZAQIVz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Jan 2009 03:21:55 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:43364 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751920AbZAQIVy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2009 03:21:54 -0500
Date: Sat, 17 Jan 2009 09:21:07 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Tejun Heo <htejun@gmail.com>
Cc: roel kluin <roel.kluin@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Brian Gerst <brgerst@gmail.com>, Eric Biederman <ebiederm@xmission.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Rusty Russell <rusty@rustcorp.com.au>, travis@sgi.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, steiner@sgi.com,
       Hugh Dickins <hugh@veritas.com>
Subject: Re: [PATCH] linker script: add missing .data.percpu.page_aligned
Message-ID: <20090117082107.GA24905@elte.hu>
References: <496FE2B3.3060706@gmail.com> <496FFE45.1070802@gmail.com> <20090116131601.GA20593@elte.hu> <49708FEA.9000508@gmail.com> <20090116221651.GA32736@elte.hu> <20090116223828.GA9294@elte.hu> <49716F0E.7060605@gmail.com> <49716FBF.7080203@kernel.org> <49717AE6.9060207@kernel.org> <49717B86.30408@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49717B86.30408@gmail.com>
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

> arm, arm/mach-integrator and powerpc were missing
> .data.percpu.page_aligned in their percpu output section definitions.
> Add it.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> ---
> This and the previous patch is available in the following git branch.
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git tj-percpu
> 
> The tree is on top of the rebased tip/core/percpu (cd3adf52).
> 
> Thanks.

Pulled into tip/core/percpu, thanks Tejun!

	Ingo
