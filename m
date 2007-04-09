Return-Path: <linux-kernel-owner+w=401wt.eu-S1753289AbXDIOIH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753289AbXDIOIH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 10:08:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753300AbXDIOIH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 10:08:07 -0400
Received: from vms044pub.verizon.net ([206.46.252.44]:53456 "EHLO
	vms044pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753289AbXDIOIG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 10:08:06 -0400
Date: Mon, 09 Apr 2007 10:07:58 -0400
From: Gene Heskett <gene.heskett@gmail.com>
Subject: I give up
To: LKML <linux-kernel@vger.kernel.org>
Message-id: <200704091007.58535.gene.heskett@gmail.com>
Organization: Organization? very little
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
Content-disposition: inline
User-Agent: KMail/1.9.6
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings Guys & Dolls;

I give up, I'm whupped.

When I installed FC6, I let it use LVM2 to handle the disks because I was 
tired of fighting with the most broken, nasty, evil disk partitioner ever 
dreamed up, disk druid.  I personally think that abomination was written 
by an M$ plant, specifically to poison users against linux.

Now the 64k$ question: While running with LVM2 managed disks, is it 
possible to run without dm_mod, the device-mapper?  If so, please tell me 
how to achieve this.

I rebooted last night, from 2.6.21-rc6 to 2.6.21-rc6 and for some reason 
device-mapper went from #252 (cat /proc/devices) to #254, and has also 
been seen at #253 in addition to the temporary address of #238 where it 
was before that patch was reverted for 2.6.21-rc6

Anytime this changes, the device numbers in a stat report change, and tar 
thinks its all new & restarts everything on a 45GB system from a level 0.
My vtape setup only has room for 8.5GB per vtape, so the catchup time is 
many days.  I can speed that up by temporarily making the vtape bigger in 
my amanda.conf, but now the disk itself that the vtapes are on is at 96% 
and will not tolerate another such catchup run.

So I'm pleading for either a stable, known address for device-mapper, or a 
workaround that will immunize tar against its apparently uncontrolled 
wanderings.

Please, pretty please, with sugar and cream in it even, please, give some 
stability to this situation....

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
George Washington was first in war, first in peace -- and the first to
have his birthday juggled to make a long weekend.
		-- Ashley Cooper
