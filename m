Return-Path: <linux-kernel-owner+w=401wt.eu-S1755814AbZJFHby@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755814AbZJFHby (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 03:31:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754700AbZJFHbx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 03:31:53 -0400
Received: from brick.kernel.dk ([93.163.65.50]:54352 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754393AbZJFHbx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 03:31:53 -0400
Date: Tue, 6 Oct 2009 09:31:16 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Lars Ellenberg <lars.ellenberg@linbit.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       drbd-dev@lists.linbit.com, linux-kernel@vger.kernel.org,
       Philipp Reisner <philipp.reisner@linbit.com>
Subject: Re: [Drbd-dev] linux-next: block/drbd tree build warning
Message-ID: <20091006073116.GE5216@kernel.dk>
References: <20091006140154.8d94d95c.sfr@canb.auug.org.au> <20091006071700.GA7665@johann>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091006071700.GA7665@johann>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 06 2009, Lars Ellenberg wrote:
> On Tue, Oct 06, 2009 at 02:01:54PM +1100, Stephen Rothwell wrote:
> > Hi Jens, Philipp,
> > 
> > Today's linux-next build (x86_64 allmodconfig) produced this warning:
> > 
> > drivers/block/drbd/drbd_nl.c: In function 'drbd_nl_init':
> > drivers/block/drbd/drbd_nl.c:2309: warning: passing argument 3 of 'cn_add_callback' from incompatible pointer type
> > include/linux/connector.h:167: note: expected 'void (*)(struct cn_msg *, struct netlink_skb_parms *)' but argument is of type 'void (*)(struct cn_msg *)'
> 
> Thanks, expected after our connector related patches got in.

Thanks for fixing it quickly, I've added the patch and updated for-next.

-- 
Jens Axboe

