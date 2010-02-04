Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758297Ab0BDO7S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 09:59:18 -0500
Received: from casper.infradead.org ([85.118.1.10]:57036 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758219Ab0BDO7R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 09:59:17 -0500
Subject: Re: [PATCH]  perf_events: AMD event scheduling (v2)
From: Peter Zijlstra <peterz@infradead.org>
To: eranian@google.com
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, paulus@samba.org,
       davem@davemloft.net, fweisbec@gmail.com, robert.richter@amd.com,
       perfmon2-devel@lists.sf.net, eranian@gmail.com
In-Reply-To: <1265295302.24455.2265.camel@laptop>
References: <4b674594.0a04d00a.6005.2567@mx.google.com>
	 <1265295302.24455.2265.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 04 Feb 2010 15:59:05 +0100
Message-ID: <1265295545.24455.2270.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-02-04 at 15:55 +0100, Peter Zijlstra wrote:
> > +     if (boot_cpu_data.x86_max_cores < 2)
> > +             return;
> 
> So there are no single core AMD chips that have a NorthBridge PMU? What
> about the recent 64bit single core laptop chips?

D'0h, for those there is no need to create inter-cpu constraints.

