Return-Path: <linux-kernel-owner+w=401wt.eu-S966213AbXDIQbH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966213AbXDIQbH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 12:31:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966211AbXDIQbH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 12:31:07 -0400
Received: from vms042pub.verizon.net ([206.46.252.42]:58193 "EHLO
	vms042pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966215AbXDIQbF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 12:31:05 -0400
Date: Mon, 09 Apr 2007 12:30:42 -0400
From: Gene Heskett <gene.heskett@gmail.com>
Subject: Re: plain 2.6.21-rc5 (1) vs amanda (0)
In-reply-to: <1176134386.4767.4.camel@dillow.idleaire.net>
To: linux-kernel@vger.kernel.org
Cc: Dave Dillow <dave@thedillows.org>, ray-gmail@madrabbit.org,
       Ingo Molnar <mingo@elte.hu>, amanda-hackers@amanda.org,
       amanda-users@amanda.org
Message-id: <200704091230.42325.gene.heskett@gmail.com>
Organization: Organization? very little
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
Content-disposition: inline
References: <200704010100.19016.gene.heskett@verizon.net>
 <200704091133.44684.gene.heskett@gmail.com>
 <1176134386.4767.4.camel@dillow.idleaire.net>
User-Agent: KMail/1.9.6
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 09 April 2007, Dave Dillow wrote:
>On Mon, 2007-04-09 at 11:33 -0400, Gene Heskett wrote:
>> >I'm not sure I could argue for that to be reverted, so here's a
>> > possible workaround for Fedora -- completely untested.
>> >
>> >Add the following to /etc/modprobe.conf:
>> >options dm_mod major=253
>>
>> This does not work.
>
>Hmm, it worked for me when I tested it this weekend. I did use 'dm-mod'
>instead of 'dm_mod'.
>
>This was using it on FC6, and LVM isn't loaded until after the initrd
>finishes, as I don't use LVM at all. Everything was compiled as modules.
>
>I cannot vouch for it working in the initrd, as I don't have a machine
>that uses LVM for the root.

Now rebooted, with this command line to the kernel:
Kernel command line: ro root=/dev/VolGroup00/LogVol00 rhgb 
dm-mod.major=238 dm.major=238 selinux=0
Unknown boot option `dm-mod.major=238': ignoring
Unknown boot option `dm.major=238': ignoring

So its still at FE00h/65024d.

And I fixed the underscore to a dash in my modprobe.conf, now I'll do 
another mkinitrd & reboot again.


-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
	Horses are forbidden to eat fire hydrants in Marshalltown, Iowa.
