Return-Path: <linux-kernel-owner+w=401wt.eu-S1756477AbYKQJHc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756477AbYKQJHc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 04:07:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750941AbYKQJHN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 04:07:13 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:35726 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750783AbYKQJHK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 04:07:10 -0500
Date: Mon, 17 Nov 2008 10:06:48 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [Bug #11308] tbench regression on each kernel release from
	2.6.22 -&gt; 2.6.28
Message-ID: <20081117090648.GG28786@elte.hu>
References: <1ScKicKnTUE.A.VxH.DIHIJB@chimera> <NjF0-fuClJC.A.73B.cLHIJB@chimera>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <NjF0-fuClJC.A.73B.cLHIJB@chimera>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Rafael J. Wysocki <rjw@sisk.pl> wrote:

> This message has been generated automatically as a part of a report
> of regressions introduced between 2.6.26 and 2.6.27.
> 
> The following bug entry is on the current list of known regressions
> introduced between 2.6.26 and 2.6.27.  Please verify if it still should
> be listed and let me know (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11308
> Subject		: tbench regression on each kernel release from  2.6.22 -&gt; 2.6.28
> Submitter	: Christoph Lameter <cl@linux-foundation.org>
> Date		: 2008-08-11 18:36 (98 days old)
> References	: http://marc.info/?l=linux-kernel&m=121847986119495&w=4
> 		  http://marc.info/?l=linux-kernel&m=122125737421332&w=4

Christoph, as per the recent analysis of Mike:

 http://fixunix.com/kernel/556867-regression-benchmark-throughput-loss-a622cf6-f7160c7-pull.html

all scheduler components of this regression have been eliminated.

In fact his numbers show that scheduler speedups since 2.6.22 have 
offset and hidden most other sources of tbench regression. (i.e. the 
scheduler portion got 5% faster, hence it was able to offset a 
slowdown of 5% in other areas of the kernel that tbench triggers)

	Ingo
