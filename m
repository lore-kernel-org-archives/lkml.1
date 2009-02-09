Return-Path: <linux-kernel-owner+w=401wt.eu-S1754717AbZBIJ3l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754717AbZBIJ3l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 04:29:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754410AbZBIJ3Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 04:29:24 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:59906 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754396AbZBIJ3X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 04:29:23 -0500
Date: Mon, 9 Feb 2009 10:29:18 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Brian Gerst <brgerst@gmail.com>
Cc: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] percpu: Make PER_CPU_BASE_SECTION overridable by
	arches
Message-ID: <20090209092918.GA7930@elte.hu>
References: <1234105120-19731-1-git-send-email-brgerst@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1234105120-19731-1-git-send-email-brgerst@gmail.com>
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


* Brian Gerst <brgerst@gmail.com> wrote:

> Impact: bug fix
> 
> IA-64 needs to put percpu data in the seperate section even on UP.
> Fixes regression caused by "percpu: refactor percpu.h"
> 
> Signed-off-by: Brian Gerst <brgerst@gmail.com>
> Acked-by: Tony Luck <tony.luck@intel.com>
> ---
>  arch/ia64/include/asm/percpu.h |    4 ++--
>  include/linux/percpu.h         |    8 +++++++-
>  2 files changed, 9 insertions(+), 3 deletions(-)

Applied to tip/core/percpu, thanks!

	Ingo
