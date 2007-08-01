Return-Path: <linux-kernel-owner+w=401wt.eu-S1761737AbXHACkM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761737AbXHACkM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 22:40:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756080AbXHACj6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 22:39:58 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:58718 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756046AbXHACj5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 22:39:57 -0400
Date: Tue, 31 Jul 2007 19:39:54 -0700
From: Nishanth Aravamudan <nacc@us.ibm.com>
To: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
Cc: isimatu.yasuaki@jp.fujitsu.com, tony.luck@intel.com,
       torvalds@linux-foundation.org, ryhodges@us.ibm.com,
       linux-ia64@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: "Add support for vector domain" breaks boot on x355
Message-ID: <20070801023954.GE31324@us.ibm.com>
References: <20070731221356.GA31324@us.ibm.com> <1185932623.3920.5.camel@kane-linux>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1185932623.3920.5.camel@kane-linux>
X-Operating-System: Linux 2.6.22-rc6-gaee87db2 (x86_64)
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 01.08.2007 [10:43:43 +0900], Kenji Kaneshige wrote:
> 2007-07-31 (?$B2P) ?$B$N 15:13 -0700 ?$B$K Nishanth Aravamudan ?$B$5$s$O=q$-$^$7$?:
> > The following commit (4994be1b3fe9120c88022ff5c0c33f6312b17adb) broke
> > Linus' Tree between 2.6.22-git15 and 2.6.22-git16 on a 2-node 8-way x455
> > (Madison procs). Thanks to Ryan Hodges for bisecting down to this
> > commit.
> 
> Thank you for reporting.
> 
> I think this problem might be fixed by the commit
> 6ffbc82351c62eeeeaeb9e817ddf93049353493d. Could you try that?

Ah you might be right. Our testing harness is missing that the kernel
came up further, at least. (2.6.23-rc1-git9 works fine, mostly, it looks
like)

Thanks!
Nish

-- 
Nishanth Aravamudan <nacc@us.ibm.com>
IBM Linux Technology Center
