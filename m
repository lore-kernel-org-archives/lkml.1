Return-Path: <linux-kernel-owner+w=401wt.eu-S1753854AbYGAG33@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753854AbYGAG33 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 02:29:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751767AbYGAG3U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 02:29:20 -0400
Received: from E23SMTP03.au.ibm.com ([202.81.18.172]:56526 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751717AbYGAG3T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 02:29:19 -0400
Date: Tue, 1 Jul 2008 11:58:54 +0530
From: Dhaval Giani <dhaval@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Gautham R Shenoy <ego@in.ibm.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Dipankar Sarma <dipankar@in.ibm.com>, laijs@cn.fujitsu.com,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       lkml <linux-kernel@vger.kernel.org>,
       Rusty Russel <rusty@rustcorp.com.au>
Subject: Re: [PATCH] fix rcu vs hotplug race
Message-ID: <20080701062854.GD6131@linux.vnet.ibm.com>
Reply-To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
References: <20080623105844.GC28192@elte.hu> <20080623114941.GB3160@in.ibm.com> <20080624110144.GA8695@elte.hu> <20080626152728.GA24972@linux.vnet.ibm.com> <20080627044738.GC3419@in.ibm.com> <20080627051855.GD26167@in.ibm.com> <20080627054959.GB3309@linux.vnet.ibm.com> <20080627145845.GA9229@linux.vnet.ibm.com> <20080701053900.GB8205@in.ibm.com> <20080701061600.GF14658@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080701061600.GF14658@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 01, 2008 at 08:16:01AM +0200, Ingo Molnar wrote:
> 
> * Gautham R Shenoy <ego@in.ibm.com> wrote:
> 
> > So, it's the design of stop_machine() that's preventing someone from 
> > updating the cpu_online_map while force_quiescent_state() is 
> > performing the cpu_is_online() check. Becase we always call 
> > force_quiescent_state() with irqs disabled :)
> 
> Paul, do you concur? I'll apply the commit in the form below to 
> tip/core/urgent if Paul agrees.
> 
> 	Ingo

Ingo,

I believe Gautham's fix at http://lkml.org/lkml/2008/6/27/9 is better
and also explains it better.

Thanks.
-- 
regards,
Dhaval
