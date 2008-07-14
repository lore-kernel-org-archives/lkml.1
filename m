Return-Path: <linux-kernel-owner+w=401wt.eu-S1757939AbYGNViA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757939AbYGNViA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 17:38:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753325AbYGNVhv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 17:37:51 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:39813
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753295AbYGNVhv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 17:37:51 -0400
Date: Mon, 14 Jul 2008 14:37:51 -0700 (PDT)
Message-Id: <20080714.143751.266098047.davem@davemloft.net>
To: mpatocka@redhat.com
Cc: andi@firstfloor.org, sparclinux@vger.kernel.org,
       linux-kernel@vger.kernel.org, jens.axboe@oracle.com
Subject: Re: [SUGGESTION]: drop virtual merge accounting in I/O requests
From: David Miller <davem@davemloft.net>
In-Reply-To: <Pine.LNX.4.64.0807141000340.24718@devserv.devel.redhat.com>
References: <Pine.LNX.4.64.0807140805380.10106@devserv.devel.redhat.com>
	<20080714.052859.88212003.davem@davemloft.net>
	<Pine.LNX.4.64.0807141000340.24718@devserv.devel.redhat.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mikulas Patocka <mpatocka@redhat.com>
Date: Mon, 14 Jul 2008 10:03:29 -0400 (EDT)

> On Mon, 14 Jul 2008, David Miller wrote:
> 
> > From: Mikulas Patocka <mpatocka@redhat.com>
> > Date: Mon, 14 Jul 2008 08:16:13 -0400 (EDT)
> >
> >> As you mentioned ESP driver, it declares .sg_tablesize = SG_ALL, so
> >> BIO_VMERGE_BOUNDARY has no effect on the operation of this driver. Any
> >> other driver where BIO_VMERGE_BOUNDARY does matter?
> >
> > When BIO_VMERGE_BOUNDARY is turned on, requests that would not
> > otherwise fit into the device's limits, can.
> 
> Why would someone want to overshoot SG_ALL? ... and, shouldn't the 
> constant be increased then --- instead of making buggy BIO_VMERGE_BOUNDARY 
> expectations?

I'm talking about other devices, not about the ESP, here.

