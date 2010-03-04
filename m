Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754882Ab0CDDzp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 22:55:45 -0500
Received: from mail-fx0-f219.google.com ([209.85.220.219]:60783 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754793Ab0CDDzj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 22:55:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=NUpk1s7027cPRGnpBvXivvaX/g7BCsWE0IYdLwaDd+1+qK9CdcaNm6MWGXHKgrxkkb
         wuPsm9xYh65VfRlaYrGtweOvzvn/Sc9yd3zZw61NRXu16dY7cEtTtkdEY0lVkuou/hpq
         j/pmQlOonHIk0BXe5tl4TgLwEJzFT1q74YYxg=
Date: Thu, 4 Mar 2010 04:55:36 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
       dipankar@in.ibm.com, akpm@linux-foundation.org,
       mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, dvhltc@us.ibm.com,
       niv@us.ibm.com, tglx@linutronix.de, peterz@infradead.org,
       rostedt@goodmis.org, Valdis.Kletnieks@vt.edu, dhowells@redhat.com,
       Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH tip/core/rcu 3/3] rcu, ftrace: fix RCU lockdep splat in
	ftrace_perf_buf_prepare()
Message-ID: <20100304035534.GA14460@nowhere>
References: <20100304015001.GA32190@linux.vnet.ibm.com> <1267667418-32233-3-git-send-email-paulmck@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1267667418-32233-3-git-send-email-paulmck@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 03, 2010 at 05:50:18PM -0800, Paul E. McKenney wrote:
> Change the pair of rcu_dereference() calls in ftrace_perf_buf_prepare()
> to rcu_dereference_sched().
> 
> Cc: Steven Rostedt <rostedt@goodmis.org>


Acked-by: Frederic Weisbecker <fweisbec@gmail.com>

