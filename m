Return-Path: <linux-kernel-owner+w=401wt.eu-S1756270AbYCYN4l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756270AbYCYN4l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 09:56:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754586AbYCYN4b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 09:56:31 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54206 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754001AbYCYN4a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 09:56:30 -0400
Message-ID: <47E90458.7030801@zytor.com>
Date: Tue, 25 Mar 2008 06:55:36 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Mark Lord <lkml@rtr.ca>
CC: Greg KH <gregkh@suse.de>, Jens Axboe <axboe@kernel.dk>,
       Jeff Garzik <jgarzik@pobox.com>, Tejun Heo <htejun@gmail.com>,
       Linus Torvalds <torvalds@osdl.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       IDE/ATA development list <linux-ide@vger.kernel.org>,
       linux-scsi <linux-scsi@vger.kernel.org>
Subject: Re: What to do about the 2TB limit on HDIO_GETGEO ?
References: <47E875AD.1000901@rtr.ca> <47E87942.2020409@rtr.ca> <47E88A13.70808@zytor.com> <47E90019.3050006@rtr.ca>
In-Reply-To: <47E90019.3050006@rtr.ca>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Lord wrote:
> 
> Yeah, that would be just as good, really.  Maybe even better.
> 
> Mark Lord wrote (later on):
>> Instead, software has to search everything inside /sys/block/
>> looking for a "dev" file whose contents match,
>> rather than just trying to access something like this:
>>
>>   /sys/block/8:1/start
>> or
>>   /sys/block/majors/8/minors/1/start
>>
>> Or any one of a number of similar ways to arrange it. 
> ..
> 

It shouldn't be under /sys/block... there are enough many things that 
scan /sys/block and assume any directory underneath it has the current 
format.

	-hpa
