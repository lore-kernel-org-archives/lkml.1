Return-Path: <linux-kernel-owner+w=401wt.eu-S1754854AbYB0PET@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754854AbYB0PET (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 10:04:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750708AbYB0PEL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 10:04:11 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:58916 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750785AbYB0PEK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 10:04:10 -0500
Date: Wed, 27 Feb 2008 16:03:50 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Sudhir Kumar <skumar@linux.vnet.ibm.com>,
       Balbir Singh <balbir@in.ibm.com>,
       Aneesh Kumar KV <aneesh.kumar@linux.vnet.ibm.com>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] sched: don't allow rt_runtime_us to be zero for groups
	having rt tasks
Message-ID: <20080227150350.GB21610@elte.hu>
References: <20080227110829.GA15731@linux.vnet.ibm.com> <1204116417.6242.383.camel@lappy> <20080227132459.GE15731@linux.vnet.ibm.com> <1204121510.6242.406.camel@lappy>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1204121510.6242.406.camel@lappy>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> 
> On Wed, 2008-02-27 at 18:54 +0530, Dhaval Giani wrote:
> 
> > This patch checks if we can set the rt_runtime_us to 0. If there is a
> > realtime task in the group, we don't want to set the rt_runtime_us as 0
> > or bad things will happen.
> > 
> > Signed-off-by: Dhaval Giani <dhaval@linux.vnet.ibm.com>
> 
> Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>

doesnt apply to sched-devel.git - what's the plan here?

	Ingo
