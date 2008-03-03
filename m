Return-Path: <linux-kernel-owner+w=401wt.eu-S1758086AbYCCQFi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758086AbYCCQFi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 11:05:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754167AbYCCQFa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 11:05:30 -0500
Received: from dwdmx4.dwd.de ([141.38.3.230]:36169 "EHLO dwdmx4.dwd.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754115AbYCCQF3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 11:05:29 -0500
Date: Mon, 3 Mar 2008 16:05:28 +0000 (GMT)
From: Holger Kiehl <Holger.Kiehl@dwd.de>
X-X-Sender: kiehl@diagnostix.dwd.de
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: sysfs: duplicate filename '74' can not be created
In-Reply-To: <b6fcc0a0803030750t1430171dib6497c980deee265@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0803031602460.17218@diagnostix.dwd.de>
References: <Pine.LNX.4.64.0803031444570.17218@diagnostix.dwd.de>
 <b6fcc0a0803030750t1430171dib6497c980deee265@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 3 Mar 2008, Alexey Dobriyan wrote:

> On 3/3/08, Holger Kiehl <Holger.Kiehl@dwd.de> wrote:
>> I get this approx. 4 hours after booting into 2.6.24.3 (2.6.23.16 worked
>> fine). This system has 4 CPU's (single core) and 8GB ram. Here some more
>> details:
>>
>>
>> Mar 3 13:36:56 helena -- MARK --
>> Mar 3 13:50:01 helena kernel: sysfs: duplicate filename '74' can not be
>> created
>> Mar 3 13:50:01 helena kernel: WARNING: at fs/sysfs/dir.c:424 sysfs_add_one()
>
>> Mar 3 13:54:05 helena kernel: Code: 48 8b 04 c2 49 89 04 24 55 9d 31 c0
>> c1 eb 0f 48 85 d2 0f 95
>> Mar 3 13:54:05 helena kernel: RIP [<ffffffff80279170>]
>> __kmalloc_track_caller+0x85/0xb9
>> Mar 3 13:54:05 helena kernel: RSP <ffff8101dad09da8>
>> Mar 3 13:54:05 helena kernel: ---[ end trace b8695bfb4832866d ]---
>
>> Any idea what is causing this? Kernel 2.6.23.* seems to be fine.
>
> Turn CONFIG_USER_SCHED off.
>
I think you mean CONFIG_FAIR_USER_SCHED?

> I'll look at why oops happened.
>
If it helps I can send you all the oopses. I just posted this one.

Thanks,
Holger

