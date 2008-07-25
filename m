Return-Path: <linux-kernel-owner+w=401wt.eu-S1753524AbYGYFWF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753524AbYGYFWF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 01:22:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751028AbYGYFVy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 01:21:54 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:44650
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750867AbYGYFVx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 01:21:53 -0400
Date: Thu, 24 Jul 2008 22:21:52 -0700 (PDT)
Message-Id: <20080724.222152.193709632.davem@davemloft.net>
To: James.Bottomley@HansenPartnership.com
Cc: mpatocka@redhat.com, fujita.tomonori@lab.ntt.co.jp, jens.axboe@oracle.com,
       linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
       linux-parisc@vger.kernel.org
Subject: Re: [PATCH] block: fix q->max_segment_size checking in
 blk_recalc_rq_segments about VMERGE
From: David Miller <davem@davemloft.net>
In-Reply-To: <1216957670.4524.87.camel@localhost.localdomain>
References: <Pine.LNX.4.64.0807241727320.12036@devserv.devel.redhat.com>
	<20080724.145336.41899163.davem@davemloft.net>
	<1216957670.4524.87.camel@localhost.localdomain>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: James Bottomley <James.Bottomley@HansenPartnership.com>
Date: Thu, 24 Jul 2008 23:47:50 -0400

> I'm sorry sparc broke, really I am ... but you changed your iommu code
> from one with a working vmerge to one without and failed to turn off
> vmerging.  Partly it wasn't noticed because at 2*PAGE_SIZE you have a
> strange vmerge boundary, so it's harder to notice.   However, I can't
> extrapolate that just because this happened on sparc it will inevitably
> happen on all other architectures.

The vmerge boundary on sparc64 was 8K which is equal to sparc64's base
PAGE_SIZE.  I don't know where you get that 2*PAGE_SIZE from.

