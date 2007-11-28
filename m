Return-Path: <linux-kernel-owner+w=401wt.eu-S1762063AbXK2Ajk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762063AbXK2Ajk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 19:39:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758682AbXK2Ajc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 19:39:32 -0500
Received: from mx2.suse.de ([195.135.220.15]:53498 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753168AbXK2Ajb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 19:39:31 -0500
Date: Wed, 28 Nov 2007 15:24:15 -0800
From: Greg KH <gregkh@suse.de>
To: Mark Lord <lkml@rtr.ca>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [BUG] Oops in USB / dev code plugging/unplugging multi flash
	reader
Message-ID: <20071128232415.GA11926@suse.de>
References: <474DC95B.7000201@rtr.ca> <20071128202708.GA3809@suse.de> <474DF713.5070102@rtr.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <474DF713.5070102@rtr.ca>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 28, 2007 at 06:17:39PM -0500, Mark Lord wrote:
> Greg KH wrote:
>> On Wed, Nov 28, 2007 at 03:02:35PM -0500, Mark Lord wrote:
>>> While testing a new USB reader/cable today,
>>> I was plugging/unplugging the USB multi-flash reader (22 in 1),
>>> and produced this weird oops.
>>>
>>> There's a locking problem in there somewhere, Greg.
>>>
>>> 2.6.23.8
>> Can you duplicate this without the closed source ATI graphics driver 
>> loaded?
> ..
>
> I don't know if I can reproduce it easily regardless.
> But that fglrx module has ZERO users, so it was completely benign here
> (I've now deleted it from my system).
>
> The tracebacks clearly show USB/dev error.

I'm not disagreeing, but I've seen some very strange crap over the years
come from those closed source video drivers so I do not trust them at
all.

If you can reproduce this without it loaded, please send the new oops
message to the linux-usb mailing list and the developers there will be
glad to work with you to track this down.

Oh, can you also reproduce it with 2.6.24-rc3?

thanks,

greg k-h
