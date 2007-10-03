Return-Path: <linux-kernel-owner+w=401wt.eu-S1758173AbXJCMmG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758173AbXJCMmG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2007 08:42:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753619AbXJCMlz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Oct 2007 08:41:55 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:41819 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752648AbXJCMly (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2007 08:41:54 -0400
Date: Wed, 3 Oct 2007 05:41:49 -0700
From: Paul Jackson <pj@sgi.com>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: akpm@linux-foundation.org, menage@google.com, linux-kernel@vger.kernel.org,
       dino@in.ibm.com, cpw@sgi.com, mingo@elte.hu
Subject: Re: [PATCH] cpuset and sched domains: sched_load_balance flag
Message-Id: <20071003054149.a18b0547.pj@sgi.com>
In-Reply-To: <200710030553.27822.nickpiggin@yahoo.com.au>
References: <20070930104403.24828.48263.sendpatchset@jackhammer.engr.sgi.com>
	<200710030525.29735.nickpiggin@yahoo.com.au>
	<20071003051438.e1371e99.pj@sgi.com>
	<200710030553.27822.nickpiggin@yahoo.com.au>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.3; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> pdflush
> is not pinned at all and can be dynamically created and destroyed. Ditto
> for kjournald, as well as many others.

Whatever is not pinned is moved out of the top cpuset, on the kind of
systems I'm most familiar with.  They are put in a smaller cpuset, with
load balancing, that is sized for the workload they might present, but
kept separate from the main jobs.

> Basically: it doesn't feel like a satisfactory solution to brush
> these under the carpet.

We don't do a whole lot of brushing under the carpet on these kind of
systems.  If I gave you the impression we do, then I misled you - sorry.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.925.600.0401
