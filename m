Return-Path: <linux-kernel-owner+w=401wt.eu-S1758122AbZBRWCz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758122AbZBRWCz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 17:02:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752230AbZBRWCq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 17:02:46 -0500
Received: from mx2.redhat.com ([66.187.237.31]:50101 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751697AbZBRWCq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 17:02:46 -0500
Date: Wed, 18 Feb 2009 17:02:01 -0500
From: "Frank Ch. Eigler" <fche@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Jason Baron <jbaron@redhat.com>, mingo@elte.hu, rostedt@goodmis.org,
       linux-kernel@vger.kernel.org, acme@ghostprotocols.net,
       fweisbec@gmail.com, compudj@krystal.dyndns.org
Subject: Re: [PATCH] new irq tracer
Message-ID: <20090218220201.GG24507@redhat.com>
References: <20090218195328.GA3112@redhat.com> <1234991725.4799.1.camel@laptop> <20090218213545.GB3112@redhat.com> <1234993580.4799.11.camel@laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1234993580.4799.11.camel@laptop>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi -

On Wed, Feb 18, 2009 at 10:46:20PM +0100, Peter Zijlstra wrote:
> [...]
> How useful is that return value?

"somewhat"?

> Much of the other data is already available, /proc/interrupts will
> happily tell you the source of your interrupt storm. The irq-off
> latency tracer will tell you if stuff takes too much time, the graph
> tracer can tell you what is taking how much time.

Doesn't it seem like this is too much work to have answer a simple if
particular question?

> I really am having a difficult time seeing the use in such narrow
> tracers.

Part of the problem may come from defining "tracers" as something
limited to ftrace engines.  Once such tracepoints are in the kernel,
more powerful analytical tools may be attached to them.


- FChE
