Return-Path: <linux-kernel-owner+w=401wt.eu-S1756865AbZBPKuH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756865AbZBPKuH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 05:50:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751270AbZBPKtz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 05:49:55 -0500
Received: from smtp-101-monday.noc.nerim.net ([62.4.17.101]:54540 "EHLO
	mallaury.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751170AbZBPKtz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 05:49:55 -0500
Date: Mon, 16 Feb 2009 11:49:49 +0100
From: Damien Wyart <damien.wyart@free.fr>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Mike Galbraith <efault@gmx.de>,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: [Bug #12650] Strange load average and ksoftirqd behavior with
	2.6.29-rc2-git1
Message-ID: <20090216104949.GA23976@localhost.localdomain>
References: <20090215080941.GA2295@localhost.localdomain> <20090215090026.GA31147@elte.hu> <20090215095128.GA3234@localhost.localdomain> <20090215101351.GA23274@elte.hu> <20090215103445.GA2335@localhost.localdomain> <20090215110104.GB31351@elte.hu> <20090215180355.GA2273@localhost.localdomain> <20090215193102.GA16873@elte.hu> <20090216084223.GA2641@localhost.localdomain> <20090216092100.GH6182@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090216092100.GH6182@elte.hu>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > Does it find any TSC time warps?

> > Seems not.

> ok, it's indeed pretty conclusive:

> |  2 CPUs, running 2 parallel test-tasks.
> |  checking for time-warps via:
> |  - read time stamp counter (RDTSC) instruction (cycle resolution)
> | 
> |   | TSC: 0.32us, fail:0 |

> i suspect you ran it for at least a couple of minutes, and the ksoftirqd 
> anomaly occured during it, right?

Yes, that's right. I ran it for a few ten of minutes and the ksoftirqd
anomaly was occuring.

-- 
Damien
