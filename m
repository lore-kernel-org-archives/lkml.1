Return-Path: <linux-kernel-owner+w=401wt.eu-S932192AbXCEKPV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932192AbXCEKPV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 05:15:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752769AbXCEKPM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 05:15:12 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:45604 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932192AbXCEKPK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 05:15:10 -0500
Date: Mon, 5 Mar 2007 11:07:02 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andres Salomon <dilinger@debian.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] highres: warn on softirq handling an unsafe callback
Message-ID: <20070305100702.GB9175@elte.hu>
References: <45EBEA9F.9070109@debian.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45EBEA9F.9070109@debian.org>
User-Agent: Mutt/1.4.2.2i
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


* Andres Salomon <dilinger@debian.org> wrote:

> run_hrtimer_queue is called from a softirq context, and should never 
> run a callback that is classified as HRTIMER_CB_IRQSAFE_NO_SOFTIRQ.  A 
> bug in unrelated code had managed to trigger that bug, so let's add an 
> explicit warning to this function.
> 
> Signed-off-by: Andres Salomon <dilinger@debian.org>

thanks.

Acked-by: Ingo Molnar <mingo@elte.hu>

[suggestion for future submissions: please include the patch body as 
text, not as a MIME attachment - this makes it easier for upstream 
maintainers to process such mails.]

	Ingo
