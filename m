Return-Path: <linux-kernel-owner+w=401wt.eu-S933367AbXC0Q6H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933367AbXC0Q6H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 12:58:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933388AbXC0Q6H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 12:58:07 -0400
Received: from science.horizon.com ([192.35.100.1]:13588 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S933326AbXC0Q6F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 12:58:05 -0400
Date: 27 Mar 2007 12:58:02 -0400
Message-ID: <20070327165802.13160.qmail@science.horizon.com>
From: linux@horizon.com
To: jpiszcz@lucidpixels.com, linux@horizon.com
Subject: Re: Why is NCQ enabled by default by libata? (2.6.20)
Cc: htejun@gmail.com, jeff@garzik.org, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0703271242580.5965@p34.internal.lan>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> I meant you do not allocate the entire disk per raidset, which may alter 
> performance numbers.

No, that would be silly.  It does lower the average performance of the
large RAID-5 area, but I don't know how ext3fs is allocating the blocks
anyway, so

> 04:00.0 RAID bus controller: Silicon Image, Inc. SiI 3132 Serial ATA Raid II Controller (rev 01)
> I assume you mean 3132 right?

Yes; did I mistype?

02:00.0 Mass storage controller: Silicon Image, Inc. SiI 3132 Serial ATA Raid II Controller (rev 01)
03:00.0 Mass storage controller: Silicon Image, Inc. SiI 3132 Serial ATA Raid II Controller (rev 01)
04:00.0 Mass storage controller: Silicon Image, Inc. SiI 3132 Serial ATA Raid II Controller (rev 01)

> I also have 6 seagates, I'd need to run one 
> of these tests on them as well, also you took the micro jumper off the 
> Seagate 400s in the back as well right?

Um... no, I don't remember doing anything like that.  What micro jumper?
It's been a while, but I just double-checked the drive manual and
it doesn't mention any jumpers.
