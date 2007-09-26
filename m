Return-Path: <linux-kernel-owner+w=401wt.eu-S1758052AbXIZJrn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758052AbXIZJrn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 05:47:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754621AbXIZJrd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 05:47:33 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:48398 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754068AbXIZJrc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 05:47:32 -0400
Date: Wed, 26 Sep 2007 11:47:26 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Martin Michlmayr <tbm@cyrius.com>
Cc: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org
Subject: Re: Network slowdown due to CFS
Message-ID: <20070926094726.GA27006@elte.hu>
References: <20070926085202.GE3337@deprecation.cyrius.com> <20070926093445.GA24768@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070926093445.GA24768@elte.hu>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> > What kind of information can I supply so you can track this down?
> 
> as a starter, could you boot the sched-devel.git kernel, with 
> CONFIG_SCHED_DEBUG=y and CONFIG_SCHEDSTATS=y enabled and could you run 
> this script while the iperf test is in the middle of its testrun:
> 
>   http://people.redhat.com/mingo/cfs-scheduler/tools/cfs-debug-info.sh
> 
> this will gather a good deal of info about the workload in question. 
> Please send me the resulting debug file.

Another thing: please also do the same with the vanilla v2.6.22 kernel, 
and send me that file too. (so that the two cases can be compared)

	Ingo
