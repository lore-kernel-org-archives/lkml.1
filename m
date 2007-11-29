Return-Path: <linux-kernel-owner+w=401wt.eu-S934192AbXK2W3d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934192AbXK2W3d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 17:29:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933075AbXK2W26
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 17:28:58 -0500
Received: from rtr.ca ([76.10.145.34]:4549 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932977AbXK2W25 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 17:28:57 -0500
Message-ID: <474F3D27.8050200@rtr.ca>
Date: Thu, 29 Nov 2007 17:28:55 -0500
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Greg KH <gregkh@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@osdl.org>,
       linux-usb-devel@lists.sourceforge.net,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [linux-usb-devel] [PATCH] base/class.c: prevent ooops due to
 insert/remove race (v3)
References: <Pine.LNX.4.44L0.0711291700260.5666-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0711291700260.5666-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Stern wrote:
> On Thu, 29 Nov 2007, Mark Lord wrote:
> 
>>> So again, the problem is in the higher up scsi layer, and that is where
>>> the problem should already be fixed.
>> ..
>>
>> Ahhh.. so you figure the Oops should also have been fixed
>> as part of the 2.6.24 SCSI fixes ?  That's what I was missing here.
> 
> Yes indeed.  I wish I could point you to the exact patch containing the 
> fix, but the git software seems to have lost track of it (it's combined
> in with a large number of other patches with no obvious way to separate 
> it out).  It's also available in the various mailing list archives, but 
> I don't have a pointer to it and there's no reasonable way to search 
> for it.
> 
> The patch in question was written by Matthew Wilcox; it added code to 
> the SCSI async-scanning routines to utilize the scan_mutex.  IMO it 
> should have been applied to 2.6.23 but it wasn't.
..

Ahh.  Well, thanks for the *great* followup, Alan!

Cheers
