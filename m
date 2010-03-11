Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752884Ab0CKVHk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 16:07:40 -0500
Received: from casper.infradead.org ([85.118.1.10]:58251 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752493Ab0CKVHj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 16:07:39 -0500
Subject: Re: [PATCH] perf_events: remove bogus Intel Core constraint on
 ITLB_MISS_RETIRED
From: Peter Zijlstra <peterz@infradead.org>
To: eranian@google.com
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, paulus@samba.org,
       fweisbec@gmail.com, robert.richter@amd.com, davem@davemloft.net,
       perfmon2-devel@lists.sf.net
In-Reply-To: <1268341168-19705-1-git-send-email-eranian@google.com>
References: <1268341168-19705-1-git-send-email-eranian@google.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 11 Mar 2010 22:07:35 +0100
Message-ID: <1268341655.5037.138.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-03-11 at 12:59 -0800, eranian@google.com wrote:
> Contrary to what Vol3b section 30.4.3 leads to believe, there is
> no constraint on ITLB_MISS_RETIRED on Intel Core-based CPU, so
> remove it.

Is that from Intel, and will they clarify the text in the next version
of the document?

> Signed-off-by: Stephane Eranian <eranian@google.com>
> --
>  perf_event_intel.c |    1 -
>  1 file changed, 1 deletion(-)
> diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
> index 971dc6e..58e83cd 100644
> --- a/arch/x86/kernel/cpu/perf_event_intel.c
> +++ b/arch/x86/kernel/cpu/perf_event_intel.c
> @@ -43,7 +43,6 @@ static struct event_constraint intel_core2_event_constraints[] =
>  	INTEL_EVENT_CONSTRAINT(0x18, 0x1), /* IDLE_DURING_DIV */
>  	INTEL_EVENT_CONSTRAINT(0x19, 0x2), /* DELAYED_BYPASS */
>  	INTEL_EVENT_CONSTRAINT(0xa1, 0x1), /* RS_UOPS_DISPATCH_CYCLES */
> -	INTEL_EVENT_CONSTRAINT(0xc9, 0x1), /* ITLB_MISS_RETIRED (T30-9) */
>  	INTEL_EVENT_CONSTRAINT(0xcb, 0x1), /* MEM_LOAD_RETIRED */
>  	EVENT_CONSTRAINT_END
>  };



