Return-Path: <linux-kernel-owner+w=401wt.eu-S1753400AbXFKQXa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753400AbXFKQXa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 12:23:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751622AbXFKQXW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 12:23:22 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:58218 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752569AbXFKQXV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 12:23:21 -0400
Subject: Re: 2.6.21 numa policy and huge pages not working
From: Adam Litke <agl@us.ibm.com>
To: dean gaudet <dean@arctic.org>
Cc: William Lee Irwin III <wli@holomorphy.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0706092106220.10324@twinlark.arctic.org>
References: <Pine.LNX.4.64.0705152222550.14691@twinlark.arctic.org>
	 <20070516061259.GZ19966@holomorphy.com>
	 <Pine.LNX.4.64.0706092106220.10324@twinlark.arctic.org>
Content-Type: text/plain
Date: Mon, 11 Jun 2007 11:23:14 -0500
Message-Id: <1181578994.12368.10.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-06-09 at 21:10 -0700, dean gaudet wrote:
> On Tue, 15 May 2007, William Lee Irwin III wrote:
> 
> > On Tue, May 15, 2007 at 10:41:06PM -0700, dean gaudet wrote:
> > > prior to 2.6.21 i could "numactl --interleave=all" and use SHM_HUGETLB and 
> > > the interleave policy would be respected.  as of 2.6.21 it doesn't seem to 
> > > respect the policy on SHM_HUGETLB request.
> > > see test program below.
> > > output from pre-2.6.21:
> > > 2ab196200000 interleave=0-3 file=/2\040(deleted) huge dirty=32 N0=8 N1=8 N2=8 N3=8
> > > 2ab19a200000 default file=/SYSV00000000\040(deleted) dirty=16384 active=0 N0=4096 N1=4096 N2=4096 N3=4096
> > > output from 2.6.21:
> > > 2b49b1c00000 default file=/10\040(deleted) huge dirty=32 N3=32
> > > 2b49b5c00000 default file=/SYSV00000000\040(deleted) dirty=16384 active=0 N0=4096 N1=4096 N2=4096 N3=4096
> > > was this an intentional behaviour change?  it seems to be only affecting 
> > > SHM_HUGETLB allocations.  (i haven't tested hugetlbfs yet.)
> > > run with "numactl --interleave=all ./shmtest"
> > 
> > This was not intentional. I'll search for where it broke.
> 
> ok i've narrowed it some... maybe.

Thanks a lot for the detailed information.  I am on it.

-- 
Adam Litke - (agl at us.ibm.com)
IBM Linux Technology Center

