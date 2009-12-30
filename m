Return-Path: <linux-kernel-owner+w=401wt.eu-S1751720AbZL3JSV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751720AbZL3JSV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Dec 2009 04:18:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751167AbZL3JSU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Dec 2009 04:18:20 -0500
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:49270 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751100AbZL3JST (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Dec 2009 04:18:19 -0500
Date: Wed, 30 Dec 2009 10:18:18 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Corrado Zoccolo <czoccolo@gmail.com>,
       Gui Jianfeng <guijianfeng@cn.fujitsu.com>,
       Shaohua Li <shaohua.li@intel.com>
Subject: Re: [Bug #14940] cfq-iosched: tiobench regression
Message-ID: <20091230091818.GW4489@kernel.dk>
References: <LptzGUUXbTK.A.MSF.ymhOLB@chimera> <NJVdobuNFNK.A.1VG.EnhOLB@chimera>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <NJVdobuNFNK.A.1VG.EnhOLB@chimera>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 29 2009, Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.32.  Please verify if it still should be listed and let me know
> (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14940
> Subject		: cfq-iosched: tiobench regression
> Submitter	: Shaohua Li <shaohua.li@intel.com>
> Date		: 2009-12-24 0:55 (6 days old)
> References	: http://marc.info/?l=linux-kernel&m=126161612401994&w=4

I don't think this should be labelled as a regression. It was already
known that we'd have less throughput for the many clients cases, it was
a trade off that was made to improve latencies.

-- 
Jens Axboe

