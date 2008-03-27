Return-Path: <linux-kernel-owner+w=401wt.eu-S1758772AbYC0TEV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758772AbYC0TEV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 15:04:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755448AbYC0TEE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 15:04:04 -0400
Received: from moutng.kundenserver.de ([212.227.126.177]:54995 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754939AbYC0TEB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 15:04:01 -0400
Subject: Re: What to do about the 2TB limit on HDIO_GETGEO ?
From: Kay Sievers <kay.sievers@vrfy.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Mark Lord <lkml@rtr.ca>, Greg KH <gregkh@suse.de>,
       Jens Axboe <axboe@kernel.dk>, Jeff Garzik <jgarzik@pobox.com>,
       Tejun Heo <htejun@gmail.com>, Linus Torvalds <torvalds@osdl.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       IDE/ATA development list <linux-ide@vger.kernel.org>,
       linux-scsi <linux-scsi@vger.kernel.org>
In-Reply-To: <47EBED9B.8020706@zytor.com>
References: <47E875AD.1000901@rtr.ca> <47E87942.2020409@rtr.ca>
	 <47E88A13.70808@zytor.com> <47E90019.3050006@rtr.ca>
	 <47E90458.7030801@zytor.com> <47E9383F.3050908@rtr.ca>
	 <20080325192515.GA24234@suse.de> <47E99A02.7040903@rtr.ca>
	 <3ae72650803271151k5a7b5c4cn5078b3bdf6a9c87a@mail.gmail.com>
	 <47EBED9B.8020706@zytor.com>
Content-Type: text/plain
Date: Thu, 27 Mar 2008 20:03:05 +0100
Message-Id: <1206644585.24291.4.camel@lov.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.0 
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX1+YzEUtyeFO+uXFUWEbdu+oIkG2tPGO9dHcR5H
 KFEmu7OkLqwiTFTQ5EghE+M5NW3J/tyW6VA/WgXGuUodDoqOx5
 M/qEaXST8fmVzD7Qwym1ovGFclII7cP
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-03-27 at 11:55 -0700, H. Peter Anvin wrote:
> Kay Sievers wrote:
> >>
> >>  And it's not just a few 10s of lines of code currently,
> >>  but rather about 80-100 lines just to find the correct device subdir,
> >>  and *then* a few more 10s of lines of code to retrieve the value.
> > 
> > Hmm, 100 lines? What else do you need?
> > 
> >   $ grep -l 8:3 /sys/class/block/*/dev
> >   /sys/class/block/sdc/dev
> > 
> 
> That's particularly funny, because your very own example gives the wrong 
> result -- sdc is 8:32 not 8:3 (which is sdc3, which is also excluded by 
> your search.)

Very true, but I guess you get the idea, and know how to add the proper
string match to grep. :)

> Not to mention the fact that it is still O(n).

Any real numbers from a large setup, which show that we want to have a
reverse devnum map in sysfs?

Thanks,
Kay

