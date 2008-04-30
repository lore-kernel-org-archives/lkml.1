Return-Path: <linux-kernel-owner+w=401wt.eu-S1761277AbYD3KiZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761277AbYD3KiZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 06:38:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755766AbYD3KiQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 06:38:16 -0400
Received: from mx1.redhat.com ([66.187.233.31]:57137 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755247AbYD3KiP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 06:38:15 -0400
Date: Wed, 30 Apr 2008 11:38:00 +0100
From: Alasdair G Kergon <agk@redhat.com>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Mike Anderson <andmike@linux.vnet.ibm.com>,
       Mikulas Patocka <mpatocka@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Optimize lock in queue unplugging
Message-ID: <20080430103759.GM18935@agk.fab.redhat.com>
Mail-Followup-To: Alasdair G Kergon <agk@redhat.com>,
	Jens Axboe <jens.axboe@oracle.com>,
	Mike Anderson <andmike@linux.vnet.ibm.com>,
	Mikulas Patocka <mpatocka@redhat.com>, linux-kernel@vger.kernel.org
References: <Pine.LNX.4.64.0804291459030.17110@engineering.redhat.com> <20080429192556.GB12774@kernel.dk> <20080429202928.GB10641@linux.vnet.ibm.com> <20080430071415.GM12774@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080430071415.GM12774@kernel.dk>
User-Agent: Mutt/1.4.1i
Organization: Red Hat UK Ltd. Registered in England and Wales, number 03798903. Registered Office: Amberley Place, 107-111 Peascod Street, Windsor, Berkshire, SL4 1TE.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 30, 2008 at 09:14:15AM +0200, Jens Axboe wrote:
> So it's basically dm calling into blk_unplug() all the time, which
> doesn't check if the queue is plugged. The reason why I didn't like the
> initial patch is that ->unplug_fn() really should not be called unless
> the queue IS plugged. So how about this instead:
> 
> http://git.kernel.dk/?p=linux-2.6-block.git;a=commit;h=c44993018887e82abd49023e92e8d8b6000e03ed
> 
> That's a lot more appropriate, imho.
 
Makes sense to me, ack.

Alasdair
-- 
agk@redhat.com
