Return-Path: <linux-kernel-owner+w=401wt.eu-S1759533AbXKTHvr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759533AbXKTHvr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 02:51:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759273AbXKTHtp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 02:49:45 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:40785
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1759242AbXKTHto (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 02:49:44 -0500
Date: Mon, 19 Nov 2007 23:49:43 -0800 (PST)
Message-Id: <20071119.234943.214163033.davem@davemloft.net>
To: billfink@mindspring.com
Cc: kuznet@ms2.inr.ac.ru, the.sator@gmail.com, linux-kernel@vger.kernel.org,
       jmorris@namei.org, netdev@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH] net/ipv4/arp.c: Fix arp reply when sender ip 0
From: David Miller <davem@davemloft.net>
In-Reply-To: <20071120001607.916f4537.billfink@mindspring.com>
References: <cac0ab7d0711151340l1cc91a2dw5ebf36e166d16d7a@mail.gmail.com>
	<20071119130610.GB6952@ms2.inr.ac.ru>
	<20071120001607.916f4537.billfink@mindspring.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bill Fink <billfink@mindspring.com>
Date: Tue, 20 Nov 2007 00:16:07 -0500

> On Mon, 19 Nov 2007, Alexey Kuznetsov wrote:
> 
> > 2. What's about your suggestion, I thought about this and I am going to agree.
> > 
> >    Arguments, which convinced me are:
> > 
> >    - arping still works.
> >    - any piece of reasonable software should work.
> >    - if Windows understands DaD (is it really true? I cannot believe)
> >      and it is unhappy about our responce and does not block use
> >      of duplicate address only due to this, we _must_ accomodate ASAP.
> >    - if we do,we have to use 0 protocol address, no choice.
> 
> I agree the target protocol address should be 0 in this case.

Patches, someone :-)
