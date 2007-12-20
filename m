Return-Path: <linux-kernel-owner+w=401wt.eu-S1759540AbXLTIDo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759540AbXLTIDo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 03:03:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757152AbXLTIDe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 03:03:34 -0500
Received: from brick.kernel.dk ([87.55.233.238]:15426 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755805AbXLTIDd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 03:03:33 -0500
Date: Thu, 20 Dec 2007 08:58:53 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: David Miller <davem@davemloft.net>
Cc: rusty@rustcorp.com.au, fujita.tomonori@lab.ntt.co.jp,
       linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
       dougg@torque.net
Subject: Re: [PATCH 0/5] sg_ring for scsi
Message-ID: <20071220075852.GI13958@kernel.dk>
References: <200712201645.19035.rusty@rustcorp.com.au> <20071220160741K.fujita.tomonori@lab.ntt.co.jp> <200712201853.48643.rusty@rustcorp.com.au> <20071219.235807.173273479.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071219.235807.173273479.davem@davemloft.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 19 2007, David Miller wrote:
> From: Rusty Russell <rusty@rustcorp.com.au>
> Date: Thu, 20 Dec 2007 18:53:48 +1100
> 
> > Manipulating the magic chains is horrible; it looks simple to the
> > places which simply want to iterate through it, but it's awful for
> > code which wants to create them.
> 
> I'm not saying complexity is inherent in this stuff, but
> assuming that it is the complexity should live as far away
> from the minions (the iterators in this case).  Therefore,
> the creators is the right spot for the hard stuff.

Agree, and the missing bit is just moving the creators out of the driver
parts and into a core helper. See the previous post on the 'sg' branch
for 2.6.25.

-- 
Jens Axboe

