Return-Path: <linux-kernel-owner+w=401wt.eu-S1754390AbXEAF1R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754390AbXEAF1R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 01:27:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754411AbXEAF1Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 01:27:16 -0400
Received: from mx2.suse.de ([195.135.220.15]:53063 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754368AbXEAF1Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 01:27:16 -0400
Date: Tue, 1 May 2007 08:24:56 +0200
From: Andi Kleen <ak@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, Andi Kleen <ak@suse.de>,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.21-rc7-mm2 hangs in boot (netconsole)
Message-ID: <20070501062456.GS25929@bingen.suse.de>
References: <20070429220132.951cdf7f.randy.dunlap@oracle.com> <20070429222354.63265e3f.akpm@linux-foundation.org> <20070430081653.60fab0a5.randy.dunlap@oracle.com> <20070430165101.6463fee1.randy.dunlap@oracle.com> <20070430171229.d514ba19.akpm@linux-foundation.org> <46368DC3.5070503@oracle.com> <20070430180821.eb269fe3.akpm@linux-foundation.org> <20070501034330.GJ25929@bingen.suse.de> <20070430221624.dcc7346b.randy.dunlap@oracle.com> <20070430222348.de258c98.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070430222348.de258c98.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> The bug is in firstfloor only, and the fix (if present) will be there too.
> 
> <checks>
> 
> Nope,
> 
> ftp://ftp.firstfloor.org/pub/ak/x86_64/quilt/patches/sched-clock-share
> 
> is identical to
> 
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.21-rc7/2.6.21-rc7-mm2/broken-out/x86_64-mm-sched-clock-share.patch

Or perhaps the deadlock is in the cpufrequency handler. Does it happen without CONFIG_CPUFREQ
too?

[cpufreq handler calls ktime_get which might take xtime lock for reading] 

-Andi
