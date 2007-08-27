Return-Path: <linux-kernel-owner+w=401wt.eu-S1762748AbXH0WoR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762748AbXH0WoR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 18:44:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756977AbXH0WoB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 18:44:01 -0400
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:42726 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753938AbXH0Wn7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 18:43:59 -0400
Date: Mon, 27 Aug 2007 15:51:40 -0700
From: Yinghai Lu <Yinghai.Lu@Sun.COM>
Subject: Re: [PATCH] mptsas: scan the logical volume at first
In-reply-to: <664A4EBB07F29743873A87CF62C26D709409BA@NAMAIL4.ad.lsil.com>
To: "Moore, Eric" <Eric.Moore@lsi.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "Prakash, Sathya" <Sathya.Prakash@lsi.com>,
       James Bottomley <James.Bottomley@steeleye.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-scsi@vger.kernel.org
Reply-to: Yinghai.Lu@Sun.COM
Message-id: <46D3557C.9010500@sun.com>
MIME-version: 1.0
Content-type: text/plain; format=flowed; charset=ISO-8859-1
Content-transfer-encoding: 7BIT
References: <664A4EBB07F29743873A87CF62C26D709409BA@NAMAIL4.ad.lsil.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Moore, Eric wrote:
> On Monday, August 27, 2007 11:58 AM,  Yinghai Lu wrote:
>> [PATCH] mptsas: scan the logical volume at first
>>
>> user like to see the raid show as /dev/sda before left raw disks.
>> So scan the volume at first to make their life easier.
>>
>> Signed-off-by: Yinghai Lu <yinghai.lu@sun.com>
>>
> 
> Although I agree with the patch, there are people on this list that will
> reject it due to the fact distro's ship today having udev label and
> device id mapping, so device ordering should be an non-issue.  However

even so, user still can customize it to use /dev/sdaX as root instead of use /dev/scsi/by-id/...or LABEL=/ as root.

> there are systems that ship that don't have BIOS BBS support, allowing
> you to select the boot device. Without it BBS support, you are forced to
> boot to the lowest device id.  There are HP and Dell systems like that.
> Are SUN systems like that?   If so, there is an additional patch which I
> have yet posted that will sort the raid volumes in acsending order.
> Currently they are in descending order (due to Firmware putting them in
> that order), which if you did a install to what you think is /dev/sda,
> its really the highest target id, and when you reboot, the BIOS will
> boot to the lowest id, which is /dev/sdb, and it will not find the boot
> partition.
Yes, I was wondering why kernel.org mainline will have /dev/sdb for first raid. but it seems RHEL 5 kernel have first raid before second raid...( it 
after all left over raw devices..), maybe they already aplied some patch?

can you send out patch?

Thanks

Yinghai Lu
