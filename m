Return-Path: <linux-kernel-owner+w=401wt.eu-S1757889AbZBLD0y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757889AbZBLD0y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 22:26:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756637AbZBLD0p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 22:26:45 -0500
Received: from mga09.intel.com ([134.134.136.24]:2217 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756629AbZBLD0o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 22:26:44 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,194,1233561600"; 
   d="scan'208";a="386115842"
Subject: Re: specjbb2005 fails with 2.6.29-rc4
From: Lin Ming <ming.m.lin@intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Mel Gorman <mel@csn.ul.ie>
In-Reply-To: <alpine.LFD.2.00.0902111733170.3189@localhost.localdomain>
References: <1234401390.7699.29.camel@minggr.sh.intel.com>
	 <alpine.LFD.2.00.0902111733170.3189@localhost.localdomain>
Content-Type: text/plain
Date: Thu, 12 Feb 2009 11:23:55 +0800
Message-Id: <1234409035.7699.34.camel@minggr.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 (2.24.1-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-02-12 at 09:35 +0800, Linus Torvalds wrote:
> 
> On Thu, 12 Feb 2009, Lin Ming wrote:
> > 
> > Test with Jrockit VM fails. And it works well if OpenJDK is used
> > instead.
> 
> I suspect maybe it uses hugetlbs?
> 
> There were a couple of commits to fix VM_ACCOUNT for hugepage areas 
> recently. See
> 
>  - 5a6fe125950676015f5108fb71b2a67441755003: "Do not account for the 
>    address space used by hugetlbfs using VM_ACCOUNT"
> 
>  - 17c9d12e126cb0de8d535dc1908c4819d712bc68: "Do not account for hugetlbfs 
>    quota at mmap() time if mapping [SHM|MAP]_NORESERVE"
> 
> because hugetlb mappings have their own magical VM accounting.
> 
> So can you check if current -git fixes it?

Yes, current -git fixes it.

Lin Ming

