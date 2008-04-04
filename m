Return-Path: <linux-kernel-owner+w=401wt.eu-S1759301AbYDDOa3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759301AbYDDOa3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2008 10:30:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756679AbYDDOaT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Apr 2008 10:30:19 -0400
Received: from mx1.redhat.com ([66.187.233.31]:59685 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756677AbYDDOaS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2008 10:30:18 -0400
Date: Fri, 04 Apr 2008 10:29:02 -0500 (EST)
Message-Id: <20080404.102902.74754100.k-ueda@ct.jp.nec.com>
To: akpm@linux-foundation.org, greg@kroah.com, zaitcev@redhat.com
Cc: bharrosh@panasas.com, schwidefsky@de.ibm.com, linux-kernel@vger.kernel.org,
       j-nomura@ce.jp.nec.com, jens.axboe@oracle.com, m-ikeda@ds.jp.nec.com,
       k-ueda@ct.jp.nec.com, cw@f00f.org
Subject: Re: kernel BUG at drivers/block/ub.c:820!
From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
In-Reply-To: <20080403213010.94045431.akpm@linux-foundation.org>
References: <20080403093042.f20e38a2.zaitcev@redhat.com>
	<47F515A6.4040505@panasas.com>
	<20080403213010.94045431.akpm@linux-foundation.org>
X-Mailer: Mew version 4.2 on Emacs 21.4 / Mule 5.0
 =?iso-2022-jp?B?KBskQjgtTFobKEIp?=
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew, Greg, Pete,

On Thu, 3 Apr 2008 21:30:10 -0700, Andrew Morton wrote:
> On Thu, 03 Apr 2008 20:36:38 +0300 Boaz Harrosh <bharrosh@panasas.com> wrote:
> 
> > On Thu, Apr 03 2008 at 19:30 +0300, Pete Zaitcev <zaitcev@redhat.com> wrote:
> > > On Thu, 03 Apr 2008 17:18:31 +0200, Martin Schwidefsky <schwidefsky@de.ibm.com> wrote:
> > >> On Thu, 2008-04-03 at 11:08 -0500, Kiyoshi Ueda wrote:
> > > 
> > >>> I believe the patch from Pete fixes this BUG():
> > >>>     http://marc.info/?l=linux-usb&m=120613888005382&w=2
> > >>>
> > >>> Could you try that?
> > >> Just tested the patch and it indeed fixes the bug.
> > > 
> > > I'm glad.
> > > 
> > >> Could we push this upstream for 2.6.25? It is a regression, I would
> > >> prefer to have a 2.6.25 that doesn't panic my machine when I attach a
> > >> USB stick..
> > > 
> > > I was going to work through Greg as usual and then push it to
> > > the stable tree. I'm not Linus' "leutenant", so I cannot just send
> > > him random patches.
> > > 
> > > -- Pete
> > 
> > This is a block device siting in block/ folder. It is certainly Jens's
> > linux-block territory. Best put it through the tree that introduced the
> > bug, no?
> > 
> > Best would be to resend to Jens ASAP, it is a 2.6.25 regression.
> 
> I stole it out of Greg's tree - I'll merge it Saturdayish unless someone
> stops me.

I think that it is a broken patch and Pete wants you to take
the patch below:
    http://marc.info/?l=linux-usb&m=120613888005382&w=2

The patch, which Greg and Andrew is taking now, was tested by Chris
Wedgwood and he detected a bug is still in there:
    http://marc.info/?l=linux-usb&m=120603584207543&w=2
Pete revised it and posted the new patch as above, but the new patch
seems not to be included in the Greg's tree yet.


Pete,
The new patch you posted seems not having your sign-off.
Could you follow it so that the new patch can be included instead of
the old patch?

Thanks,
Kiyoshi Ueda
