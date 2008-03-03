Return-Path: <linux-kernel-owner+w=401wt.eu-S1757379AbYCCQRS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757379AbYCCQRS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 11:17:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753486AbYCCQRG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 11:17:06 -0500
Received: from wr-out-0506.google.com ([64.233.184.228]:15746 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753493AbYCCQRF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 11:17:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=UHnmXWretifCRjPSDnlNfxmuCnR+YndX6GYSTAANef6q25JVouLYs3+V5QGv2GwXeXs0Oye/EfRIScK9EWm9X2Jc3z5Aoz5aJ4E7LAbSR603mC8jC81dP87J95Actzkjq7gKcjJy5sHU3nXaAzRuHdHB/nKynb1m7Lgt7Yg3Vjs=
Message-ID: <b6fcc0a0803030817s49aebbci503cbe264e4dbf28@mail.gmail.com>
Date: Mon, 3 Mar 2008 19:17:01 +0300
From: "Alexey Dobriyan" <adobriyan@gmail.com>
To: "Holger Kiehl" <Holger.Kiehl@dwd.de>
Subject: Re: sysfs: duplicate filename '74' can not be created
Cc: linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0803031602460.17218@diagnostix.dwd.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0803031444570.17218@diagnostix.dwd.de>
	 <b6fcc0a0803030750t1430171dib6497c980deee265@mail.gmail.com>
	 <Pine.LNX.4.64.0803031602460.17218@diagnostix.dwd.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/3/08, Holger Kiehl <Holger.Kiehl@dwd.de> wrote:
> On Mon, 3 Mar 2008, Alexey Dobriyan wrote:
>
> > On 3/3/08, Holger Kiehl <Holger.Kiehl@dwd.de> wrote:
> >> I get this approx. 4 hours after booting into 2.6.24.3 (2.6.23.16 worked
> >> fine). This system has 4 CPU's (single core) and 8GB ram. Here some more
> >> details:
> >>
> >>
> >> Mar 3 13:36:56 helena -- MARK --
> >> Mar 3 13:50:01 helena kernel: sysfs: duplicate filename '74' can not be
> >> created
> >> Mar 3 13:50:01 helena kernel: WARNING: at fs/sysfs/dir.c:424
> sysfs_add_one()
> >
> >> Mar 3 13:54:05 helena kernel: Code: 48 8b 04 c2 49 89 04 24 55 9d 31 c0
> >> c1 eb 0f 48 85 d2 0f 95
> >> Mar 3 13:54:05 helena kernel: RIP [<ffffffff80279170>]
> >> __kmalloc_track_caller+0x85/0xb9
> >> Mar 3 13:54:05 helena kernel: RSP <ffff8101dad09da8>
> >> Mar 3 13:54:05 helena kernel: ---[ end trace b8695bfb4832866d ]---
> >
> >> Any idea what is causing this? Kernel 2.6.23.* seems to be fine.
> >
> > Turn CONFIG_USER_SCHED off.
> >
> I think you mean CONFIG_FAIR_USER_SCHED?

Yep, I looked at current kernel.

> > I'll look at why oops happened.
> >
> If it helps I can send you all the oopses. I just posted this one.

Thanks, but no thanks. :-) This one should be enough.
