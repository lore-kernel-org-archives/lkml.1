Return-Path: <linux-kernel-owner+w=401wt.eu-S1756784AbYCYFOi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756784AbYCYFOi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 01:14:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754225AbYCYFO2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 01:14:28 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56504 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753631AbYCYFO1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 01:14:27 -0400
Message-ID: <47E88A13.70808@zytor.com>
Date: Mon, 24 Mar 2008 22:13:55 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Mark Lord <lkml@rtr.ca>
CC: Jens Axboe <axboe@kernel.dk>, Jeff Garzik <jgarzik@pobox.com>,
       Tejun Heo <htejun@gmail.com>, Greg KH <gregkh@suse.de>,
       Linus Torvalds <torvalds@osdl.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       IDE/ATA development list <linux-ide@vger.kernel.org>,
       linux-scsi <linux-scsi@vger.kernel.org>
Subject: Re: What to do about the 2TB limit on HDIO_GETGEO ?
References: <47E875AD.1000901@rtr.ca> <47E87942.2020409@rtr.ca>
In-Reply-To: <47E87942.2020409@rtr.ca>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Lord wrote:
> 
> One candidate might seem to be the existing /sys/block/dev/partition/start
> which I expect is already 64-bit friendly.
> 
> But this requires about 150 lines of somewhat complex C code to access,
> using only the dev_t (from stat(2) on a file) as a starting point,
> or less if one relies upon the udev device name matching the sysfs 
> device name.
> 
> Is it time now for HDIO_GETGEO64 to make an appearance?
> Similar to how the existing BLKGETSIZE64 is supplanting BLKGETSIZE ?
> 

Probably a better thing to have would be a way to look up block devices 
in sysfs by device number.

	-hpa
