Return-Path: <linux-kernel-owner+w=401wt.eu-S1755834AbZE2Go2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755834AbZE2Go2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 May 2009 02:44:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753878AbZE2GoU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 May 2009 02:44:20 -0400
Received: from one.firstfloor.org ([213.235.205.2]:51253 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753848AbZE2GoU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 May 2009 02:44:20 -0400
Date: Fri, 29 May 2009 08:51:04 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: eranian@gmail.com, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Robert Richter <robert.richter@amd.com>,
       Paul Mackerras <paulus@samba.org>, Andi Kleen <andi@firstfloor.org>,
       Maynard Johnson <mpjohn@us.ibm.com>, Carl Love <cel@us.ibm.com>,
       Corey J Ashford <cjashfor@us.ibm.com>,
       Philip Mucci <mucci@eecs.utk.edu>, Dan Terpstra <terpstra@eecs.utk.edu>,
       perfmon2-devel <perfmon2-devel@lists.sourceforge.net>
Subject: Re: comments on Performance Counters for Linux (PCL)
Message-ID: <20090529065104.GO1065@one.firstfloor.org>
References: <7c86c4470905280758y6d359823h2a7517dfecb115e6@mail.gmail.com> <1243527919.6645.75.camel@laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1243527919.6645.75.camel@laptop>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >        Take Itanium, it has 4 priv levels and the PMU counters can monitor at
> >        any priv levels or combination thereof?
> 
> x86 has more priv rings too, but linux only uses 2, kernel (ring 0) and
> user (ring 2 iirc). Does ia64 expose more than 2 priv levels in linux?

In a hardware virtualized environment x86 Linux uses at least four.

And yes ia64 also exposes more I believe, e.g. it has the fancy
"system calls that run in user context"

-Andi

