Return-Path: <linux-kernel-owner+w=401wt.eu-S1752467AbXA1Rjo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752467AbXA1Rjo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jan 2007 12:39:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752466AbXA1Rjo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jan 2007 12:39:44 -0500
Received: from mail.tmr.com ([64.65.253.246]:55046 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752467AbXA1Rjn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jan 2007 12:39:43 -0500
Message-ID: <45BCDFAE.5090602@tmr.com>
Date: Sun, 28 Jan 2007 12:38:54 -0500
From: Bill Davidsen <davidsen@tmr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
To: Marc Perkel <mperkel@yahoo.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Raid 10 question/problem [ot]
References: <478459.76045.qm@web52503.mail.yahoo.com>
In-Reply-To: <478459.76045.qm@web52503.mail.yahoo.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Marc Perkel wrote:
> I'm a little stumped trying to set up raid 10. I set
> it up and it worked but after a reboot it forgets my
> raid setup.
> 
> Created 2 raid 1 arrays in md0 and md1 and that works
> and survives a reboot.
> 
> However - I created a raid 0 on /dev/md2 made up of
> /dev/md0 and /dev/md1 and it worked but it forgets it
> after I reboot. The device /dev/md2 fails to survive a
> reboot.
> 
> Created the /etc/mdadm.conf file but that doesn't seem
> to have made a difference.
> 
> What am I missing? Thanks in advance.

RAID-10 is not the same as RAID 0+1.

There's a linux-raid mailing list, the archives may assist in 
understanding this. Either use RAID-10 or add md2 to the mdadm.conf to 
get it started at boot. I suggest using RAID-10.

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot
