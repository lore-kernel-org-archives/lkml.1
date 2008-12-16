Return-Path: <linux-kernel-owner+w=401wt.eu-S1754036AbYLPJVI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754036AbYLPJVI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 04:21:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751873AbYLPJUx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 04:20:53 -0500
Received: from lucidpixels.com ([75.144.35.66]:59349 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751767AbYLPJUw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 04:20:52 -0500
Date: Tue, 16 Dec 2008 04:20:50 -0500 (EST)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: Dan Williams <dan.j.williams@gmail.com>
cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
       Alan Piszcz <ap@solarrain.com>
Subject: Re: 2.6.27.8: OOM killer: [swapper: page allocation failure]
In-Reply-To: <e9c3a7c20812151644p7c1038cajd7254a963f9038a2@mail.gmail.com>
Message-ID: <alpine.DEB.1.10.0812160419550.28063@p34.internal.lan>
References: <alpine.DEB.1.10.0812120708080.9826@p34.internal.lan> <e9c3a7c20812151644p7c1038cajd7254a963f9038a2@mail.gmail.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 15 Dec 2008, Dan Williams wrote:

> On Fri, Dec 12, 2008 at 5:14 AM, Justin Piszcz <jpiszcz@lucidpixels.com> wrote:
>> [44893.846532] swapper: page allocation failure. order:0, mode:0x20
> [..]
>>
>> Raid optimizations used:
>>
>> # cat oraid.sh |grep -v ^#|grep .
>> . /etc/profile
>> echo "Optimizing RAID Arrays..."
>> cd /sys/block
>> DISKS=$(/bin/ls -1d sd[e-j])
>> echo "Setting read-ahead to 32 MiB for /dev/md0"
>> blockdev --setra 65536 /dev/md0
>> echo "Setting stripe_cache_size to 16 MiB for /dev/md0"
>> echo 16384 > /sys/block/md0/md/stripe_cache_size
>>
>
> If you set the stripe_cache_size high enough you can strangle the
> system.  Do you really need 384MiB of raid cache?

The weird thing is, with md/RAID-5, I never had a problem.

Justin.

