Return-Path: <linux-kernel-owner+w=401wt.eu-S1759593AbYCYTFB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759593AbYCYTFB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 15:05:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758277AbYCYTEv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 15:04:51 -0400
Received: from brick.kernel.dk ([87.55.233.238]:20448 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757374AbYCYTEu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 15:04:50 -0400
Date: Tue, 25 Mar 2008 20:04:43 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Akinobu Mita <akinobu.mita@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/5] cdrom: use list_head for cdrom_device_info list
Message-ID: <20080325190443.GM15355@kernel.dk>
References: <20080322030948.GA3665@APFDCB5C> <20080322031047.GB3665@APFDCB5C> <20080322031204.GC3665@APFDCB5C> <20080322031248.GD3665@APFDCB5C> <20080322125535.GE15355@kernel.dk> <961aa3350803220810y25f13d1bk3769e738c9f80625@mail.gmail.com> <20080322175752.GA24089@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080322175752.GA24089@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 22 2008, Christoph Hellwig wrote:
> On Sun, Mar 23, 2008 at 12:10:45AM +0900, Akinobu Mita wrote:
> > 2008/3/22, Jens Axboe <jens.axboe@oracle.com>:
> > > On Sat, Mar 22 2008, Akinobu Mita wrote:
> > >  > Use list_head for cdrom_device_info list instead of opencoded
> > >  > singly list handling.
> > >
> > >
> > > Looks good, but you don't seem to be initializing ->list anywhere. Did
> > >  you test this?
> > >
> > >  I'd suggest just adding an INIT_LIST_HEAD() before the list_add() in
> > >  register_cdrom()
> > 
> > It seems that current list_add() implementation doesn't need
> > initalized new entry with/without CONFIG_DEBUG_LIST.
> 
> it never did and never should.  only the list head needs to be
> initialized.
> 
> your patch is fine in that respect.

It is, my mistake.

-- 
Jens Axboe

