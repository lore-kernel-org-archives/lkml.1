Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756737Ab0BBSdb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 13:33:31 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:50145 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756475Ab0BBSd1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 13:33:27 -0500
Subject: Re: [RFC][PATCH] perf_events, x86: PEBS support
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>, Stephane Eranian <eranian@google.com>,
       "Metzger, Markus T" <markus.t.metzger@intel.com>,
       lkml <linux-kernel@vger.kernel.org>,
       Robert Richter <robert.richter@amd.com>,
       "David S. Miller" <davem@davemloft.net>,
       Jamie Iles <jamie.iles@picochip.com>, Paul Mundt <lethal@linux-sh.org>,
       Arjan van de Ven <arjan@infradead.org>,
       "H. Peter Anvin" <hpa@zytor.com>
In-Reply-To: <20100202182653.GB19320@elte.hu>
References: <1265129772.24455.329.camel@laptop>
	 <20100202182653.GB19320@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 02 Feb 2010 19:33:08 +0100
Message-ID: <1265135588.24455.350.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-02-02 at 19:26 +0100, Ingo Molnar wrote:
> * Peter Zijlstra <peterz@infradead.org> wrote:

> > @@ -203,8 +203,9 @@ struct perf_event_attr {
> >  				enable_on_exec :  1, /* next exec enables     */
> >  				task           :  1, /* trace fork/exit       */
> >  				watermark      :  1, /* wakeup_watermark      */
> > +				precise        :  1,
> 
> I think we want to default to precise events even if not specifically 
> requested by user-space, in the cases where that's possible on the CPU 
> without additional limitations.
> 
> That way people will default to better (and possibly cheaper) PEBS profiling 
> on modern Intel CPUs.

Sure, I'll look at that once it starts working :-)

