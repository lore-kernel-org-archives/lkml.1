Return-Path: <linux-kernel-owner+w=401wt.eu-S1759479AbXELT14@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759479AbXELT14 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 May 2007 15:27:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756192AbXELT1q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 May 2007 15:27:46 -0400
Received: from ns2.mvista.com ([63.81.120.158]:39609 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1755684AbXELT1q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 May 2007 15:27:46 -0400
Subject: Re: [PATCH 2/2] i386: sched_clock() follows percpu frequency
	changes
From: Daniel Walker <dwalker@mvista.com>
To: Andi Kleen <ak@suse.de>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       johnstul@us.ibm.com, mingo@elte.hu, Jiri Bohac <jbohac@suse.cz>
In-Reply-To: <200705122058.35387.ak@suse.de>
References: <20070512154344.395866578@mvista.com>
	 <20070512154408.223236808@mvista.com>  <200705122058.35387.ak@suse.de>
Content-Type: text/plain
Date: Sat, 12 May 2007 12:25:40 -0700
Message-Id: <1178997940.27889.16.camel@imap.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-05-12 at 20:58 +0200, Andi Kleen wrote:
> On Saturday 12 May 2007 17:43:46 Daniel Walker wrote:
> > Considering that Andi has a similar patch, I'm going to assume there
> > is already justification for this..
> 
> I just have a patch for sched_clock, which is somewhat different.
> 
> > What it ends up doing is allows the TSC to be used in cases which
> > we didn't use it before, and hope it's still mostly accurate.
> 
> Yes the current code is badly broken in this regard. e.g. i always
> hated that it always falls back on powernow systems.
> 
> Jiri will hopefully repost his true per CPU TSC patch soon, that should
> make it all obsolete.

All I could find on LKML from Jiri was an x86_64 specific gettimeofday
implementation .. Do you have a reference to the first post of the per
cpu tsc patch?

Daniel

