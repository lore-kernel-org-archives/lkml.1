Return-Path: <linux-kernel-owner+w=401wt.eu-S1752834AbZG0Qmv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752834AbZG0Qmv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 12:42:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751546AbZG0Qmu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 12:42:50 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:33760 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751075AbZG0Qmu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 12:42:50 -0400
Date: Mon, 27 Jul 2009 17:42:52 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Ray Lee <ray-lk@madrabbit.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] kdesu broken
Message-ID: <20090727174252.2d987830@lxorguk.ukuu.org.uk>
In-Reply-To: <20090727161424.GA4233@skywalker>
References: <20090725150510.35e8854d@lxorguk.ukuu.org.uk>
	<87ab2sx15g.fsf@devron.myhome.or.jp>
	<20090725163251.50e6f546@lxorguk.ukuu.org.uk>
	<87bpn7mzli.fsf@devron.myhome.or.jp>
	<20090727115723.1e8de60e@lxorguk.ukuu.org.uk>
	<873a8iqqgv.fsf@devron.myhome.or.jp>
	<20090727142303.41096bf5@lxorguk.ukuu.org.uk>
	<877hxujkuv.fsf@devron.myhome.or.jp>
	<20090727145805.690afe5d@lxorguk.ukuu.org.uk>
	<87fxci6ub9.fsf@devron.myhome.or.jp>
	<20090727161424.GA4233@skywalker>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > -			if (count > tty->receive_room) {
> > +			if (count > tty->receive_room)
> >  				count = tty->receive_room;
> > -				done = 0;
> > -			}
> >  			char_buf = head->char_buf_ptr + head->read;
> >  			flag_buf = head->flag_buf_ptr + head->read;
> >  			head->read += count;
> > _
> 
> 
> I still have the "compile in emacs" bug. So this patch along with
> http://article.gmane.org/gmane.linux.kernel/869824 doesn't fix the
> bug for me.

Can you stick some printk calls in and debug it further then because at
with the fixes Ogawa provided I'm finding it impossible to reproduce even
on an 8 way x86.

What hardware are you using ?

