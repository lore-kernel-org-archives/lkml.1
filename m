Return-Path: <linux-kernel-owner+w=401wt.eu-S1753930AbYCZGFj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753930AbYCZGFj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 02:05:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751281AbYCZGF1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 02:05:27 -0400
Received: from terminus.zytor.com ([198.137.202.10]:58762 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750737AbYCZGF0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 02:05:26 -0400
Message-ID: <47E9E781.4000901@zytor.com>
Date: Tue, 25 Mar 2008 23:04:49 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Tejun Heo <htejun@gmail.com>
CC: Greg KH <gregkh@suse.de>, Mark Lord <lkml@rtr.ca>,
       Jens Axboe <axboe@kernel.dk>, Jeff Garzik <jgarzik@pobox.com>,
       Linus Torvalds <torvalds@osdl.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       IDE/ATA development list <linux-ide@vger.kernel.org>,
       linux-scsi <linux-scsi@vger.kernel.org>
Subject: Re: What to do about the 2TB limit on HDIO_GETGEO ?
References: <47E875AD.1000901@rtr.ca> <47E87942.2020409@rtr.ca> <47E88A13.70808@zytor.com> <47E90019.3050006@rtr.ca> <47E90458.7030801@zytor.com> <47E9383F.3050908@rtr.ca> <20080325192515.GA24234@suse.de> <47E99A02.7040903@rtr.ca> <47E99EBE.7010708@gmail.com> <20080326033804.GA27925@suse.de> <47E9D017.5080305@gmail.com>
In-Reply-To: <47E9D017.5080305@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
> 
>> Since when is the major:minor view of devices the "standard" one that
>> userspace uses?  Last I looked, userspace uses symlinks and lots of
>> other ways of directly accessing block devices in /dev/, and does not
>> rely on major:minor.
> 
> The fact that major:minor is the unique identifier of a device makes it
> a bit special compared to other names on filesystem.
> 

In particular, stat() and friends returns the device number, not a 
device name.

	-hpa
