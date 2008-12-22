Return-Path: <linux-kernel-owner+w=401wt.eu-S1755211AbYLVSup@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755211AbYLVSup (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2008 13:50:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753175AbYLVSuh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Dec 2008 13:50:37 -0500
Received: from mx2.redhat.com ([66.187.237.31]:47184 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753148AbYLVSuh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2008 13:50:37 -0500
Date: Mon, 22 Dec 2008 18:50:33 +0000
From: Alasdair G Kergon <agk@redhat.com>
To: Sandeep K Sinha <sandeepksinha@gmail.com>
Cc: linux-kernel@vger.kernel.org, dm-devel@redhat.com
Subject: Re: Device mapper support for more than one target ?
Message-ID: <20081222185033.GA17119@agk.fab.redhat.com>
Mail-Followup-To: Sandeep K Sinha <sandeepksinha@gmail.com>,
	linux-kernel@vger.kernel.org, dm-devel@redhat.com
References: <37d33d830812220922l5a0bc36et5dd1f9853f9cd33@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <37d33d830812220922l5a0bc36et5dd1f9853f9cd33@mail.gmail.com>
User-Agent: Mutt/1.4.1i
Organization: Red Hat UK Ltd. Registered in England and Wales, number 03798903. Registered Office: Amberley Place, 107-111 Peascod Street, Windsor, Berkshire, SL4 1TE.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 22, 2008 at 10:52:08PM +0530, Sandeep K Sinha wrote:
> After looking at the complete implementation of device mappers, I
> figured out that we can have more than one target for a mapped device
> then why do we have a check for the number of target to be equal to
> one , in dm_blk_ioctl ( ) in drivers/md/dm.c
> 
> http://lxr.linux.no/linux+v2.6.27.10/drivers/md/dm.c#L337

Because whether or not it makes sense to send any specific ioctl to more
than one target in parallel depends on what that ioctl does.  When we
added that code we said that we could add hard-coding for specific
ioctls if the need arose, but so far it hasn't.

Alasdair
-- 
agk@redhat.com
