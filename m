Return-Path: <linux-kernel-owner+w=401wt.eu-S1762748AbYCGJA6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762748AbYCGJA6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 04:00:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759909AbYCGJAA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 04:00:00 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:38063 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762484AbYCGI76 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 03:59:58 -0500
Date: Fri, 7 Mar 2008 09:59:41 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
Cc: vatsa@linux.vnet.ibm.com, menage@google.com, balbir@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       akpm@linux-foundation.org, skumar@linux.vnet.ibm.com
Subject: Re: [patch 2/2] sched: allow cpuacct stats to be reset
Message-ID: <20080307085941.GB24047@elte.hu>
References: <20080229043242.110741439@linux.vnet.ibm.com> <20080229043751.555866685@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080229043751.555866685@linux.vnet.ibm.com>
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


* Dhaval Giani <dhaval@linux.vnet.ibm.com> wrote:

> Currently the schedstats implementation does not allow the statistics 
> to be reset. This patch aims to allow that.
> 
> echo 0 > cpuacct.usage
> 
> resets the usage. Any other value is not allowed and returns -EINVAL.

i've applied this for now, please send any updates that might come out 
of the interface discussions.

	Ingo
