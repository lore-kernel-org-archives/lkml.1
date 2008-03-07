Return-Path: <linux-kernel-owner+w=401wt.eu-S1758690AbYCGOPP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758690AbYCGOPP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 09:15:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751803AbYCGOPA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 09:15:00 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:41433 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751065AbYCGOO7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 09:14:59 -0500
Date: Fri, 7 Mar 2008 15:14:40 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Bob Tracy <rct@frus.com>
Cc: linux-kernel@vger.kernel.org, linux-alpha@vger.kernel.org,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [regression]2.6.25-rc4: boot panic on alpha
Message-ID: <20080307141439.GB23178@elte.hu>
References: <20080307072304.GA25351@elte.hu> <20080307123645.0CB5BDBA2@gherkin.frus.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080307123645.0CB5BDBA2@gherkin.frus.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0003]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Bob Tracy <rct@frus.com> wrote:

> Ingo Molnar wrote:
> > Bob, does latest -git boot if you revert these 4 commits:
> 
> (FUJITA Tomonori's Alpha IOMMU changes)
> 
> I'll get things set up to try that later today...  In the meantime, it 
> appears the regression is relative to -rc3: I'm up and running on that 
> kernel as I type this.

yes, these iommu changes were added post-rc3, they came from -mm and 
were i think declared to be untested on Alpha. So i'd strongly suspect 
them.

	Ingo
