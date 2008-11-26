Return-Path: <linux-kernel-owner+w=401wt.eu-S1753391AbYKZIjS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753391AbYKZIjS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 03:39:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751157AbYKZIjD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 03:39:03 -0500
Received: from 166-70-238-42.ip.xmission.com ([166.70.238.42]:43403 "EHLO
	ns1.wolfmountaingroup.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750797AbYKZIjA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 03:39:00 -0500
Message-ID: <54293.166.70.238.44.1227685993.squirrel@webmail.wolfmountaingroup.com>
In-Reply-To: <1227683627.3145.5.camel@LiNuX>
References: <46697.166.70.238.44.1227679338.squirrel@webmail.wolfmountaingroup.com>
    <1227683627.3145.5.camel@LiNuX>
Date: Wed, 26 Nov 2008 00:53:13 -0700 (MST)
Subject: Re: ndiswrapper 1.54-2.6.27 released
From: jmerkey@wolfmountaingroup.com
To: "Justin P. Mattock" <justinmattock@gmail.com>
Cc: jmerkey@wolfmountaingroup.com, linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.6
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Tue, 2008-11-25 at 23:02 -0700, jmerkey@wolfmountaingroup.com wrote:
>>
>> ndiswrapper with the 2.6.27 breakage corrected.  The current maintainers
>> have not put out a release for 2.6.27 or later kernels, so I went ahead
>> and fixed it for 2.6.27.
>>
>> ftp://ftp.wolfmountaingroup.org/pub/ndiswrapper/ndiswrapper-1.54-2.6.27.7.tar.gz
>>
>> Linux wireless drivers still do not work on most of my laptops and USB
>> wireless devices due to lack of firmware drivers and other problems with
>> native Linux wireless.  Anyone else with busted laptop wireless who need
>> ndiswrapper might as well be able to get it since the maintainers have
>> not
>> posted recent releases for recent kernels.
>>
>>
>> Jeff
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel"
>> in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>
> Cool; glad to see it working
> with the latest kernel.
> BTW who is the author
> of this patch?(this has baffled me for sometime);
> http://www.slackware.com/~alien/slackbuilds/ndiswrapper/build/ndiswrapper_kernel_2.6.27.patch
> (not to imped you in anyway);
>
> regards;
>
> --
> Justin P. Mattock <Justinmattock@gmail.com>
>
>

I have no idea, but the patch you pointed me to is not conditionalized
with #if {kernel version >= 2.6.27} <insert info struct> #else <leave as
in 1.53> #end and will only work on 2.6.27.7.  The version I posted is
backwards compatible with 2.6.27 backwards to earlier releases.


Jeff

