Return-Path: <linux-kernel-owner+w=401wt.eu-S1758385AbXLaKnw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758385AbXLaKnw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Dec 2007 05:43:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754416AbXLaKnn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Dec 2007 05:43:43 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:43921 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753631AbXLaKnn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Dec 2007 05:43:43 -0500
Date: Mon, 31 Dec 2007 11:43:11 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: pm list <linux-pm@lists.linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Len Brown <lenb@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@suse.cz>
Subject: Re: [PATCH] Hibernation: Document __save_processor_state() on
	x86-64
Message-ID: <20071231104311.GA30003@elte.hu>
References: <200712281353.37976.rjw@sisk.pl> <200712302308.51562.rjw@sisk.pl> <20071230215745.GB31386@elte.hu> <200712302337.23896.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200712302337.23896.rjw@sisk.pl>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Rafael J. Wysocki <rjw@sisk.pl> wrote:

> > ok, just to make sure we are talking about the same thing. Do you 
> > mean we can restore an image saved by v2.6.12 into v2.6.24? I.e. a 
> > 2.6.24 kernel will be able to run a 2.6.12 kernel's hibernation 
> > image, with all the kernel internal data from v2.6.12, etc? No way 
> > can that work.
> 
> Well, not exactly.  The support for different boot and image kernels 
> has only been merged recently, but we can use the current git to 
> restore 2.6.24-rc6-mm1, for example.
> 
> The trick is to pass a little additional information in the image 
> header that can be used by the boot kernel to locate the entry point 
> to the image kernel and the image kernel's page tables.

ok - i thought you meant that there's a general capability to resume 
across kernel versions. (which would be close to impossible without some 
major surgery.)

btw., in what way is this different from kexec?

	Ingo
