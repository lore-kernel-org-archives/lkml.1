Return-Path: <linux-kernel-owner+w=401wt.eu-S1753953AbYHRBtf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753953AbYHRBtf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2008 21:49:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751501AbYHRBtZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Aug 2008 21:49:25 -0400
Received: from mga10.intel.com ([192.55.52.92]:59271 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751291AbYHRBtX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2008 21:49:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.32,225,1217833200"; 
   d="scan'208";a="371426308"
Subject: Re: tbench regression on each kernel release from  2.6.22 -> 2.6.28
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: netdev@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <48A086B6.2000901@linux-foundation.org>
References: <48A086B6.2000901@linux-foundation.org>
Content-Type: text/plain
Date: Mon, 18 Aug 2008 09:48:32 +0800
Message-Id: <1219024112.25608.321.camel@ymzhang>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.5 (2.21.5-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2008-08-11 at 13:36 -0500, Christoph Lameter wrote:
> It seems that the network stack becomes slower over time? Here is a list of
> tbench results with various kernel versions:
> 
> 2.6.22		3207.77 mb/sec
> 2.6.24		3185.66
> 2.6.25		2848.83
> 2.6.26		2706.09
> 2.6.27(rc2)	2571.03
What's the hardware configuration? Is it dual-core?

I also track tbench performance with lastest kernels on a couple of quad-core machines,
and didn't find such regression while the results did have fluctuation.

What's the commandline you is using to start tbench? I start tbench with CPU_NUM*2.

BTW, I enabled CONFIG_SLUB since 2.6.22.

> 
> And linux-next is:
> 
> 2.6.28(l-next)	2568.74
> 
> It shows that there is still have work to be done on linux-next. Too close to
> upstream in performance.
> 
> Note the KT event between 2.6.24 and 2.6.25. Why is that?


