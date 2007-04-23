Return-Path: <linux-kernel-owner+w=401wt.eu-S1753014AbXDWC1l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753014AbXDWC1l (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2007 22:27:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030433AbXDWC1l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Apr 2007 22:27:41 -0400
Received: from mail.parknet.jp ([210.171.160.80]:4078 "EHLO parknet.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753014AbXDWC1k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2007 22:27:40 -0400
X-AuthUser: hirofumi@parknet.jp
To: DervishD <lkml@dervishd.net>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Juergen Beisert <juergen127@kreuzholzen.de>,
       linux-kernel@vger.kernel.org
Subject: Re: Wrong free clusters count on FAT32
References: <20070419085750.GA2833@DervishD>
	<200704191352.06456.juergen127@kreuzholzen.de>
	<20070419141942.GF8287@DervishD> <87d51xtkmp.fsf@duaron.myhome.or.jp>
	<20070421201841.85717088.akpm@linux-foundation.org>
	<87wt05vxu7.fsf@duaron.myhome.or.jp> <20070422112658.GB5786@DervishD>
	<87mz10tyi1.fsf@duaron.myhome.or.jp> <20070422200839.GC12748@DervishD>
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Date: Mon, 23 Apr 2007 11:27:35 +0900
In-Reply-To: <20070422200839.GC12748@DervishD> (DervishD's message of "Sun\, 22 Apr 2007 22\:08\:39 +0200")
Message-ID: <87ps5vq0yw.fsf@duaron.myhome.or.jp>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.0.98 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

DervishD <lkml@dervishd.net> writes:

>> It would add the limitation to following simple usage,
>> 
>> 	# mount -t vfat /dev/sda1 /mnt
>>         # cp -a * /mnt
>>         # umount
>> 
>> if /dev/sda1 was the large and slow device, "mount" will need several
>> minutes to counts free clusters. I think the user will be hard to
>> accept the several minutes at "mount".
>
>     I can carry some tests, but if Windows does that tasks lightning
> fast, Linux surely does it faster ;) I don't think, anyway, that having
> a huge USB disk is a common practice when using "modest" machines.
>
>     If you want, I can perform a couple of tests. I have a 80GB disk
> that I can connect using an USB adapter and my machine is AMD Athlon XP
> 1900+ with 1GB of RAM, which looks pretty slow nowadays O:)

Yes, I think it's not common practice too. But I don't see why do you
want to scanning at the mount.

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
