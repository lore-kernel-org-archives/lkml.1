Return-Path: <linux-kernel-owner+w=401wt.eu-S1759537AbXJZJxx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759537AbXJZJxx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 05:53:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753870AbXJZJxp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 05:53:45 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:55196 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752557AbXJZJxp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 05:53:45 -0400
Subject: Re: aim7 -30% regression in 2.6.24-rc1
From: Peter Zijlstra <peterz@infradead.org>
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>, mingo@elte.hu
In-Reply-To: <1193391787.3019.174.camel@ymzhang>
References: <1193391787.3019.174.camel@ymzhang>
Content-Type: text/plain
Date: Fri, 26 Oct 2007 11:53:42 +0200
Message-Id: <1193392422.6914.25.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-10-26 at 17:43 +0800, Zhang, Yanmin wrote:
> I tested 2.6.24-rc1 on my x86_64 machine which has 2 quad-core processors.
> 
> Comparing with 2.6.23, aim7 has about -30% regression. I did a bisect and found
> patch http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=b5869ce7f68b233ceb81465a7644be0d9a5f3dbb
> caused the issue.

Bit weird that you point to a merge commit, and not an actual patch. Are
you sure git bisect pointed at this one?


