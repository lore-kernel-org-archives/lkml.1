Return-Path: <linux-kernel-owner+w=401wt.eu-S1754681AbXJ2ARX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754681AbXJ2ARX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2007 20:17:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751121AbXJ2ARQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Oct 2007 20:17:16 -0400
Received: from mga05.intel.com ([192.55.52.89]:26408 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751099AbXJ2ARP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2007 20:17:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.21,339,1188802800"; 
   d="scan'208";a="361864128"
Subject: Re: aim7 -30% regression in 2.6.24-rc1
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>, mingo@elte.hu
In-Reply-To: <1193392422.6914.25.camel@twins>
References: <1193391787.3019.174.camel@ymzhang>
	 <1193392422.6914.25.camel@twins>
Content-Type: text/plain; charset=utf-8
Date: Mon, 29 Oct 2007 08:15:33 +0800
Message-Id: <1193616933.3019.181.camel@ymzhang>
Mime-Version: 1.0
X-Mailer: Evolution 2.9.2 (2.9.2-2.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-10-26 at 11:53 +0200, Peter Zijlstra wrote:
> On Fri, 2007-10-26 at 17:43 +0800, Zhang, Yanmin wrote:
> > I tested 2.6.24-rc1 on my x86_64 machine which has 2 quad-core processors.
> > 
> > Comparing with 2.6.23, aim7 has about -30% regression. I did a bisect and found
> > patch http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=b5869ce7f68b233ceb81465a7644be0d9a5f3dbb
> > caused the issue.
> 
> Bit weird that you point to a merge commit, and not an actual patch. Are
> you sure git bisect pointed at this one?
When I did a bisect, kernel couldn't boot and my testing log showed
it's at b5869ce7f68b233ceb81465a7644be0d9a5f3dbb. So I did a manual
checkout.

#git clone ...
#git pull ...
#git checkout b5869ce7f68b233ceb81465a7644be0d9a5f3dbb

Then, compiled kernel and tested it. Then, reversed above patch and recompiled/retested it.


If I ran git log, I could see this tag in the list.

-yanmin
