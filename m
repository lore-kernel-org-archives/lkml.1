Return-Path: <linux-kernel-owner+w=401wt.eu-S1758921AbXFISG3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758921AbXFISG3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jun 2007 14:06:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757384AbXFISGF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jun 2007 14:06:05 -0400
Received: from twinlark.arctic.org ([207.29.250.54]:43710 "EHLO
	twinlark.arctic.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753809AbXFISGD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jun 2007 14:06:03 -0400
Date: Sat, 9 Jun 2007 11:06:01 -0700 (PDT)
From: dean gaudet <dean@arctic.org>
To: William Lee Irwin III <wli@holomorphy.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.21 numa policy and huge pages not working
In-Reply-To: <20070516061259.GZ19966@holomorphy.com>
Message-ID: <Pine.LNX.4.64.0706091105200.17468@twinlark.arctic.org>
References: <Pine.LNX.4.64.0705152222550.14691@twinlark.arctic.org>
 <20070516061259.GZ19966@holomorphy.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 May 2007, William Lee Irwin III wrote:

> On Tue, May 15, 2007 at 10:41:06PM -0700, dean gaudet wrote:
> > prior to 2.6.21 i could "numactl --interleave=all" and use SHM_HUGETLB and 
> > the interleave policy would be respected.  as of 2.6.21 it doesn't seem to 
> > respect the policy on SHM_HUGETLB request.
> > see test program below.
> > output from pre-2.6.21:
> > 2ab196200000 interleave=0-3 file=/2\040(deleted) huge dirty=32 N0=8 N1=8 N2=8 N3=8
> > 2ab19a200000 default file=/SYSV00000000\040(deleted) dirty=16384 active=0 N0=4096 N1=4096 N2=4096 N3=4096
> > output from 2.6.21:
> > 2b49b1c00000 default file=/10\040(deleted) huge dirty=32 N3=32
> > 2b49b5c00000 default file=/SYSV00000000\040(deleted) dirty=16384 active=0 N0=4096 N1=4096 N2=4096 N3=4096
> > was this an intentional behaviour change?  it seems to be only affecting 
> > SHM_HUGETLB allocations.  (i haven't tested hugetlbfs yet.)
> > run with "numactl --interleave=all ./shmtest"
> 
> This was not intentional. I'll search for where it broke.

any luck?  i just tested with 2.6.22-rc4 and it's still broken... hmm 
maybe i should learn how to git bisect.

-dean
