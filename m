Return-Path: <linux-kernel-owner+w=401wt.eu-S1752190AbXCHFSn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752190AbXCHFSn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 00:18:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752265AbXCHFSn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 00:18:43 -0500
Received: from tmailer.gwdg.de ([134.76.10.23]:50897 "EHLO tmailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752190AbXCHFSm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 00:18:42 -0500
Date: Thu, 8 Mar 2007 06:16:39 +0100 (MET)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: dean gaudet <dean@arctic.org>
cc: Marc Perkel <mperkel@yahoo.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-raid@vger.kernel.org
Subject: Re: Raid 10 Problems?
In-Reply-To: <Pine.LNX.4.64.0703071010260.8538@twinlark.arctic.org>
Message-ID: <Pine.LNX.4.61.0703080610580.2448@yvahk01.tjqt.qr>
References: <708349.8753.qm@web52513.mail.yahoo.com>
 <Pine.LNX.4.64.0703071010260.8538@twinlark.arctic.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Mar 7 2007 10:20, dean gaudet wrote:
>>> http://gentoo-wiki.com/HOWTO_Install_on_Software_RAID#Write-intent_bitmap
>> 
>> That information has been extremely useful. Thanks a
>> lot. I fund a command to do the bitmap internal after
>> the array was made so I added that. Seems like some of
>> these features should be default. Maybe it's time for
>> the raid folks to update what is default?
>
>the bitmap has performance implications... for example:
>http://www.mail-archive.com/linux-raid@vger.kernel.org/msg07229.html

I wonder if bitmapping a raid1 volume is faster than bmp.ing raid5.

The other thing is, the bitmap is supposed to be written out at intervals,
not at every write, so the extra head movement for bitmap updates should
be really low, and not making the tar -xjf process slower by half a
minute.
Is there a way to tweak the write-bitmap-to-disk interval? Perhaps 
something in /sys or ye olde /proc. Maybe linux-raid@ knows 8)


>note that unless you tweak your init scripts you'll need to put external 
>bitmaps on your root partition, see this thread:

Huh? That statement does not make sense. But I think you meant: when using
external bitmaps, adjust the init scripts. Because internal bitmaps are good
for one thing: you don't need to change anything.


Jan
-- 
