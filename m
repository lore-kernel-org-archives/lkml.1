Return-Path: <linux-kernel-owner+w=401wt.eu-S1760206AbZBLRam@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760206AbZBLRam (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 12:30:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759962AbZBLRaX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 12:30:23 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:49961 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758424AbZBLRaW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 12:30:22 -0500
Message-ID: <49945C90.3010104@garzik.org>
Date: Thu, 12 Feb 2009 12:29:52 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Eric Sandeen <sandeen@redhat.com>
CC: =?ISO-8859-1?Q?Fernando_Luis_V=E1zquez_Cao?= 
	<fernando@oss.ntt.co.jp>,
       Jan Kara <jack@suse.cz>, Theodore Tso <tytso@MIT.EDU>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Pavel Machek <pavel@suse.cz>,
       kernel list <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>, fernando@kic.ac.jp,
       Ric Wheeler <rwheeler@redhat.com>
Subject: Re: vfs: Add MS_FLUSHONFSYNC mount flag
References: <20090114165952.GH6222@mit.edu>	 <1232021211.14626.19.camel@sebastian.kern.oss.ntt.co.jp>	 <20090115234544.GA7579@duck.suse.cz>	 <1232109069.13775.35.camel@sebastian.kern.oss.ntt.co.jp>	 <1232114101.13775.63.camel@sebastian.kern.oss.ntt.co.jp>	 <20090116163039.GE10617@duck.suse.cz>	 <1232185639.4831.18.camel@sebastian.kern.oss.ntt.co.jp>	 <1232186449.4831.29.camel@sebastian.kern.oss.ntt.co.jp>	 <20090119120349.GA10193@duck.suse.cz>	 <1233135913.5399.57.camel@sebastian.kern.oss.ntt.co.jp>	 <20090128095518.GA16554@duck.suse.cz>	 <1234434811.15270.7.camel@sebastian.kern.oss.ntt.co.jp> <1234434970.15433.4.camel@sebastian.kern.oss.ntt.co.jp> <499458C1.90105@redhat.com>
In-Reply-To: <499458C1.90105@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Sandeen wrote:
> Fernando Luis Vázquez Cao wrote:
>> This mount flag will be used to determine whether the block device's write
>> cache should be flush or not on fsync()/fdatasync().
>>
>> Signed-off-by: Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>
>> ---
> 
> Again, apologies for chiming in late.
> 
> But wouldn't it be better to make this a block device property rather
> than a new filesystem mount option?
> 
> That way the filesystem can always do "the right thing" and call the
> blkdev flush on fsync.
> 
> The block device *could* choose to ignore this in hardware if it knows
> it's built with a nonvolatile write cache or if it has no write cache.

That would certainly be my preference -- turn this ON by default, and 
them if a layer NEEDS to ignore it, it can.

	Jeff




