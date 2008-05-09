Return-Path: <linux-kernel-owner+w=401wt.eu-S934446AbYEIAS4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934446AbYEIAS4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 20:18:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933944AbYEIASg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 20:18:36 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:45351
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1755636AbYEIASe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 20:18:34 -0400
Date: Thu, 08 May 2008 17:18:28 -0700 (PDT)
Message-Id: <20080508.171828.205600975.davem@davemloft.net>
To: gene.heskett@gmail.com
Cc: tmb@mandriva.org, sfr@canb.auug.org.au, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, linux-next@vger.kernel.org,
       mchehab@infradead.org, mingo@elte.hu, linux-dvb-maintainer@linuxtv.org,
       video4linux-list@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [patch, -git] drivers/media build fix for modular builds
From: David Miller <davem@davemloft.net>
In-Reply-To: <200805082016.57622.gene.heskett@gmail.com>
References: <20080507134907.4417708b.sfr@canb.auug.org.au>
	<48230C7B.90007@mandriva.org>
	<200805082016.57622.gene.heskett@gmail.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gene Heskett <gene.heskett@gmail.com>
Date: Thu, 08 May 2008 20:16:57 -0400

> On Thursday 08 May 2008, Thomas Backlund wrote:
> >Stephen Rothwell skrev:
> >>
> >> Index: linux/drivers/media/Makefile
> >> ===================================================================
> >> --- linux.orig/drivers/media/Makefile
> >> +++ linux/drivers/media/Makefile
> >> @@ -2,6 +2,8 @@
> >>  # Makefile for the kernel multimedia device drivers.
> >>  #
> >>
> >> +obj-y := common/
> >> +
> >>  obj-$(CONFIG_VIDEO_MEDIA) += common/
> >>
> >>  # Since hybrid devices are here, should be compiled if DVB and/or V4L
> >
> >How about fixing this one already ?
> >
> Yes please, its biting me too.

Linus merged a version of a fix for this from Ingo earlier today.
