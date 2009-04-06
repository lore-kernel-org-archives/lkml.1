Return-Path: <linux-kernel-owner+w=401wt.eu-S1755139AbZDFWJ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755139AbZDFWJ2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 18:09:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753223AbZDFWJK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 18:09:10 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40981 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751964AbZDFWJJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 18:09:09 -0400
Date: Mon, 6 Apr 2009 15:05:07 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Lin Ming <ming.m.lin@intel.com>, Nick Piggin <npiggin@suse.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Wu Fengguang <fengguang.wu@intel.com>
Subject: Re: [Bug #12809] iozone regression with 2.6.29-rc6
In-Reply-To: <AsKNxFx2juN.A.41._Gn2JB@chimera>
Message-ID: <alpine.LFD.2.00.0904061501470.7443@localhost.localdomain>
References: <n4io5wq70ZO.A.gzG.rFn2JB@chimera> <AsKNxFx2juN.A.41._Gn2JB@chimera>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 6 Apr 2009, Rafael J. Wysocki wrote:
>
> This message has been generated automatically as a part of a report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.28.  Please verify if it still should be listed and let me know
> (either way).
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12809

Hmm. I applied the commit that should fix it, but I applied it _after_ 
2.6.29. I was too scared to apply it late in the -rc and quite frankly 
I'm not sure we should necessarily back-port it.

So I'm hoping that we can close it as "fixed", even though 2.6.29 will 
have that particular regression - for those particular machines. It is, 
after all, just a "where do we draw the line" kind of issue.

But I won't close it myself, and I leave it to others to argue whether it 
really maybe should be back-ported after all.

			Linus
