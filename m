Return-Path: <linux-kernel-owner+w=401wt.eu-S1760175AbXFGH1p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760175AbXFGH1p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 03:27:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754484AbXFGH1f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 03:27:35 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:53566 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754298AbXFGH1e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 03:27:34 -0400
X-Greylist: delayed 29802 seconds by postgrey-1.27 at vger.kernel.org; Thu, 07 Jun 2007 03:27:33 EDT
Date: Thu, 7 Jun 2007 09:27:20 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Martin Peschke <mp3@de.ibm.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
       jbaron@redhat.com, rostedt@goodmis.org, linux-s390@vger.kernel.org
Subject: Re: [RFC] [Patch 4/4] lock contention tracking slimmed down
Message-ID: <20070607072720.GA19976@elte.hu>
References: <1181165656.7133.23.camel@dix> <20070606230641.GA11592@elte.hu> <46674EA9.9090601@de.ibm.com> <1181198376.7348.202.camel@twins> <4667ACC3.60009@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4667ACC3.60009@de.ibm.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Martin Peschke <mp3@de.ibm.com> wrote:

> Admittedly this gives you the top five contention points, [...]

if the infrastructure your are advocating does not allow us to keep the 
existing output then it's simply not flexible enough. Why on earth are 
you even arguing about this? A "cleanup" should not change the output, 
simple as that. Do a patch that has the _same_ output and then we can 
see whether it's a good patch. You made the same mistake with your 
/proc/timer_stats cleanups. I dont like NACK-ing patches but you seem to 
be missing the basic precondition of cleanups: no functional effect to 
the code, and certainly no change in output.

	Ingo
