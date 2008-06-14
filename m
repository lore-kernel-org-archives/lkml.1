Return-Path: <linux-kernel-owner+w=401wt.eu-S1757055AbYFNMXa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757055AbYFNMXa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2008 08:23:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752673AbYFNMXV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jun 2008 08:23:21 -0400
Received: from senator.holtmann.net ([87.106.208.187]:60728 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752528AbYFNMXU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2008 08:23:20 -0400
Subject: Re: [patch 16/47] bluetooth: fix locking bug in the rfcomm socket
	cleanup handling
From: Marcel Holtmann <marcel@holtmann.org>
To: Dave Young <hidave.darkstar@gmail.com>
Cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org, stable@kernel.org,
       Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Arjan van de Ven <arjan@linux.intel.com>,
       "David S. Miller" <davem@davemloft.net>,
       Chris Wright <chrisw@sous-sol.org>
In-Reply-To: <a8e1da0806131950i4eb0ea48q5cc34ea07cfd523a@mail.gmail.com>
References: <20080613234753.235721454@mini.kroah.org>
	 <20080614000840.GA24659@suse.de> <20080614001058.GP24698@suse.de>
	 <a8e1da0806131950i4eb0ea48q5cc34ea07cfd523a@mail.gmail.com>
Content-Type: text/plain
Date: Sat, 14 Jun 2008 14:26:26 +0200
Message-Id: <1213446386.17870.146.camel@violet.holtmann.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dave,

> > Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
> > Acked-by: Marcel Holtmann <marcel@holtmann.org>
> > Signed-off-by: David S. Miller <davem@davemloft.net>
> > Signed-off-by: Chris Wright <chrisw@sous-sol.org>
> > ---
> >  net/bluetooth/rfcomm/core.c |    2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > --- a/net/bluetooth/rfcomm/core.c
> > +++ b/net/bluetooth/rfcomm/core.c
> > @@ -423,8 +423,8 @@ static int __rfcomm_dlc_close(struct rfc
> >
> >                rfcomm_dlc_lock(d);
> >                d->state = BT_CLOSED;
> > -               rfcomm_dlc_unlock(d);
> >                d->state_change(d, err);
> > +               rfcomm_dlc_unlock(d);
> >
> >                skb_queue_purge(&d->tx_queue);
> >                rfcomm_dlc_unlink(d);

did we screw up the tabs during the review process here.

Regards

Marcel


