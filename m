Return-Path: <linux-kernel-owner+w=401wt.eu-S1763446AbYEGHE3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763446AbYEGHE3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 03:04:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756718AbYEGHET
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 03:04:19 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40132 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755717AbYEGHES (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 03:04:18 -0400
Date: Wed, 7 May 2008 00:04:09 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: volanoMark regression with kernel 2.6.26-rc1
Message-Id: <20080507000409.4ecc7d30.akpm@linux-foundation.org>
In-Reply-To: <1210039590.3453.18.camel@ymzhang>
References: <1210039590.3453.18.camel@ymzhang>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 06 May 2008 10:06:30 +0800 "Zhang, Yanmin" <yanmin_zhang@linux.intel.com> wrote:

> Comparing with 2.6.25, volanoMark has big regression with kernel 2.6.26-rc1.
> It's about 50% on my 8-core stoakley, 16-core tigerton, and Itanium Montecito.
> 
> With bisect, I located below patch.
> 
> 18d95a2832c1392a2d63227a7a6d433cb9f2037e is first bad commit
> commit 18d95a2832c1392a2d63227a7a6d433cb9f2037e
> Author: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Date:   Sat Apr 19 19:45:00 2008 +0200

The merge window strikes again?

> 
>     sched: fair-group: SMP-nice for group scheduling
>     
>     Implement SMP nice support for the full group hierarchy.
> 
> If I reverse the patch with resolving some conflictions, volanoMark result could
> be restored completely.
> 
> ___
> AIM7 (use tmpfs) also has ___more than 40% on my 8-core stoakley, 16-core tigerton,
> and Itanium Montecito, but I verified that aim7 regression isn't caused by above
> patch. I am doing new bisect to check aim7 now.
> 

