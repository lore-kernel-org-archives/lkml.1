Return-Path: <linux-kernel-owner+w=401wt.eu-S936185AbXGSSpt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936185AbXGSSpt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 14:45:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756556AbXGSSpm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 14:45:42 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:44588 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751926AbXGSSpl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 14:45:41 -0400
Date: Thu, 19 Jul 2007 20:45:36 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Ravikiran G Thirumalai <kiran@scalex86.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       shai@scalex86.org
Subject: Re: [patch] Change softlockup trigger limit using a kernel
	parameter
Message-ID: <20070719184536.GB10940@elte.hu>
References: <20070716222650.GA5947@localdomain> <20070718160858.75865461.akpm@linux-foundation.org> <20070719054121.GA15074@localdomain> <20070718230907.741ae56c.akpm@linux-foundation.org> <20070719091142.GA28723@elte.hu> <20070719183129.GB20298@localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070719183129.GB20298@localdomain>
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


* Ravikiran G Thirumalai <kiran@scalex86.org> wrote:

> > also, i think the valid threshold should be between 1 and 60 seconds 
> > i think.
> 
> 60 seconds!  Is that not a pretty high threshold?  The reason for 
> lowering the tolerance threshold from 10s is to catch bugs early in 
> lab environments, but why do we need to raise the tolerance thresh 
> beyond 10s?

just in case someone sees false positives and wants to turn it off.

	Ingo
