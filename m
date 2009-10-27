Return-Path: <linux-kernel-owner+w=401wt.eu-S1755842AbZJ0Auh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755842AbZJ0Auh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 20:50:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755602AbZJ0Aug
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 20:50:36 -0400
Received: from mga03.intel.com ([143.182.124.21]:27814 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754785AbZJ0Aug (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 20:50:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,628,1249282800"; 
   d="scan'208";a="203917523"
Date: Tue, 27 Oct 2009 08:50:39 +0800
From: Shaohua Li <shaohua.li@intel.com>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC]cfq-iosched: improve hw_tag detection
Message-ID: <20091027005039.GA14819@sli10-desk.sh.intel.com>
References: <20091026091624.GA1169@sli10-desk.sh.intel.com> <20091026113555.GB10727@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091026113555.GB10727@kernel.dk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 26, 2009 at 07:35:55PM +0800, Jens Axboe wrote:
> On Mon, Oct 26 2009, Shaohua Li wrote:
> > If active queue hasn't enough requests and idle window opens, cfq will not
> > dispatch sufficient requests to hardware. In such situation, current code
> > will zero hw_tag. But this is because cfq doesn't dispatch enough requests
> > instead of hardware queue doesn't work. Don't zero hw_tag in such case.
> 
> Thanks, that looks like a good fix. Curious, is this fixing some
> regression at your end?
No, just observed such issue when I play with cfq.

Thanks,
Shaohua
