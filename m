Return-Path: <linux-kernel-owner+w=401wt.eu-S1759658AbXI1JDQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759658AbXI1JDQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 05:03:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756122AbXI1JDF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 05:03:05 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42948 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756128AbXI1JDE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 05:03:04 -0400
Date: Fri, 28 Sep 2007 02:01:32 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andy Whitcroft <apw@shadowen.org>, Randy Dunlap <rdunlap@xenotime.net>,
       Joel Schopp <jschopp@austin.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] update checkpatch.pl to version 0.10
Message-Id: <20070928020132.f6c6f528.akpm@linux-foundation.org>
In-Reply-To: <20070928084003.GA18882@elte.hu>
References: <bf97f66cfc0696c8574921d53eaafcb7@pinky>
	<20070928084003.GA18882@elte.hu>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 Sep 2007 10:40:03 +0200 Ingo Molnar <mingo@elte.hu> wrote:

> i ran it over kernel/sched.c and there are many bogus warnings that i 
> reported to you earlier:
> 
>   WARNING: multiple assignments should be avoided
>   #2319:
>   +       max_load = this_load = total_load = total_pwr = 0;

That warning is non-bogus, although this is one of the bogosities which
I personally don't bother fixing or making a fuss about.

But I do think it detracts from the readability of the code, and from
patches which later alter that code.  A bit.
