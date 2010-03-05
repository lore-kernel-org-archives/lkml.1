Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753664Ab0CEGUW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 01:20:22 -0500
Received: from ozlabs.org ([203.10.76.45]:43220 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753595Ab0CEGUT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 01:20:19 -0500
Date: Fri, 5 Mar 2010 17:19:42 +1100
From: Paul Mackerras <paulus@samba.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org, eranian@google.com,
       robert.richter@amd.com, fweisbec@gmail.com,
       Arnaldo Carvalho de Melo <acme@infradead.org>
Subject: Re: [PATCH 06/14] perf, x86: PEBS infrastructure
Message-ID: <20100305061942.GF27606@brick.ozlabs.ibm.com>
References: <20100304140046.596569763@chello.nl>
 <20100304140100.392111285@chello.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100304140100.392111285@chello.nl>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 04, 2010 at 03:00:52PM +0100, Peter Zijlstra wrote:

> Implement a simple PEBS model that always takes a single PEBS event at
> a time. This is done so that the interaction with the rest of the
> system is as expected (freq adjust, period randomization, lbr).
> 
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> LKML-Reference: <new-submission>
> ---

...

> @@ -203,8 +203,9 @@ struct perf_event_attr {
>  				enable_on_exec :  1, /* next exec enables     */
>  				task           :  1, /* trace fork/exit       */
>  				watermark      :  1, /* wakeup_watermark      */
> +				precise        :  1, /* OoO invariant counter */

Could you explain in a bit more detail what this means?  

Also, it would be good to mention the ABI addition in the patch
description, and explain it briefly there.

Paul.
