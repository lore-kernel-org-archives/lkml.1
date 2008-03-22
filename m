Return-Path: <linux-kernel-owner+w=401wt.eu-S1757425AbYCVR6H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757425AbYCVR6H (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2008 13:58:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755342AbYCVR5z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Mar 2008 13:57:55 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:49534 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755339AbYCVR5x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2008 13:57:53 -0400
Date: Sat, 22 Mar 2008 13:57:52 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/5] cdrom: use list_head for cdrom_device_info list
Message-ID: <20080322175752.GA24089@infradead.org>
References: <20080322030948.GA3665@APFDCB5C> <20080322031047.GB3665@APFDCB5C> <20080322031204.GC3665@APFDCB5C> <20080322031248.GD3665@APFDCB5C> <20080322125535.GE15355@kernel.dk> <961aa3350803220810y25f13d1bk3769e738c9f80625@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <961aa3350803220810y25f13d1bk3769e738c9f80625@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 23, 2008 at 12:10:45AM +0900, Akinobu Mita wrote:
> 2008/3/22, Jens Axboe <jens.axboe@oracle.com>:
> > On Sat, Mar 22 2008, Akinobu Mita wrote:
> >  > Use list_head for cdrom_device_info list instead of opencoded
> >  > singly list handling.
> >
> >
> > Looks good, but you don't seem to be initializing ->list anywhere. Did
> >  you test this?
> >
> >  I'd suggest just adding an INIT_LIST_HEAD() before the list_add() in
> >  register_cdrom()
> 
> It seems that current list_add() implementation doesn't need
> initalized new entry with/without CONFIG_DEBUG_LIST.

it never did and never should.  only the list head needs to be
initialized.

your patch is fine in that respect.
