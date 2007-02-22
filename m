Return-Path: <linux-kernel-owner+w=401wt.eu-S932580AbXBVIXy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932580AbXBVIXy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 03:23:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751488AbXBVIXy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 03:23:54 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:52881 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751388AbXBVIXy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 03:23:54 -0500
Date: Thu, 22 Feb 2007 09:19:20 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Eric Dumazet <dada1@cosmosbay.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH, take 2] Speedup divides by cpu_power in scheduler
Message-ID: <20070222081920.GA16089@elte.hu>
References: <20070221211039.GA2672@beardog.cca.cpqcorp.net> <20070221191427.9b7cf4b0.akpm@linux-foundation.org> <45DD46E5.4060804@cosmosbay.com> <45DD5217.3000608@cosmosbay.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45DD5217.3000608@cosmosbay.com>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -5.3
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-5.3 required=5.9 tests=ALL_TRUSTED,BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-3.3 ALL_TRUSTED            Did not pass through any untrusted hosts
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Eric Dumazet <dada1@cosmosbay.com> wrote:

> Ingo suggested to rename cpu_power to __cpu_power to make clear it 
> should not be modified without changing its reciprocal value too.

thanks,

Acked-by: Ingo Molnar <mingo@elte.hu>

> I did not convert the divide in cpu_avg_load_per_task(), because 
> tracking nr_running changes may be not worth it ? We could use a 
> static table of 32 reciprocal values but it would add a conditional 
> branch and table lookup.

not worth it i think. Lets wait for it to show up in an oprofile? (if 
ever)

	Ingo
