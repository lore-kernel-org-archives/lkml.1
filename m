Return-Path: <linux-kernel-owner+w=401wt.eu-S1753153AbXE3MPs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753153AbXE3MPs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 08:15:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751707AbXE3MPl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 08:15:41 -0400
Received: from tomts25.bellnexxia.net ([209.226.175.188]:59957 "EHLO
	tomts25-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751596AbXE3MPk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 08:15:40 -0400
Date: Wed, 30 May 2007 08:15:36 -0400
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 0/9] Conditional Calls
Message-ID: <20070530121536.GC22567@Krystal>
References: <20070529183356.192838687@polymtl.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20070529183356.192838687@polymtl.ca>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 08:14:39 up 1 day, 20:53,  5 users,  load average: 1.29, 2.22, 1.73
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

It seems I was still working on 2.6.21-mm2. A new patch for 2.6.22-mm1
will be posted in a jiffy.

Mathieu

* Mathieu Desnoyers (mathieu.desnoyers@polymtl.ca) wrote:
> Hi,
> 
> Following Andi Kleen's advice, I splitted the jump-over-call into a speparate
> piece of infrastructure so it can be used more widely.
> 
> It also use a hash table to permit cond_call enable/disable both when the
> cond_call is armed and when a module containing an armed cond_call is loaded.
> 
> Please add at the end of the 2.6.22-mm1 series,
> 
> conditional-calls-architecture-independent-code.patch
> conditional-calls-hash-table.patch
> conditional-calls-non-optimized-architectures.patch
> conditional-calls-kconfig-menus.patch
> conditional-calls-i386-optimization.patch
> conditional-calls-powerpc-optimization.patch
> conditional-calls-documentation.patch
> #
> f00f-bug-use-cond-calls.patch
> profiling-use-cond-calls.patch
> 
> Mathieu
> 
> -- 
> Mathieu Desnoyers
> Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
> OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
