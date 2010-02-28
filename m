Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935913Ab0B1Soq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Feb 2010 13:44:46 -0500
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:60036 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933331Ab0B1Sop (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Feb 2010 13:44:45 -0500
Date: Sun, 28 Feb 2010 19:44:44 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Corrado Zoccolo <czoccolo@gmail.com>
Cc: Linux-Kernel <linux-kernel@vger.kernel.org>,
       Jeff Moyer <jmoyer@redhat.com>, Vivek Goyal <vgoyal@redhat.com>,
       Shaohua Li <shaohua.li@intel.com>,
       Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Subject: Re: [PATCH] cfq-iosched: requests "in flight" vs "in driver"
	clarification
Message-ID: <20100228184444.GH5768@kernel.dk>
References: <1267286589-316-1-git-send-email-czoccolo@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1267286589-316-1-git-send-email-czoccolo@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 27 2010, Corrado Zoccolo wrote:
> Counters for requests "in flight" and "in driver" are used asymmetrically
> in cfq_may_dispatch, and have slightly different meaning.
> We split the rq_in_flight counter (was sync_flight) to count both sync
> and async requests, in order to use this one, which is more accurate in
> some corner cases.
> The rq_in_driver counter is coalesced, since individual sync/async counts
> are not used any more.

Thanks, applied.

-- 
Jens Axboe

