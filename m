Return-Path: <linux-kernel-owner+w=401wt.eu-S1759474AbZCSHXY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759474AbZCSHXY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 03:23:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753303AbZCSHXP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 03:23:15 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:44969 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752374AbZCSHXO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 03:23:14 -0400
Date: Thu, 19 Mar 2009 08:22:56 +0100
From: Ingo Molnar <mingo@elte.hu>
To: monstr@monstr.eu
Cc: linux-kernel@vger.kernel.org, john.williams@petalogix.com,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Microblaze linux support
Message-ID: <20090319072256.GA5069@elte.hu>
References: <1237408284-8674-1-git-send-email-monstr@monstr.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1237408284-8674-1-git-send-email-monstr@monstr.eu>
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


* monstr@monstr.eu <monstr@monstr.eu> wrote:

> Hi all,
> 
> I think that is the right time to send you next pack with 
> Microblaze support. It is seventh pack - some previous packs
> was review by community and I hope there are not any big faults.

I have not done a deep review, but there's a lot of avoidable easy 
style bugs in the patches. All the patches together, passed through 
scripts/checkpatch.pl give ~200 errors:

  total: 40 errors, 146 warnings, 15737 lines checked

A quick look suggests that most of the warnings pinpoint real 
problems. (and you can ignore false positives)

Thanks,

	Ingo
