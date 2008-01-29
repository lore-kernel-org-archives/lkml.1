Return-Path: <linux-kernel-owner+w=401wt.eu-S1765391AbYA2Pxm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765391AbYA2Pxm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 10:53:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764573AbYA2PvQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 10:51:16 -0500
Received: from bzq-219-195-70.pop.bezeqint.net ([62.219.195.70]:35288 "EHLO
	bh-buildlin2.bhalevy.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764809AbYA2PvO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 10:51:14 -0500
Message-ID: <479F4B4B.2020000@panasas.com>
Date: Tue, 29 Jan 2008 17:50:35 +0200
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Oliver Neukum <oliver@neukum.org>
CC: Jens Axboe <jens.axboe@oracle.com>, Greg KH <greg@kroah.com>,
       Matthew Dharm <mdharm-usb@one-eyed-alien.net>,
       linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
       linux-scsi@vger.kernel.org
Subject: Re: [BUG] 2.6.24-git usb reset problems
References: <20080128204935.GI15220@kernel.dk> <479F32E9.10609@panasas.com> <20080129141108.GV15220@kernel.dk> <200801291531.39825.oliver@neukum.org>
In-Reply-To: <200801291531.39825.oliver@neukum.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 29 2008 at 16:31 +0200, Oliver Neukum <oliver@neukum.org> wrote:
> Am Dienstag, 29. Januar 2008 15:11:08 schrieb Jens Axboe:
>> On Tue, Jan 29 2008, Boaz Harrosh wrote:
>>> On Tue, Jan 29 2008 at 15:54 +0200, Jens Axboe <jens.axboe@oracle.com> wrote:
>>>> On Tue, Jan 29 2008, Boaz Harrosh wrote:
>>>>> Greg KH wrote:
>  
>>>> No difference, still just a lot of resets.
>>>>
>>> Where you able to figure out which usb storage transport is used?
>>>
>>> in drivers/usb/storage/usb.c you have get_protocol() and get_transport()
>>> functions. I'm not sure if these get stored in sysfs perhaps. This will
>>> pinpoint better where to look. Let me research a bit. 
>> Did the quick'n easy and dumped it. Protocol is 'Transparent SCSI' and
>> transport is 'Bulk'
> 
> You can recompile your kernel with CONFIG_USB_DEBUG and CONFIG_STORAGE_DEBUG
> That should tell the reason for the resets.
> 
> 	Regards
> 		Oliver
> -

I can not see what it is. Yes CONFIG_USB_STORAGE_DEBUG will help.
I have a device here that uses the same trasport/protocol I'll
try to reproduce the failure here.

Boaz
