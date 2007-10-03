Return-Path: <linux-kernel-owner+w=401wt.eu-S1756712AbXJCKIu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756712AbXJCKIu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2007 06:08:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753177AbXJCKIm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Oct 2007 06:08:42 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:35349 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753013AbXJCKIm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2007 06:08:42 -0400
Date: Wed, 3 Oct 2007 03:08:38 -0700
From: Paul Jackson <pj@sgi.com>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: mingo@elte.hu, akpm@linux-foundation.org, menage@google.com,
       linux-kernel@vger.kernel.org, dino@in.ibm.com, cpw@sgi.com
Subject: Re: [patch] sched: fix sched-domains partitioning by cpusets
Message-Id: <20071003030838.e99bf3a0.pj@sgi.com>
In-Reply-To: <200710030323.42454.nickpiggin@yahoo.com.au>
References: <20070930104403.24828.48263.sendpatchset@jackhammer.engr.sgi.com>
	<200710030146.30162.nickpiggin@yahoo.com.au>
	<20071003022108.5a8e310e.pj@sgi.com>
	<200710030323.42454.nickpiggin@yahoo.com.au>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.3; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Nick, responding to pj, wrote:
> >     However a little bit of additional kernel cpuset code could hide
> >     this detail from user space, by recognizing when the user had
> >     asked to turn off load balancing on some larger cpuset, and by
> >     then calling partition_sched_domains() multiple times, once for
> >     each CPU in that cpuset.
> 
> Yeah: do all that in cpusets. It's already information you would have
> to derive in order to make it work properly anyway. If you are not
> passing in the singleton domains ATM, then they will not get properly
> detached and isolated.

ok

> It's not a huge deal, but I'd like to keep partition_sched_domains. After
> my patch, it's really simple.

ok

It's a deal.

I've got a couple of brown paper bag bug fixes almost ready to send
out, for the patch I sent Andrew a few days ago:

  cpuset and sched domains: sched_load_balance flag

I'll send these in, and then get some sleep and code up these changes
to the partition_sched_domains, along the lines you have recommended.

Thanks, Nick and Ingo.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.925.600.0401
