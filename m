Return-Path: <linux-kernel-owner+w=401wt.eu-S1764831AbXGSJL4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764831AbXGSJL4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 05:11:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754319AbXGSJLr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 05:11:47 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:44348 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752515AbXGSJLq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 05:11:46 -0400
Date: Thu, 19 Jul 2007 11:11:42 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ravikiran G Thirumalai <kiran@scalex86.org>, linux-kernel@vger.kernel.org,
       shai@scalex86.org
Subject: Re: [patch] Change softlockup trigger limit using a kernel
	parameter
Message-ID: <20070719091142.GA28723@elte.hu>
References: <20070716222650.GA5947@localdomain> <20070718160858.75865461.akpm@linux-foundation.org> <20070719054121.GA15074@localdomain> <20070718230907.741ae56c.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070718230907.741ae56c.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Andrew Morton <akpm@linux-foundation.org> wrote:

> > +softlockup_thresh:
> > +
> > +This value can be used to lower the softlockup tolerance
> > +threshold. The default threshold is 10s.  If a cpu is locked up
> > +for 10s, the kernel complains.  Valid values are 1-10s.
> > +
> 
> neato.

please make sure this is applied after the softlockup watchdog patches i 
already did. (in particular the cleanup patch, which this could interact 
with)

also, i think the valid threshold should be between 1 and 60 seconds i 
think.

	Ingo
