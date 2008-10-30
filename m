Return-Path: <linux-kernel-owner+w=401wt.eu-S1757468AbYJ3Rom@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757468AbYJ3Rom (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 13:44:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754946AbYJ3Rod
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 13:44:33 -0400
Received: from homer.mvista.com ([63.81.120.158]:29337 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1754715AbYJ3Roc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 13:44:32 -0400
Message-ID: <4909F27D.7000701@ct.jp.nec.com>
Date: Thu, 30 Oct 2008 10:44:29 -0700
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Ingo Molnar <mingo@elte.hu>, Mike Travis <travis@sgi.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH -tip/cpus4096-v2] cpumask: fix cpumask of call_function_data
References: <49015358.9050308@ct.jp.nec.com> <200810242205.47181.rusty@rustcorp.com.au> <49024220.5000908@ct.jp.nec.com> <200810270940.21617.rusty@rustcorp.com.au>
In-Reply-To: <200810270940.21617.rusty@rustcorp.com.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell wrote:
...
> From: Rusty Russell <rusty@rustcorp.com.au>
> cpumask: smp_call_function_many()
> 
> Actually change smp_call_function_mask() to smp_call_function_many().
> 
> S390 has its own version, so we do trivial conversion on that too.
> 
> We have to do some dancing to figure out if 0 or 1 other cpus are in
> the mask supplied and the online mask without allocating a tmp
> cpumask.  It's still fairly cheap.
> 
> We allocate the cpumask at the end of the call_function_data
> structure: if allocation fails we fallback to smp_call_function_single
> rather than using the baroque quiescing code.
> 
> (Thanks to Hiroshi Shimamoto for spotting several bugs in previous versions!)
> 
> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
> Signed-off-by: Mike Travis <travis@sgi.com>
> Cc: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
> Cc: schwidefsky@de.ibm.com
> Cc: heiko.carstens@de.ibm.com

Hi Rusty,

I'd like to know which tree this patch is against for.

thanks,
Hiroshi Shimamoto
