Return-Path: <linux-kernel-owner+w=401wt.eu-S1751250AbXC3TJK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751250AbXC3TJK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2007 15:09:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752033AbXC3TJK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Mar 2007 15:09:10 -0400
Received: from mtagate5.uk.ibm.com ([195.212.29.138]:11154 "EHLO
	mtagate5.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751250AbXC3TJI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2007 15:09:08 -0400
Date: Fri, 30 Mar 2007 21:09:05 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Daniel Walker <dwalker@mvista.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       johnstul@us.ibm.com
Subject: Re: [PATCH 8/9] clocksource: s390 initialize list value
Message-ID: <20070330190905.GB13240@osiris.ibm.com>
References: <20070330184541.583153763@mvista.com> <20070330184616.107636073@mvista.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070330184616.107636073@mvista.com>
User-Agent: mutt-ng/devel-r804 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 30, 2007 at 11:45:49AM -0700, Daniel Walker wrote:
> Update arch/s390 with list initialization.
> 
> Signed-Off-By: Daniel Walker <dwalker@mvista.com>
> 
> ---
>  arch/s390/kernel/time.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> Index: linux-2.6.20/arch/s390/kernel/time.c
> ===================================================================
> --- linux-2.6.20.orig/arch/s390/kernel/time.c
> +++ linux-2.6.20/arch/s390/kernel/time.c
> @@ -314,6 +314,7 @@ static struct clocksource clocksource_to
>  	.mult		= 1000,
>  	.shift		= 12,
>  	.flags		= CLOCK_SOURCE_IS_CONTINUOUS,
> +	.list		= LIST_HEAD_INIT(clocksource_tod.list),
>  };

Why? This doesn't fix anything...
