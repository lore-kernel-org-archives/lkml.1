Return-Path: <linux-kernel-owner+w=401wt.eu-S1752053AbZHZH7h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752053AbZHZH7h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 03:59:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750894AbZHZH7g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 03:59:36 -0400
Received: from newsmtp5.atmel.com ([204.2.163.5]:61328 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750803AbZHZH7g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 03:59:36 -0400
X-Greylist: delayed 2357 seconds by postgrey-1.27 at vger.kernel.org; Wed, 26 Aug 2009 03:59:36 EDT
Message-ID: <9E4512BFD9E74B73A1118E4B0EDE04E9@aeglos>
From: "Ulf Samuelsson" <ulf.samuelsson@atmel.com>
To: "Robert Emanuele" <rob@emanuele.us>,
       <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
References: <9f53b4330908251727q1bc1accfk12a9a8d25407791@mail.gmail.com><0F5F73E36031FD46AD3F2E6948F0C0A00188E074@frimb01.corp.atmel.com> <9f53b4330908252124n168bd094k84f2691ec1a0a0ea@mail.gmail.com>
Subject: Re: ARM Git Tree (at91sam9g45 patches)
Date: Wed, 26 Aug 2009 08:43:23 +0200
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2900.5843
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.5579
X-OriginalArrivalTime: 26 Aug 2009 06:57:39.0219 (UTC) FILETIME=[80035E30:01CA261A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have done my best to port those patches to 2.6.30.2.
The result is available in the openembedded git.
(www.openembedded.org)
It is not available yet in the main development tree,
you have to download the main git, and then
use my private branch
    origin/ulf/linux-2.6.30.2...

I generated some new stuff, for the SAM9G45 which has not been
submitted anywhere, including Audio initialization of the SAM9G45.
I have been able to play an MP3 file with my board.

The boot cannot find /dev/fb0 right now.
I suspect I have a flaky board.
It had problems initializing the screen before,
XWindows reported everything OK, but I only saw
a black screen with some moving white screens
indicating no sync.
A power cycle a little later cause X11+Gnome to boot.
At that time I did not have any touchscreen nor working USB
so I had to way to pass the initial user configuration.

Needs some investigating.
Also added init code for the touchscreen, but this fails.
No trace of this in the bootlog, and no /dev/input/touchscreen0
available.

I also put the same patches into the buildroot build system
Again, you have to use a private branch.

git://git.busybox.net/~ulf/git/atmel-2009-08-rc2

Another important fix is that the AT91bootstrap provides a
working Rom Code Replacement.bin.
The one that has been on the Atmel home page is (was) broken.
I pointed this out last week so they may have changed it by now.
It is a bad idea to program the ROM Code replacement into
dataflash.
Much better to program it into the EEPROM.




If anyone wants to try with other chips, beware.
I have only tested with the SAM9263EK booting from dataflash
and the SAM9G45EKES.



Best Regards
Ulf Samuelsson

Subject: Re: ARM Git Tree (at91sam9g45 patches)


Thank you for pointing me towards those patches.  I've been looking at
those.  Some of the work I have is with the 2.6.29 and 2.6.30 kernel
versions.  I was wondering if there were any trees or patchsets
against those versions.

Thanks,

Rob

On Tue, Aug 25, 2009 at 6:15 PM, Xu, Hong<Hong.Xu@atmel.com> wrote:
> Hi Robert,
> Actually Atmel has made experimental patch to support at91sam9g45-ekes 
> board and will push the changes to the upstream tree in the near future. I 
> suggest you have a look at
> http://www.linux4sam.org/twiki/bin/view/Linux4SAM/LinuxKernel#Linux4SAM_Experimental_Patches
>
> BR,
> Hong Xu
>> -----Original Message-----
>> From: linux-arm-kernel-bounces@lists.infradead.org
>> [mailto:linux-arm-kernel-bounces@lists.infradead.org] On Behalf Of Robert
>> Emanuele
>> Sent: 2009?8?26? 8:27
>> To: linux-arm-kernel@lists.infradead.org
>> Cc: linux-kernel@vger.kernel.org
>> Subject: ARM Git Tree (at91sam9g45 patches)
>>
>> Greetings,
>>
>> I'm working with the Atmel at91sam9g45-ekes board which is new. I was
>> wondering if there was a git tree with the current ARM patches that
>> contains the at91sam9g45 code? Russell lists "Applied" patches at
>> http://www.arm.linux.org.uk/developer/patches/ . Where are these
>> applied to? If there isn't a tree, is there an elegant way to get the
>> latest patch sets that I could apply to Linus's tree?
>>
>> Thank you,
>>
>> Rob
>>
>> _______________________________________________
>> linux-arm-kernel mailing list
>> linux-arm-kernel@lists.infradead.org
>> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
>

_______________________________________________
linux-arm-kernel mailing list
linux-arm-kernel@lists.infradead.org
http://lists.infradead.org/mailman/listinfo/linux-arm-kernel


