Return-Path: <linux-kernel-owner+w=401wt.eu-S1754890AbYCNH0z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754890AbYCNH0z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2008 03:26:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751738AbYCNH0p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Mar 2008 03:26:45 -0400
Received: from mga10.intel.com ([192.55.52.92]:39439 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751672AbYCNH0o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2008 03:26:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,499,1199692800"; 
   d="scan'208";a="533768303"
Subject: Re: hackbench regression since 2.6.25-rc
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Kay Sievers <kay.sievers@vrfy.org>, Greg Kroah-Hartman <gregkh@suse.de>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <Pine.LNX.4.64.0803132333020.24204@schroedinger.engr.sgi.com>
References: <1205394417.3215.85.camel@ymzhang>
	 <20080313014808.f8d25c2a.akpm@linux-foundation.org>
	 <1205400538.3215.148.camel@ymzhang>
	 <Pine.LNX.4.64.0803131714130.22519@schroedinger.engr.sgi.com>
	 <1205463842.3215.188.camel@ymzhang> <1205465447.3215.195.camel@ymzhang>
	 <Pine.LNX.4.64.0803132333020.24204@schroedinger.engr.sgi.com>
Content-Type: text/plain; charset=utf-8
Date: Fri, 14 Mar 2008 15:23:18 +0800
Message-Id: <1205479398.3215.284.camel@ymzhang>
Mime-Version: 1.0
X-Mailer: Evolution 2.9.2 (2.9.2-2.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-03-13 at 23:34 -0700, Christoph Lameter wrote:
> On Fri, 14 Mar 2008, Zhang, Yanmin wrote:
> 
> > > So block 192 and 512's and very active and their fast free percentage 
> > > is low.
> > On my 8-core stoakley, there is no such regression. Below data is after testing.
> 
> Ok get the detailed statistics for this configuration as well. Then we 
> can see what kind of slub behavior changes between both configurations.
I did paste such data in a prior email. COpy it below.

On my 8-core stoakley, there is no such regression. Below data is after testing.
[root@lkp-st02-x8664 ~]# slabinfo -AD
Name                   Objects    Alloc     Free   %Fast
:0000192                  3170 80055388 80052280  92   1 
:0000512                   316 80012750 80012466  69   1 
vm_area_struct            2642   194700   192193  94  16 
:0000064                  3846    74468    70820  97  53 
:0004096                    15    69014    69012  98  97 
:0000128                  1447    32920    31541  91   8 
dentry                   13485    33060    19652  92  42 
:0000080                 10639    23377    12953  98  98 
:0000096                  1662    16496    15036  99  94 
:0000832                   232    14422    14203  85  10 
:0000016                  2733    15102    13372  99  14 

I ran it for many times and got the similiar output from slabinfo.

> 
> The 16p is really one node?
Yes. It's a SMP machine.

>  No strange variances in memory latencies? 
No.


