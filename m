Return-Path: <linux-kernel-owner+w=401wt.eu-S1762424AbZEGN67@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762424AbZEGN67 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 09:58:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759030AbZEGNuu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 09:50:50 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:60358 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757164AbZEGNuc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 09:50:32 -0400
Date: Thu, 7 May 2009 15:49:35 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Oberparleiter <oberpar@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, Huang Ying <ying.huang@intel.com>,
       Li Wei <W.Li@Sun.COM>, Michael Ellerman <michaele@au1.ibm.com>
Subject: Re: [PATCH 3/4] gcov: add gcov profiling infrastructure
Message-ID: <20090507134935.GA28015@elte.hu>
References: <20090507124556.041286732@linux.vnet.ibm.com> <20090507124558.618214093@linux.vnet.ibm.com> <20090507134610.GN28398@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090507134610.GN28398@elte.hu>
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


* Ingo Molnar <mingo@elte.hu> wrote:

> > +config GCOV_PROFILE_ALL
> > +	bool "Profile entire Kernel"
> > +	depends on GCOV_KERNEL
> > +	depends on S390 || X86_32
> 
> 64-bit x86 support is a must-have before we can think about 
> upstreaming any of this.

ok, the next patch does this so this hurdle is met :-)

	Ingo
