Return-Path: <linux-kernel-owner+w=401wt.eu-S1756698AbYDJNzQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756698AbYDJNzQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 09:55:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755248AbYDJNzE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 09:55:04 -0400
Received: from mail.tmr.com ([64.65.253.246]:35183 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754814AbYDJNzE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 09:55:04 -0400
Message-ID: <47FE1D22.3020007@tmr.com>
Date: Thu, 10 Apr 2008 09:58:58 -0400
From: Bill Davidsen <davidsen@tmr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
To: Francis Moreau <francis.moro@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Disk geometry from /sys
References: <38b2ab8a0804091353h3725ce29s196e27e8b4f1ff56@mail.gmail.com>
In-Reply-To: <38b2ab8a0804091353h3725ce29s196e27e8b4f1ff56@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Francis Moreau wrote:
> Hi,
> 
> I'm trying to know the geometry of my hard disk from a bash script
> and that's the reason I'm looking in /sys. The reason is that I'd like
> to figure out the size of a cylinder without doing a
> ioctl(bdev, HDIO_GETGEO, &geo)
> 
> Unfortunately I can't find anything useful and this is certainly a sign
> that I'm doing something wrong.
> 
> Or maybe can I simply assume from my script that the geometry
> is always heads=255 and the number of sectors per track is 63 for all
> disks.
> 
> Looking at parted(8) source code, I  can find this:
> 
> /* The GETGEO ioctl is no longer useful (as of linux 2.6.x).  We could
>  * still use it in 2.4.x, but this is contentious.  Perhaps we should
>  * move to EDD. */
> 
> Could anybody give me some advices ?

Given that the connection between any modern disk geometry and the 
assumption of a fixed number of sectors per track is pretty tenuous, I'm 
not sure any of the sizes, BIOS, boot program, or OS, are more than 
convention anymore.

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot
