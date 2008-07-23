Return-Path: <linux-kernel-owner+w=401wt.eu-S1755195AbYGWKOE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755195AbYGWKOE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2008 06:14:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752978AbYGWKNy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 06:13:54 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:49575 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752849AbYGWKNx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 06:13:53 -0400
Date: Wed, 23 Jul 2008 06:13:10 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Avi Kivity <avi@qumranet.com>
Cc: Christoph Hellwig <hch@infradead.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Jan Kiszka <jan.kiszka@siemens.com>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
       "Feng(Eric) Liu" <eric.e.liu@intel.com>
Subject: Re: [patch 4/4] KVM-trace port to tracepoints
Message-ID: <20080723101310.GA30309@infradead.org>
References: <20080717160003.359557938@polymtl.ca> <487F7800.4010502@siemens.com> <20080717172853.GB29855@Krystal> <488604F8.1040008@siemens.com> <48862B01.7070907@qumranet.com> <1216799346.7257.125.camel@twins> <4886E6FD.4090200@qumranet.com> <1216803303.7257.138.camel@twins> <20080723100314.GA2847@infradead.org> <48870329.2080401@qumranet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48870329.2080401@qumranet.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 23, 2008 at 01:08:41PM +0300, Avi Kivity wrote:
> trace_mark() is implement kvmtrace, which is propagated to userspace.   
> So while trace_mark() itself is not a userspace interface, one of its  
> users is.
>
> It's an unstable interface.  But so is dmesg; that's the nature of tracing.

Trace_mark is as stable as any other kernel interface, and
the data you pass through it is as stable as you want it to.  In most
cases like kvmtrace or my spu scheduler tracing code the trace data
is directly forwarded through a userspace interface, and that is as
stable as any freeform interface, e.g. as like printk mentioned above.

