Return-Path: <linux-kernel-owner+w=401wt.eu-S1756880AbYFSMES@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756880AbYFSMES (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2008 08:04:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754621AbYFSMEG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jun 2008 08:04:06 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:40230 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754701AbYFSMEF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2008 08:04:05 -0400
Date: Thu, 19 Jun 2008 14:03:30 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, benh@kernel.crashing.org,
       xen-devel <xen-devel@lists.xensource.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       kvm-devel <kvm-devel@lists.sourceforge.net>, x86@kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       Hugh Dickins <hugh@veritas.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 1 of 4] mm: add a ptep_modify_prot transaction
	abstraction
Message-ID: <20080619120330.GA3172@elte.hu>
References: <b020e42384197b824320.1213615800@localhost> <1213831403.8011.24.camel@pasglop> <4859A149.9090004@goop.org> <4859A528.1010107@goop.org> <alpine.LFD.1.10.0806181723400.2907@woody.linux-foundation.org> <4859AA47.2020903@goop.org> <alpine.LFD.1.10.0806181743390.2907@woody.linux-foundation.org> <alpine.LFD.1.10.0806182050470.2907@woody.linux-foundation.org> <20080619115832.GM15228@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080619115832.GM15228@elte.hu>
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

> config and crashlog can be found at:
> 
>   http://redhat.com/~mingo/misc/config-Thu_Jun_19_13_45_21_CEST_2008.bad
>   http://redhat.com/~mingo/misc/crash-Thu_Jun_19_13_45_21_CEST_2008.log

just in case it helps, and for completeness, a 64-bit box blew up too:

  http://redhat.com/~mingo/misc/config-Thu_Jun_19_13_48_55_CEST_2008.bad

and another 32-bit box:

  http://redhat.com/~mingo/misc/config-Thu_Jun_19_13_48_32_CEST_2008.bad

	Ingo
