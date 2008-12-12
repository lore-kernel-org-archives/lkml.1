Return-Path: <linux-kernel-owner+w=401wt.eu-S1757321AbYLLDtv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757321AbYLLDtv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 22:49:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752079AbYLLDtm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 22:49:42 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:60082
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751838AbYLLDtl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 22:49:41 -0500
Date: Thu, 11 Dec 2008 19:49:42 -0800 (PST)
Message-Id: <20081211.194942.151992963.davem@davemloft.net>
To: gregkh@suse.de
Cc: s.L-H@gmx.de, linux-kernel@vger.kernel.org, stable@kernel.org,
       rolandd@cisco.com, jgarzik@redhat.com
Subject: Re: [patch 03/83] cxgb3: Fix kernel crash caused by uninitialized
 l2t_entry.arpq
From: David Miller <davem@davemloft.net>
In-Reply-To: <20081211234155.GA6791@suse.de>
References: <20081211191334.GC5894@kroah.com>
	<200812112212.35832.s.L-H@gmx.de>
	<20081211234155.GA6791@suse.de>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=utf-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha id mBC3nudq001521

From: Greg KH <gregkh@suse.de>
Date: Thu, 11 Dec 2008 15:41:55 -0800

> On Thu, Dec 11, 2008 at 10:12:34PM +0100, Stefan Lippers-Hollmann wrote:
> >   CC [M]  drivers/net/cxgb3/l2t.o
> > drivers/net/cxgb3/l2t.c: In function â€˜t3_init_l2tâ€™:
> > drivers/net/cxgb3/l2t.c:439: error: implicit declaration of function â€˜__skb_queue_head_initâ€™
> > drivers/net/cxgb3/l2t.c:439: error: â€˜struct l2t_entryâ€™ has no member named â€˜arpqâ€™
 ...
> > It seems to depend on
> > 
> > commit 147e70e62fdd5af6263106ad634b03c5154c1e56
> > Author: David S. Miller <davem@davemloft.net>
> > Date:   Mon Sep 22 01:29:52 2008 -0700
> > 
> >     cxgb3: Use SKB list interfaces instead of home-grown implementation.
> > 
> >     Signed-off-by: David S. Miller <davem@davemloft.net>
> > 
> > Regards
> > 	Stefan Lippers-Hollmann
> 
> 
> Crap, missed this one.  Thanks, I'll respin a -rc2 in a bit after some
> more testing.  I found a Cell problem that should also be addressed...

Sorry my bad, I checked the dependencies wrongly :-/
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
