Return-Path: <linux-kernel-owner+w=401wt.eu-S1756669AbZBKMdR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756669AbZBKMdR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 07:33:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755051AbZBKMdA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 07:33:00 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:46791 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754781AbZBKMc7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 07:32:59 -0500
Date: Wed, 11 Feb 2009 13:32:49 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Dean Nelson <dcn@sgi.com>
Cc: Tony Luck <tony.luck@intel.com>, Andrew Morton <akpm@linux-foundation.org>,
       linux-ia64 <linux-ia64@vger.kernel.org>,
       linux-next <linux-next@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] SGI IA64 UV: fix ia64 build error in the linux-next
	tree
Message-ID: <20090211123249.GE16535@elte.hu>
References: <20090209162520.GA4882@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090209162520.GA4882@sgi.com>
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


* Dean Nelson <dcn@sgi.com> wrote:

> Fix the ia64 build error that occurs in the linux-next tree by introducing
> an ia64 version of uv.h.  Additionally, clean up the usage of is_uv_system().
> 
> Signed-off-by: Dean Nelson <dcn@sgi.com>
> Signed-off-by: Jack Steiner <steiner@sgi.com>

Applied, thanks Dean!

Tony, since this breakage is an accidental side-effect of the x86 tree (that
has to be fixed there), mind if we carry it there?

	Ingo
