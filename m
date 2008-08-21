Return-Path: <linux-kernel-owner+w=401wt.eu-S1755498AbYHUEwy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755498AbYHUEwy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 00:52:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752147AbYHUEwq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 00:52:46 -0400
Received: from 166-70-238-42.ip.xmission.com ([166.70.238.42]:60308 "EHLO
	ns1.wolfmountaingroup.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751594AbYHUEwp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 00:52:45 -0400
Message-ID: <47238.166.70.238.46.1219292835.squirrel@webmail.wolfmountaingroup.com>
In-Reply-To: <20080820175054.0795eecb.akpm@linux-foundation.org>
References: <1749.69.2.248.210.1219253222.squirrel@webmail.wolfmountaingroup.com>
    <20080820175054.0795eecb.akpm@linux-foundation.org>
Date: Wed, 20 Aug 2008 22:27:15 -0600 (MDT)
Subject: Re: 2.6.27-rc3-git6 iwl3945 driver drops packets with WEP  enabled
From: jmerkey@wolfmountaingroup.com
To: "Andrew Morton" <akpm@linux-foundation.org>
Cc: jmerkey@wolfmountaingroup.com, linux-kernel@vger.kernel.org,
       linux-wireless@vger.kernel.org
User-Agent: SquirrelMail/1.4.6
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Wed, 20 Aug 2008 11:27:02 -0600 (MDT)
> jmerkey@wolfmountaingroup.com wrote:
>
>>
>> On an Acer 9410 laptop with dual core processors, the iwl3945 driver has
>> intermittment receiver lockup problems (stops receiving packets) using
>> the
>> Linux iwl3945 drivers with WEP encryption enbaled.  The adapter works
>> fine
>> without WEP or WPA.   If the same system is booted to Windows Vista
>> (which
>> takes about 15 minutes to boot because Vista is a fat slow pig) the
>> wireless drivers work fine with WEP under Vista on the same system.
>>
>> If the system copies the ndis .sys drivers and I build ndiswrapper
>> (which
>> has to be really hacked up to build on 2.6.27) and use the ndis drivers
>> on
>> 2.6.27-rc3 with a modified ndiswrapper, they work fine.
>>
>> I suspect the firmware or an interaction with the firmware settings
>> since
>> when the system is booted to Vista after running 2.6.27-rc3 with the
>> iwl3945 drivers, I have to power cycle the system periodically after
>> running the iwl3945 driver to get the drivers under Vista to work again,
>> but not always.
>>
>
> (cc linux-wireless)
>
> Was 2.6.26 OK?
>

No.  2.6.26 It was actually a little worse, and the git6 was an
improvement since I was at least able to get past DHCP and obtain an
address, after which is died.  The failure is the driver stops receiving
packets, and if you rmmod/modprobe (reload) the driver , then it will work
again and lock up immediately following 'dhclient <interface>'.   tcpdump
-n -i <if> will work hit or miss before the lockup.

Jeff

