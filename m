Return-Path: <linux-kernel-owner+w=401wt.eu-S1755861AbZBZPkk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755861AbZBZPkk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 10:40:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752211AbZBZPkb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 10:40:31 -0500
Received: from casper.infradead.org ([85.118.1.10]:35202 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751898AbZBZPka (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 10:40:30 -0500
Subject: Re: [PATCH] new irq tracer
From: Peter Zijlstra <peterz@infradead.org>
To: Jason Baron <jbaron@redhat.com>
Cc: Mathieu Desnoyers <compudj@krystal.dyndns.org>, mingo@elte.hu,
       Masami Hiramatsu <mhiramat@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       "Frank Ch. Eigler" <fche@redhat.com>, rostedt@goodmis.org,
       linux-kernel@vger.kernel.org, acme@ghostprotocols.net,
       fweisbec@gmail.com
In-Reply-To: <20090226151105.GA3122@redhat.com>
References: <1234995035.4799.14.camel@laptop>
	 <20090220195236.GB3104@redhat.com>
	 <20090222123543.359C.A69D9226@jp.fujitsu.com> <49A5765C.2020001@redhat.com>
	 <20090225165747.GC3123@redhat.com> <20090225173412.GA14269@Krystal>
	 <20090226151105.GA3122@redhat.com>
Content-Type: text/plain
Date: Thu, 26 Feb 2009 16:40:13 +0100
Message-Id: <1235662813.4948.278.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.25.91 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-02-26 at 10:11 -0500, Jason Baron wrote:
> 
> Using Steve's new 'DEFINE_TRACE_FMT', I can get function graph trace
> as follows using the original two tracepoints (patch below):
> 
>  3)               |                      handle_IRQ_event() {
>  3)               |                        /* (irq_handler_entry) irq=28 handler=eth0 */
>  3)               |                        e1000_intr_msi() {
>  3)   2.460 us    |                          __napi_schedule();
>  3)   9.416 us    |                        }
>  3)               |                        /* (irq_handler_exit) irq=28 handler=eth0 return=handled */
>  3) + 22.935 us   |                      }
> 
> thanks,
> 
> -Jason
> 
> 
> Signed-off-by: Jason Baron <jbaron@redhat.com>

Looks good, thanks Jason!

Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>


