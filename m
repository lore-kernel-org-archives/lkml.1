Return-Path: <linux-kernel-owner+w=401wt.eu-S1754651AbZJLIGb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754651AbZJLIGb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 04:06:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754639AbZJLIG3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 04:06:29 -0400
Received: from mail.gmx.net ([213.165.64.20]:47113 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754579AbZJLIGU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 04:06:20 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+kRad5UGmk6X5VfZThiYM5C8xylvg9NJYUvh30ua
	Ze8rM5urM6P/cy
Subject: Re: hackbench regression with kernel 2.6.32-rc1
From: Mike Galbraith <efault@gmx.de>
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <1255331120.3684.43.camel@ymzhang>
References: <1255079943.25078.23.camel@ymzhang>
	 <1255084986.8802.46.camel@laptop>  <1255331120.3684.43.camel@ymzhang>
Content-Type: text/plain
Date: Mon, 12 Oct 2009 10:05:31 +0200
Message-Id: <1255334731.7282.3.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.66
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-10-12 at 15:05 +0800, Zhang, Yanmin wrote:

> The good news is only tbench has about 6% regression on Nehalem machines.
> Other regressions such like hackbench/aim7/volanoMark is not clear/big on
> Nehalem. But reverting the original 2 patches don't fix the tbench regression
> on Nehalem machines.

Could be NO_NEXT_BUDDY.  NEXT_BUDDY is pretty important for scaling.

	-Mike

