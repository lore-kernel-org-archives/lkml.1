Return-Path: <linux-kernel-owner+w=401wt.eu-S1751143AbZLRMQS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751143AbZLRMQS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 07:16:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750967AbZLRMQR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 07:16:17 -0500
Received: from ns2.gothnet.se ([82.193.160.251]:12055 "EHLO
	GOTHNET-SMTP2.gothnet.se" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750844AbZLRMQQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 07:16:16 -0500
Message-ID: <4B2B727A.7020806@shipmail.org>
Date: Fri, 18 Dec 2009 13:15:54 +0100
From: =?ISO-8859-1?Q?Thomas_Hellstr=F6m?= <thomas@shipmail.org>
User-Agent: Thunderbird 2.0.0.17 (X11/20080926)
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Dave Airlie <airlied@gmail.com>, David Airlie <airlied@linux.ie>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, dri-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drm: convert drm_ioctl to unlocked_ioctl
References: <200912162217.09577.arnd@arndb.de>	<21d7e9970912171727i7576b1d9q1a8195ad884592a1@mail.gmail.com> <200912180916.27201.arnd@arndb.de>
In-Reply-To: <200912180916.27201.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-BitDefender-Scanner: Mail not scanned due to license constraints
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd Bergmann wrote:
> On Friday 18 December 2009, Dave Airlie wrote:
>   
>> This looks good, I've taken this and I've squashed
>> the generic pieces of your RFC into this (i.e.
>> I haven't modified the drivers, but just added the
>> flag to allow the ioctls to be unlocked if the driver
>> selects them).
>>
>> Do you think we should try and get this in soon,
>> its seems like it shouldn't have any regressions
>> unless we start switching drivers over.
>>     
>
> Well, since the patch should not change the behaviour
> of the drivers, it probably doesn't matter to users
> either way. However, it touches a number of places,
> which can break patches that others are working on,
> so maybe you should get it upstream at a point that
> has the least impact to developer (possibly now).
>
> Doing it now at least makes it easier to test
> moving drivers to unlocked operation.
>
> 	Arnd
>   

I'm very much for this as well.
Note that the vmwgfx driver has another (workaround-like) approach to 
achieve
unlocked driver ioctls, but it shouldn't be too hard to convert it.

/Thomas
> ------------------------------------------------------------------------------
> This SF.Net email is sponsored by the Verizon Developer Community
> Take advantage of Verizon's best-in-class app development support
> A streamlined, 14 day to market process makes app distribution fast and easy
> Join now and get one step closer to millions of Verizon customers
> http://p.sf.net/sfu/verizon-dev2dev 
> --
> _______________________________________________
> Dri-devel mailing list
> Dri-devel@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/dri-devel
>   



