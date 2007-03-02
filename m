Return-Path: <linux-kernel-owner+w=401wt.eu-S2992589AbXCBQ3c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992589AbXCBQ3c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 11:29:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992584AbXCBQ3c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 11:29:32 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:54452 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992589AbXCBQ3b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 11:29:31 -0500
Subject: Re: Kernel Oops with shm namespace cleanups
From: Adam Litke <agl@us.ibm.com>
To: Bill Irwin <bill.irwin@oracle.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>, akpm@linux-foundation.org
In-Reply-To: <20070302000808.GE10643@holomorphy.com>
References: <1172693610.12805.16.camel@localhost.localdomain>
	 <20070302000808.GE10643@holomorphy.com>
Content-Type: text/plain
Date: Fri, 02 Mar 2007 10:29:16 -0600
Message-Id: <1172852957.12220.4.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-03-01 at 16:08 -0800, Bill Irwin wrote:
> On Wed, Feb 28, 2007 at 02:13:29PM -0600, Adam Litke wrote:
> > Hey.  While testing 2.6.21-rc2 with libhugetlbfs, the shm-fork test case
> > causes the kernel to oops.  To reproduce:  Execute 'make check' in the
> > latest libhugetlbfs source on a 2.6.21-rc2 kernel with 100 huge pages
> > allocated.  Using fewer huge pages will likely also trigger the oops.
> > Libhugetlbfs can be downloaded from:
> > http://libhugetlbfs.ozlabs.org/snapshots/libhugetlbfs-dev-20070228.tar.gz
> 
> Looks like I should grab these testcases for the sake of due diligence
> (not to say I intend to alter maintenance style from primarily review,
> approval, and bugfixing, not that I've been doing as much of any of those
> as I should). To which architectures and/or distributions have the
> userspace bits been ported, or otherwise run/tested on? A quick sniff
> test on an Altix suggests SLES and/or ia64 may trip up the scripts:

Right now we support x86, powerpc, and x86_64.  Segment remapping and
hugetlb malloc won't work on ia64 until long format vhpt is supported (I
suspect).  But the test framework should be adaptable to other
architectures.

-- 
Adam Litke - (agl at us.ibm.com)
IBM Linux Technology Center

