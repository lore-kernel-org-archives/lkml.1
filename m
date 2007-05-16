Return-Path: <linux-kernel-owner+w=401wt.eu-S1760593AbXEPGMR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760593AbXEPGMR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 02:12:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756280AbXEPGMJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 02:12:09 -0400
Received: from holomorphy.com ([66.93.40.71]:52449 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756431AbXEPGMI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 02:12:08 -0400
Date: Tue, 15 May 2007 23:12:59 -0700
From: William Lee Irwin III <wli@holomorphy.com>
To: dean gaudet <dean@arctic.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.21 numa policy and huge pages not working
Message-ID: <20070516061259.GZ19966@holomorphy.com>
References: <Pine.LNX.4.64.0705152222550.14691@twinlark.arctic.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0705152222550.14691@twinlark.arctic.org>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 15, 2007 at 10:41:06PM -0700, dean gaudet wrote:
> prior to 2.6.21 i could "numactl --interleave=all" and use SHM_HUGETLB and 
> the interleave policy would be respected.  as of 2.6.21 it doesn't seem to 
> respect the policy on SHM_HUGETLB request.
> see test program below.
> output from pre-2.6.21:
> 2ab196200000 interleave=0-3 file=/2\040(deleted) huge dirty=32 N0=8 N1=8 N2=8 N3=8
> 2ab19a200000 default file=/SYSV00000000\040(deleted) dirty=16384 active=0 N0=4096 N1=4096 N2=4096 N3=4096
> output from 2.6.21:
> 2b49b1c00000 default file=/10\040(deleted) huge dirty=32 N3=32
> 2b49b5c00000 default file=/SYSV00000000\040(deleted) dirty=16384 active=0 N0=4096 N1=4096 N2=4096 N3=4096
> was this an intentional behaviour change?  it seems to be only affecting 
> SHM_HUGETLB allocations.  (i haven't tested hugetlbfs yet.)
> run with "numactl --interleave=all ./shmtest"

This was not intentional. I'll search for where it broke.


-- wli
