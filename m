Return-Path: <linux-kernel-owner+w=401wt.eu-S1757665AbYIDLvK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757665AbYIDLvK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 07:51:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753315AbYIDLu5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 07:50:57 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:47707 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752346AbYIDLu4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 07:50:56 -0400
Date: Thu, 4 Sep 2008 13:50:52 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Tejun Heo <tj@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, device@lanana.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: regarding major number of block extended devt
Message-ID: <20080904115052.GF20055@kernel.dk>
References: <48BD30F9.6080108@kernel.org> <48BD3313.7090906@kernel.org> <48BD9F36.8000704@zytor.com> <48BE0EDB.20107@kernel.org> <48BEB759.4050503@zytor.com> <48BEB98C.8030303@kernel.org> <48BEBAF0.7070008@zytor.com> <48BEBF34.50006@kernel.org> <48BED351.1060300@zytor.com> <48BF2AEB.1050508@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48BF2AEB.1050508@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 04 2008, Tejun Heo wrote:
> Hello,
> 
> H. Peter Anvin wrote:
> > Thinking about it some more, one invariant this is *guaranteed* to
> > violate is:
> > 
> >     partition_number = partition_device - master_device
> > 
> > Code that needs a partition number (which is common enough) are using
> > this invariant, because (a) it has held for 17 years and (b) because
> > there is still no alternative other that relying on fragile naming
> > scheme hacks.
> > 
> > (a) we can't do anything about, but (b) we can, by introducing a
> > partition number attribute in sysfs.
> 
> Yeah, that would certainly be a nice addition.  Also, if partitions
> are made proper classes, they'll be easily enumerable by
> /sys/block/*/partitions/*.
> 
> Jens, what do you think?

Agree, that addition definitely makes sense.

-- 
Jens Axboe

