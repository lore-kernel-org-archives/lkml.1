Return-Path: <linux-kernel-owner+w=401wt.eu-S1757665AbYCYUii@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757665AbYCYUii (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 16:38:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751161AbYCYUi1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 16:38:27 -0400
Received: from terminus.zytor.com ([198.137.202.10]:49061 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751120AbYCYUi0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 16:38:26 -0400
Message-ID: <47E96263.9000808@zytor.com>
Date: Tue, 25 Mar 2008 13:36:51 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@oracle.com>
CC: Greg KH <gregkh@suse.de>, Mark Lord <lkml@rtr.ca>,
       Jens Axboe <axboe@kernel.dk>, Jeff Garzik <jgarzik@pobox.com>,
       Tejun Heo <htejun@gmail.com>, Linus Torvalds <torvalds@osdl.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       IDE/ATA development list <linux-ide@vger.kernel.org>,
       linux-scsi <linux-scsi@vger.kernel.org>
Subject: Re: What to do about the 2TB limit on HDIO_GETGEO ?
References: <47E875AD.1000901@rtr.ca>	<47E87942.2020409@rtr.ca>	<47E88A13.70808@zytor.com>	<47E90019.3050006@rtr.ca>	<47E90458.7030801@zytor.com>	<47E9383F.3050908@rtr.ca>	<20080325192515.GA24234@suse.de> <20080325123454.4eba7644.randy.dunlap@oracle.com>
In-Reply-To: <20080325123454.4eba7644.randy.dunlap@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Randy Dunlap wrote:
>>
>> Come on people, adding symlinks for device major:minor numbers in sysfs
>> to save a few 10s of lines of userspace code?  Can things get sillier?
>>
>> You can add a single udev rule to probably build these in a tree in /dev
>> if you really need such a thing...
>>
>> And what's wrong with your new ioctl recomendation?
> 
> Ah, there's some sanity.  :)
> 

It's not so much an issue of a few tens of lines of user space code, but 
rather the fact that something that should be O(1) is currently O(n).

	-hpa
