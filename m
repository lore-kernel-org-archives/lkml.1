Return-Path: <linux-kernel-owner+w=401wt.eu-S1756226AbZJ0Hpk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756226AbZJ0Hpk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 03:45:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755572AbZJ0Hpj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 03:45:39 -0400
Received: from brick.kernel.dk ([93.163.65.50]:43975 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755376AbZJ0Hpj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 03:45:39 -0400
Date: Tue, 27 Oct 2009 08:45:43 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Shaohua Li <shaohua.li@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC]cfq-iosched: improve hw_tag detection
Message-ID: <20091027074543.GQ10727@kernel.dk>
References: <20091026091624.GA1169@sli10-desk.sh.intel.com> <20091026113555.GB10727@kernel.dk> <20091027005039.GA14819@sli10-desk.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091027005039.GA14819@sli10-desk.sh.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 27 2009, Shaohua Li wrote:
> On Mon, Oct 26, 2009 at 07:35:55PM +0800, Jens Axboe wrote:
> > On Mon, Oct 26 2009, Shaohua Li wrote:
> > > If active queue hasn't enough requests and idle window opens, cfq will not
> > > dispatch sufficient requests to hardware. In such situation, current code
> > > will zero hw_tag. But this is because cfq doesn't dispatch enough requests
> > > instead of hardware queue doesn't work. Don't zero hw_tag in such case.
> > 
> > Thanks, that looks like a good fix. Curious, is this fixing some
> > regression at your end?
> No, just observed such issue when I play with cfq.

OK thanks, just curious. I will apply it for 2.6.33.

-- 
Jens Axboe

