Return-Path: <linux-kernel-owner+w=401wt.eu-S1756725AbYC0FAe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756725AbYC0FAe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 01:00:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751490AbYC0FAV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 01:00:21 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35812 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751361AbYC0FAU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 01:00:20 -0400
Message-ID: <47EB2953.4070301@zytor.com>
Date: Wed, 26 Mar 2008 21:57:55 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: Bodo Eggert <7eggert@gmx.de>, Randy Dunlap <randy.dunlap@oracle.com>,
       Mark Lord <lkml@rtr.ca>, Jens Axboe <axboe@kernel.dk>,
       Jeff Garzik <jgarzik@pobox.com>, Tejun Heo <htejun@gmail.com>,
       Linus Torvalds <torvalds@osdl.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       IDE/ATA development list <linux-ide@vger.kernel.org>,
       linux-scsi <linux-scsi@vger.kernel.org>
Subject: Re: What to do about the 2TB limit on HDIO_GETGEO ?
References: <ablib-2zv-65@gated-at.bofh.it> <abn0B-735-35@gated-at.bofh.it> <abna7-7jK-3@gated-at.bofh.it> <abo6b-11J-9@gated-at.bofh.it> <aboSP-2Wf-29@gated-at.bofh.it> <aboSP-2Wf-27@gated-at.bofh.it> <abqrq-6eX-29@gated-at.bofh.it> <abqrq-6eX-27@gated-at.bofh.it> <abqKM-6Ka-13@gated-at.bofh.it> <E1JeTq5-00018y-MO@be1.7eggert.dyndns.org> <20080327035257.GB9566@suse.de>
In-Reply-To: <20080327035257.GB9566@suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
>> So e.g. lilo should depend on sysfs and *a*special*configuration* of udev,
>> while the admin MUST NOT use mknod'ed device files nor manually create
>> symlinks pointing to them, and not use relative path names?
>> That's plain stupid.
> 
> If sysfs is stupid, then use an ioctl, have I objected to that?

I think he's objecting to the dependency on udev configuration, not to 
sysfs.

	-hpa
