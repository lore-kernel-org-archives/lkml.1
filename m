Return-Path: <linux-kernel-owner+w=401wt.eu-S1763759AbXGFPue@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763759AbXGFPue (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 11:50:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757220AbXGFPu0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 11:50:26 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:2251 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761098AbXGFPu0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 11:50:26 -0400
Subject: Re: [RFC] Thread Migration Preemption
From: Daniel Walker <dwalker@mvista.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org
In-Reply-To: <1183732495.17319.133.camel@localhost.localdomain>
References: <20070705215152.GA4865@Krystal>  <468DDD3A.6010308@yahoo.com.au>
	 <1183732495.17319.133.camel@localhost.localdomain>
Content-Type: text/plain
Date: Fri, 06 Jul 2007 08:43:39 -0700
Message-Id: <1183736619.19602.7.camel@imap.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 (2.10.2-2.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-07-06 at 10:34 -0400, Steven Rostedt wrote:

> thing is that in RT an IRQ thread might service a softirq if that
> softirq thread is of the same priority as the IRQ thread. The difference
> between an IRQ thread and a softirq thread is that the IRQ thread may
> migrate but the softirq thread may not. So to do this performance
> enhancement, we need to temporarily pin the IRQ thread to the CPU, which
> is expensive (set_cpus_allowed).  This would make it much simpler and
> light weight to implement.

Are there any other reasons?

Daniel

