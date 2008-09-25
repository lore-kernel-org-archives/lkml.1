Return-Path: <linux-kernel-owner+w=401wt.eu-S1753825AbYIYH1k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753825AbYIYH1k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 03:27:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752293AbYIYH1b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 03:27:31 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:45100 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752047AbYIYH1b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 03:27:31 -0400
Date: Thu, 25 Sep 2008 09:26:07 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, cl@linux-foundation.org,
       akpm@linux-foundation.org, manfred@colorfullife.com,
       dipankar@in.ibm.com, josht@linux.vnet.ibm.com, schamp@sgi.com,
       niv@us.ibm.com, dvhltc@us.ibm.com, ego@in.ibm.com, laijs@cn.fujitsu.com,
       rostedt@goodmis.org, peterz@infradead.org, penberg@cs.helsinki.fi,
       andi@firstfloor.org, tglx@linutronix.com
Subject: Re: [PATCH, RFC] v6 scalable classic RCU implementation
Message-ID: <20080925072607.GA20249@elte.hu>
References: <20080821234318.GA1754@linux.vnet.ibm.com> <20080825000738.GA24339@linux.vnet.ibm.com> <20080830004935.GA28548@linux.vnet.ibm.com> <20080905152930.GA8124@linux.vnet.ibm.com> <20080915160221.GA9660@linux.vnet.ibm.com> <20080923235340.GA12166@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080923235340.GA12166@linux.vnet.ibm.com>
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


* Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:

> +config RCU_CPU_STALL_DETECTOR
> +	bool "Check for stalled CPUs delaying RCU grace periods"
> +	depends on CLASSIC_RCU || TREE_RCU
> +	default n
> +	help
> +	  This option causes RCU to printk information on which
> +	  CPUs are delaying the current grace period, but only when
> +	  the grace period extends for excessive time periods.
> +
> +	  Say Y if you want RCU to perform such checks.
> +
> +	  Say N if you are unsure.

could you please send this bit separately, even if rcutree isnt finished 
yet? Seems like a quite useful debug feature.

	Ingo
