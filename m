Return-Path: <linux-kernel-owner+w=401wt.eu-S1752259Ab0AKOFx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752259Ab0AKOFx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 09:05:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751508Ab0AKOFw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 09:05:52 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:59691 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751270Ab0AKOFv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 09:05:51 -0500
Date: Mon, 11 Jan 2010 15:05:42 +0100
From: Pavel Machek <pavel@ucw.cz>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Karel Zak <kzak@redhat.com>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, util-linux-ng@vger.kernel.org
Subject: Re: [ANNOUNCE] util-linux-ng v2.17 (stable)
Message-ID: <20100111140255.GA1416@ucw.cz>
References: <20100108093302.GS1969@nb.net.home> <4B47A713.9060405@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B47A713.9060405@zytor.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2010-01-08 13:43:47, H. Peter Anvin wrote:
> On 01/08/2010 01:33 AM, Karel Zak wrote:
> > 
> > fdisk:
> >    - the fdisk command aligns newly created partitions to minimum_io_size
> >      boundary ("minimum_io_size" is physical sector size or stripe chunk
> >      size on RAIDs).
> > 
> >    - the fdisk command supports disks with alignment_offset now.
> > 
> 
> I think we should align, by default, much more aggressively than that --
> because frequently we just don't know what the real physical alignment
> is (think of flash media, which uses large erase blocks underneath.)

Flash has special mapping layer, and does not care (SD/MMC), or is a
raw nand and can't be used as block device (smartmedia).
 
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
