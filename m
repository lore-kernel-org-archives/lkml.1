Return-Path: <linux-kernel-owner+w=401wt.eu-S1753654AbXLKNSx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753654AbXLKNSx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 08:18:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752270AbXLKNSc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 08:18:32 -0500
Received: from brick.kernel.dk ([87.55.233.238]:1342 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751983AbXLKNSa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 08:18:30 -0500
Date: Tue, 11 Dec 2007 14:15:14 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Daniel Phillips <phillips@phunq.net>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [RFC] [PATCH] A clean aEvgeniy pproach to writeout throttling
Message-ID: <20071211131514.GB25437@kernel.dk>
References: <200712051603.02183.phillips@phunq.net> <200712100543.45204.phillips@phunq.net> <20071210135352.GL5008@kernel.dk> <200712100617.24157.phillips@phunq.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200712100617.24157.phillips@phunq.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 10 2007, Daniel Phillips wrote:
> Now about that block writeout deadlock... it doesn't just affect my 
> code, it basically breaks Linux as a storage platform, among other 
> things.

As written in other similar threads in the past in which you also
participated, I still of the opinion that this is a vm issue and should
be solved as such.

As to the patch in question "fixing" it in the block layer, it's a
fairly simple work around and I'm not totally against it. If you get rid
of the ->bi_throttle stuff and just do sanity checks on the count, then
we could look at getting some testing done.

-- 
Jens Axboe

