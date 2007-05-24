Return-Path: <linux-kernel-owner+w=401wt.eu-S1751365AbXEXQD0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751365AbXEXQD0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 12:03:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750720AbXEXQDT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 12:03:19 -0400
Received: from tama55.ecl.ntt.co.jp ([129.60.39.103]:61672 "EHLO
	tama55.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750707AbXEXQDS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 12:03:18 -0400
To: James.Bottomley@SteelEye.com
Cc: fujita.tomonori@lab.ntt.co.jp, jens.axboe@oracle.com, pbadari@gmail.com,
       linux-kernel@vger.kernel.org, bhalevy@panasas.com,
       akpm@linux-foundation.org, michaelc@cs.wisc.edu
Subject: Re: [PATCH] Chaining sg lists for big IO commands v5
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <1180021184.3692.32.camel@mulgrave.il.steeleye.com>
References: <20070524120554.GU5722@kernel.dk>
	<20070524214446V.fujita.tomonori@lab.ntt.co.jp>
	<1180021184.3692.32.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20070525010134I.fujita.tomonori@lab.ntt.co.jp>
Date: Fri, 25 May 2007 01:01:34 +0900
X-Dispatcher: imput version 20040704(IM147)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] Chaining sg lists for big IO commands v5
Date: Thu, 24 May 2007 10:39:44 -0500

> On Thu, 2007-05-24 at 21:44 +0900, FUJITA Tomonori wrote:
> > (cc's added)
> > 
> > From: Jens Axboe <jens.axboe@oracle.com>
> > Subject: Re: [PATCH] Chaining sg lists for big IO commands v5
> > Date: Thu, 24 May 2007 14:05:54 +0200
> > 
> > > On Thu, May 24 2007, Jens Axboe wrote:
> > > > > http://git.kernel.org/?p=linux/kernel/git/tomo/linux-2.6-bidi.git;a=commitdiff;h=fb2747a9f2465ac4a1ea9e3533b92510fbcaae0c
> > > > 
> > > > Neat, will take a look! I should be able to just reuse that.
> > > 
> > > BTW, when do you plan on pushing the SCSI sg update? I'd love for it to
> > > be soon, so I can just rebase the sglist branch on that and get rid of
> > > the SCSI stuff in there.
> > 
> > Well, all I can say is that I'd love James to push the cleanups
> > patchset soon too.
> 
> I'll put the accessor one into scsi-misc.  I'll try to get the other 40
> reviewed via the scsi-pending tree that Mark Salyzyn suggested ... give
> me some time on that.

Thanks. Do you want me to send the patches to scsi-ml or you directly
get them via the git tree?
