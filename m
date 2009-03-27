Return-Path: <linux-kernel-owner+w=401wt.eu-S1753420AbZC0TTq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753420AbZC0TTq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 15:19:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750864AbZC0TTh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 15:19:37 -0400
Received: from vms173009pub.verizon.net ([206.46.173.9]:8906 "EHLO
	vms173009pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750824AbZC0TTg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 15:19:36 -0400
From: Gene Heskett <gene.heskett@verizon.net>
Organization: Organization? Not detectable
To: Theodore Tso <tytso@mit.edu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Rees <drees76@gmail.com>, Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.29
Date: Fri, 27 Mar 2009 15:19:10 -0400
User-Agent: KMail/1.11.1 (Linux/2.6.28.9; KDE/4.2.1; i686; ; )
References: <20090327112438.GQ6239@mit.edu>
 <alpine.LFD.2.00.0903271058060.3994@localhost.localdomain>
 <20090327190339.GW6239@mit.edu>
In-reply-to: <20090327190339.GW6239@mit.edu>
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-1
Content-transfer-encoding: 7bit
Content-disposition: inline
Message-id: <200903271519.10921.gene.heskett@verizon.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 27 March 2009, Theodore Tso wrote:
>On Fri, Mar 27, 2009 at 11:05:58AM -0700, Linus Torvalds wrote:
>> Alan. Repeat after me: "fsync()+close() is basically useless for any app
>> that expects user interaction under load".
>>
>> That's a FACT, not an opinion.
>
>This is a fact for ext3 with data=ordered mode.  Which is the default
>and dominant filesystem today, yes.  But it's not true for most other
>filesystems.  Hopefully at some point we will migrate people off of
>ext3 to something better.  Ext4 is available today, and is much better
>at this than ext4.  In the long run, btrfs will be better yet.  The
>issue then is how do we transition people away from making assumptions
>that were essentially only true for ext3's data=ordered mode.  Ext4,
>btrfs, XFS, all will have the property that if you fsync() a small
>file, it will be fast, and it won't inflict major delays for other
>programs running on the same system.
>
>You've said for a long that that ext3 is really bad in that it
>inflicts this --- I agree with you.  People should use other
>filesystems which are better.  This includes ext4, which is completely
>format compatible with ext3.  They don't even have to switch on
>extents support to get better behaviour.  Just mounting an ext3
>filesystem with ext4 will result in better behaviour.

Ohkay.  But in a 'make xconfig' of 2.6.28.9, how much of ext4 can be turned on 
without rendering the old ext3 fstab defaults incompatible should I be forced 
to boot a kernel with no ext4 support?

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
Never look a gift horse in the mouth.
		-- Saint Jerome

