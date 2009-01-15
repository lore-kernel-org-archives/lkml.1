Return-Path: <linux-kernel-owner+w=401wt.eu-S933639AbZAOU6G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933639AbZAOU6G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 15:58:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932567AbZAOUJa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 15:09:30 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:43844 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932533AbZAOUJ3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 15:09:29 -0500
Date: Thu, 15 Jan 2009 21:09:10 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jayson King <dev@jaysonking.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Lin Ming <ming.m.lin@intel.com>,
       Mike Galbraith <efault@gmx.de>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: Performance regression of specjbb2005/aim7 with 2.6.29-rc1
Message-ID: <20090115200910.GA12246@elte.hu>
References: <1231837036.11429.27.camel@ymzhang> <1231839464.14655.12.camel@marge.simson.net> <1231986636.10565.159.camel@minggr.sh.intel.com> <1232036235.8870.75.camel@laptop> <496F8631.3070902@jaysonking.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <496F8631.3070902@jaysonking.com>
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


* Jayson King <dev@jaysonking.com> wrote:

>> -		struct load_weight *load = &cfs_rq->load;
>> +		struct load_weight *load;
>> +
>> +		cfs_rq = cfs_rq_of(se);
>> +		load = &cfs_rq->load;
>>   		if (unlikely(!se->on_rq)) {
>>  			struct load_weight lw = cfs_rq->load;
>>
>>
>>
>
>
> That still works for me. You may add:
>
> Tested-by: Jayson King <dev@jaysonking.com>

I have added it to the commit - thanks Jayson for the testing,

	Ingo
