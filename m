Return-Path: <linux-kernel-owner+w=401wt.eu-S1764901AbXHHN7n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764901AbXHHN7n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 09:59:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756011AbXHHN7g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 09:59:36 -0400
Received: from mtiwmhc11.worldnet.att.net ([204.127.131.115]:59943 "EHLO
	mtiwmhc11.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753482AbXHHN7f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 09:59:35 -0400
Message-ID: <46B9CC44.8000207@lwfinger.net>
Date: Wed, 08 Aug 2007 08:59:32 -0500
From: Larry Finger <larry.finger@lwfinger.net>
User-Agent: Thunderbird 1.5.0.12 (X11/20070509)
MIME-Version: 1.0
To: Kay Sievers <kay.sievers@vrfy.org>
CC: Cornelia Huck <cornelia.huck@de.ibm.com>,
       David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org
Subject: Re: Error message from device_rename in drivers/base/core.c
References: <46B943D3.9020207@lwfinger.net>	 <20070807.213724.27783161.davem@davemloft.net>	 <20070808113359.71e77f49@gondolin.boeblingen.de.ibm.com>	 <46B9B5C6.2070100@lwfinger.net> <3ae72650708080646k4279e48boc3a77d6454c8d72d@mail.gmail.com>
In-Reply-To: <3ae72650708080646k4279e48boc3a77d6454c8d72d@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Kay Sievers wrote:
> On 8/8/07, Larry Finger <larry.finger@lwfinger.net> wrote:
>> I agree with you, but you and David can fight it out. While finding out where to ask/complain about
>> udev, I had a private communication with GregKH. He thinks that a patch to fix this has already been
>> pushed through Linus. As Linville's wireless-dev tree is a little behind, I'm waiting to see if it
>> gets fixed here by 2.6.23-rc3. If not, I'll talk to the udev/hotplug folks.
> 
> Hmm, I can not immediately see how udev could request the renaming to
> the same name:
> 
>   /* look if we want to change the name of the netif */
>   if (strcmp(udev->name, udev->dev->kernel) != 0) {
>     ...
>     retval = rename_netif(udev);
>     ...
>   }
> 
> What udev version is it and which distro and version?

My distro is openSUSE 10.2, which is fully patched/updated. According to YaST, I'm using version 
103-12 x86_64. My kernel is 2.6.23-rc2 from John Linville's git tree - I run bcm43xx-mac80211.

Larry


