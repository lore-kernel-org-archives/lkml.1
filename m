Return-Path: <linux-kernel-owner+w=401wt.eu-S1754356AbZIIVYx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754356AbZIIVYx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 17:24:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754262AbZIIVYx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 17:24:53 -0400
Received: from ns1.coraid.com ([12.51.113.4]:44800 "EHLO coraid.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751028AbZIIVYw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 17:24:52 -0400
From: Ed Cashin <ecashin@coraid.com>
X-Mailer: nedmail
Date: Wed, 9 Sep 2009 17:23:49 -0400
To: jens.axboe@oracle.com, ecashin@coraid.com, alan@lxorguk.ukuu.org.uk,
       akpm@linux-foundation.org, apw@canonical.com, bonbons@linux-vserver.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] aoe: end barrier bios with EOPNOTSUPP
Message-ID: <810bbe1723b0a205f9b5018a5ddaa722@coraid.com>
In-Reply-To: <20090909205835.GK18599@kernel.dk>
References: <20090903063539.GH12579@kernel.dk>
	<2339aa04a4e8fb440a52624273728352@coraid.com>
	<20090904183525.GB18599@kernel.dk>
	<f48e25c99e41e375f2ddd85989cd39e1@coraid.com>
	<20090905051735.GH18599@kernel.dk>
	<366469f19c41e0150028b886f6859019@coraid.com>
	<20090908193540.GB18599@kernel.dk>
	<60772f633c524ba873f569966fccd6ce@coraid.com>
	<20090909180804.3e62331a@lxorguk.ukuu.org.uk>
	<30b7855d211ab5b6bef6fe2cd9b76295@coraid.com>
	<20090909205835.GK18599@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed Sep  9 16:59:30 EDT 2009, jens.axboe@oracle.com wrote:
> On Wed, Sep 09 2009, Ed Cashin wrote:
...
> > To implement the barrier, [aoe] would stop generating new AoE write
> > commands, wait for AoE write responses for all the outstanding write
> > commands, issue the ATA cache flush command, wait for the response to
> > the flush, and then resume normal activity.
> 
> That's how barriers work with sata to begin with, so I'd very much
> recommend that you do the same in aoe instead of just not supporting it.

This patch with EOPNOTSUPP just fixes the regression in 2.6.31-rc9.

A patch adding support for barriers would be nice.  Since I have
limited time I tried to motivate that work by using the torture tests
that Chris Mason (I believe it was) posted a while ago, but I could
not get any problems to manifest using that torture test.

If I had a reproducable problem case that the barrier implementation
could fix, it would be very helpful.

-- 
  Ed
