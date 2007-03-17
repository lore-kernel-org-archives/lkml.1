Return-Path: <linux-kernel-owner+w=401wt.eu-S933365AbXCQFYx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933365AbXCQFYx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Mar 2007 01:24:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933351AbXCQFYx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Mar 2007 01:24:53 -0400
Received: from vms042pub.verizon.net ([206.46.252.42]:57162 "EHLO
	vms042pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933342AbXCQFYw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Mar 2007 01:24:52 -0400
Date: Sat, 17 Mar 2007 01:24:40 -0400
From: Gene Heskett <gene.heskett@gmail.com>
Subject: Re: forced umount?
In-reply-to: <170fa0d20703162106v47dc13e1u1ae5381576f372ed@mail.gmail.com>
To: linux-kernel@vger.kernel.org
Cc: "Mike Snitzer" <snitzer@gmail.com>, linux-fsdevel@vger.kernel.org
Message-id: <200703170124.42956.gene.heskett@gmail.com>
Organization: Organization? very little
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-1
Content-transfer-encoding: 7bit
Content-disposition: inline
References: <170fa0d20703162106v47dc13e1u1ae5381576f372ed@mail.gmail.com>
User-Agent: KMail/1.9.6
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 17 March 2007, Mike Snitzer wrote:
>I'm interested in understanding the state of Linux with regard to
>_really_ forcing a filesystem to unmount.
>
>There is a (stale) project at OSDL that has various implementations:
>http://developer.osdl.org/dev/fumount/
>
>Its fairly clear that these efforts (e.g. badfs patches) haven't been
>given serious consideration for upstream inclusion.  Do others see
>value in the ability to _reliably_ force a umount by having Linux
>discard all IOs, open files, dirty inode buffers, etc of a "bad"
>blockdevice?  The goal is to not impact the availability or integrity
>of Linux while doing so.
>
>Is this forced umount work even considered worthwhile by the greater
>Linux community?  Is anyone actively working on this?

Having been 'caught out' on this subject more than a few times, usually by 
shutting down a remotely located box that was mounted via smb or cifs, 
and found the only way to get sanity back to the rest of the system was a 
hard reset of every other box that was also sharing that mount, I would 
think this is a worthwhile project.

Take that as a yes vote, from somebody who isn't franchised to vote on it 
in the first place, I'm just a user, usually playing the part of the 
canary in the coal mine.

>Mike

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
QOTD:
	"There may be no excuse for laziness, but I'm sure looking."
