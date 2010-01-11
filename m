Return-Path: <linux-kernel-owner+w=401wt.eu-S1754260Ab0AKURp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754260Ab0AKURp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 15:17:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754243Ab0AKURn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 15:17:43 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:38378 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754230Ab0AKURl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 15:17:41 -0500
Date: Mon, 11 Jan 2010 21:17:34 +0100
From: Pavel Machek <pavel@ucw.cz>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Karel Zak <kzak@redhat.com>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, util-linux-ng@vger.kernel.org
Subject: Re: [ANNOUNCE] util-linux-ng v2.17 (stable)
Message-ID: <20100111201734.GA11674@elf.ucw.cz>
References: <20100108093302.GS1969@nb.net.home>
 <4B47A713.9060405@zytor.com>
 <20100111140255.GA1416@ucw.cz>
 <4B4B5768.2040005@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B4B5768.2040005@zytor.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2010-01-11 08:52:56, H. Peter Anvin wrote:
> On 01/11/2010 06:05 AM, Pavel Machek wrote:
> >On Fri 2010-01-08 13:43:47, H. Peter Anvin wrote:
> >>On 01/08/2010 01:33 AM, Karel Zak wrote:
> >>>
> >>>fdisk:
> >>>    - the fdisk command aligns newly created partitions to minimum_io_size
> >>>      boundary ("minimum_io_size" is physical sector size or stripe chunk
> >>>      size on RAIDs).
> >>>
> >>>    - the fdisk command supports disks with alignment_offset now.
> >>>
> >>
> >>I think we should align, by default, much more aggressively than that --
> >>because frequently we just don't know what the real physical alignment
> >>is (think of flash media, which uses large erase blocks underneath.)
> >
> >Flash has special mapping layer, and does not care (SD/MMC), or is a
> >raw nand and can't be used as block device (smartmedia).
> >
> 
> Uhm, that's just plain wrong.
> 
> It doesn't matter if there is a "special mapping layer" -- if you're
> crossing multiple erase blocks you're still having more churn in
> your flash translation layer, with more wear on the device, and
> lower performance than if you didn't.

Eraseblocks really should not matter. It is not as if each logical
sector belongs to one eraseblock....

(OTOH, maybe the eraseblock *groups* that are basis for wear-leveling
do, or maybe firmware is doing something really really strange.)
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
