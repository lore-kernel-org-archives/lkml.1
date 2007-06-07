Return-Path: <linux-kernel-owner+w=401wt.eu-S936341AbXFGUR2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936341AbXFGUR2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 16:17:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932608AbXFGUQ6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 16:16:58 -0400
Received: from ms-smtp-01.nyroc.rr.com ([24.24.2.55]:61301 "EHLO
	ms-smtp-01.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761368AbXFGUQz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 16:16:55 -0400
Subject: Re: [PATCH RT] convert RCU Preempt tasklet into softirq.
From: Steven Rostedt <rostedt@goodmis.org>
To: paulmck@linux.vnet.ibm.com
Cc: john stultz <johnstul@us.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, Oleg Nesterov <oleg@tv-sign.ru>,
       LKML <linux-kernel@vger.kernel.org>,
       Dipankar Sarma <dipankar@in.ibm.com>,
       RT <linux-rt-users@vger.kernel.org>
In-Reply-To: <1181242307.10408.17.camel@localhost.localdomain>
References: <1181180051.18444.31.camel@localhost.localdomain>
	 <20070607041411.GB1783@linux.vnet.ibm.com>
	 <1181226138.18444.54.camel@localhost.localdomain>
	 <20070607161754.GA11941@linux.vnet.ibm.com>
	 <1181240819.10408.14.camel@localhost.localdomain>
	 <1181242307.10408.17.camel@localhost.localdomain>
Content-Type: text/plain
Date: Thu, 07 Jun 2007 16:16:09 -0400
Message-Id: <1181247369.10408.20.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-06-07 at 14:51 -0400, Steven Rostedt wrote:

> There might still be an issue here. With the patch I'm getting a really
> slow response time on networking. But that be because of other patches I
> have applied.

I removed this patch and I can still get the network slowdown/hang. So
this patch is unrelated to this issue. RCU on the otherhand has not been
cleared of suspicion.

-- Steve


