Return-Path: <linux-kernel-owner+w=401wt.eu-S1757068AbYC0IjT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757068AbYC0IjT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 04:39:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751065AbYC0IjM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 04:39:12 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:43489 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751063AbYC0IjM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 04:39:12 -0400
Date: Thu, 27 Mar 2008 09:38:49 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Gurudas Pai <gurudas.pai@oracle.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [BUG]:2.6.25-rc7 memory leak with hugepages.
Message-ID: <20080327083849.GF15626@elte.hu>
References: <47EB4E2A.1040507@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47EB4E2A.1040507@oracle.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: 1.0
X-ELTE-SpamLevel: s
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=1.0 required=5.9 tests=BAYES_50 autolearn=no SpamAssassin version=3.2.3
	1.0 BAYES_50               BODY: Bayesian spam probability is 40 to 60%
	[score: 0.4552]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Gurudas Pai <gurudas.pai@oracle.com> wrote:

> Hi,
> 
> On 2.6.25-rc7 allocate hugepages and run a fio test with following 
> jobfile,

could you try x86.git/latest:

  http://people.redhat.com/mingo/x86.git/README

it has a fix that could fix such a leak.

	Ingo
