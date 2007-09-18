Return-Path: <linux-kernel-owner+w=401wt.eu-S1758017AbXIRT10@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758017AbXIRT10 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 15:27:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753747AbXIRT1R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 15:27:17 -0400
Received: from terminus.zytor.com ([198.137.202.10]:49144 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753365AbXIRT1P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 15:27:15 -0400
Message-ID: <46F02688.8030507@zytor.com>
Date: Tue, 18 Sep 2007 12:27:04 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: mchan@broadcom.com, vda.linux@googlemail.com, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: bnx2 dirver's firmware images
References: <1190141114.9540.216.camel@dell>	<20070918.112337.74737433.davem@davemloft.net>	<46F01BDE.6020902@zytor.com> <20070918.122034.83625273.davem@davemloft.net>
In-Reply-To: <20070918.122034.83625273.davem@davemloft.net>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller wrote:
> From: "H. Peter Anvin" <hpa@zytor.com>
> Date: Tue, 18 Sep 2007 11:41:34 -0700
> 
>> David Miller wrote:
>>> I don't like it because it means people have to setup full initrd's
>>> in order to do network booting with such network cards.
>>>
>> klibc could help with that, if there is interest in exploring that
>> avenue again.
> 
> I appreciate the effort you put into klibc and the offer to
> make initrd's easier to build.
>
> But the point is that the initrd shouldn't be necessary in the first
> place.  There becomes zero point in building these drivers statically
> into the kernel, which many of us do specifically to avoid module
> loading, initrds, and all that fuss.  Because the driver is totally
> crippled even though it's been fully built into the main kernel image.
> 
> I mean, it's so incredibly stupid and makes kernel development that
> much more difficult.
> 
> Every new dependency, be it requiring initrd or something else,
> is one more barrier added to kernel development.
> 
> I really pine for the days where everything was so simple, and initrd
> and modules were the odd ball cases, most developers built everything
> into their kernel image.

Well, what I was referring to here, of course, was the initramfs
integrated in the kernel image, so it all comes out of the kernel build
tree and produces a single bootable image.  The fact that part of it
contains userspace code is in that way invisible.

That was kind of the point here, and the only reason for pushing klibc
into the kernel build tree at all.  Under the "distros use external
initrd anyway" school of thought, whatever libc used for that can be
external anyway.

	-hpa
