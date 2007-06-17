Return-Path: <linux-kernel-owner+w=401wt.eu-S1760185AbXFQLhg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760185AbXFQLhg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2007 07:37:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759173AbXFQLh3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jun 2007 07:37:29 -0400
Received: from s2.ukfsn.org ([217.158.120.143]:58711 "EHLO mail.ukfsn.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759066AbXFQLh2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2007 07:37:28 -0400
Message-ID: <46751CEC.5090308@dgreaves.com>
Date: Sun, 17 Jun 2007 12:37:16 +0100
From: David Greaves <david@dgreaves.com>
User-Agent: Mozilla-Thunderbird 2.0.0.0 (X11/20070601)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
       xfs@oss.sgi.com,
       LVM general discussion and development 
	<linux-lvm@redhat.com>,
       linux-pm <linux-pm@lists.osdl.org>
Subject: Re: 2.6.22-rc4 XFS fails after hibernate/resume
References: <46744065.6060605@dgreaves.com> <200706170047.20559.rjw@sisk.pl>
In-Reply-To: <200706170047.20559.rjw@sisk.pl>
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> On Saturday, 16 June 2007 21:56, David Greaves wrote:
>> This isn't a regression.
>>
>> I was seeing these problems on 2.6.21 (but 22 was in -rc so I waited to try it).
>> I tried 2.6.22-rc4 (with Tejun's patches) to see if it had improved - no.
>>
>> Note this is a different (desktop) machine to that involved my recent bugs.
>>
>> The machine will work for days (continually powered up) without a problem and 
>> then exhibits a filesystem failure within minutes of a resume.
>>
>> I know xfs/raid are OK with hibernate. Is lvm?
>>
>> The root filesystem is xfs on raid1 and that doesn't seem to have any problems.
> 
> What is the partition that's showing problems?  How's it set up, on how many
> drives etc.?
I did put that in the OP :)
Here's a recap...
/dev/mapper/video_vg-video_lv on /scratch type xfs (rw)

md1 : active raid5 sdd1[0] sda1[2] sdc1[1]
       390716672 blocks level 5, 64k chunk, algorithm 2 [3/3] [UUU]

haze:~# pvdisplay
   --- Physical volume ---
   PV Name               /dev/md1
   VG Name               video_vg
   PV Size               372.62 GB / not usable 3.25 MB
   Allocatable           yes (but full)
   PE Size (KByte)       4096
   Total PE              95389
   Free PE               0
   Allocated PE          95389
   PV UUID               IUig5k-460l-sMZc-23Iz-MMFl-Cfh9-XuBMiq

> 
> Also, is the dmesg output below from right after the resume?

It runs OK for a few minutes - just enough to think "hey, maybe it'll work this 
time".  Not more than an hour of normal use.
Then you notice when some app fails because the filesystem went away.
The dmesg comes from that point.

David
