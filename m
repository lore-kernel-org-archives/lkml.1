Return-Path: <linux-kernel-owner+w=401wt.eu-S1751648AbZCNEkx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751648AbZCNEkx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Mar 2009 00:40:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751195AbZCNEkn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Mar 2009 00:40:43 -0400
Received: from vms173001pub.verizon.net ([206.46.173.1]:32514 "EHLO
	vms173001pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751116AbZCNEkm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Mar 2009 00:40:42 -0400
MIME-version: 1.0
Content-transfer-encoding: 8BIT
Content-disposition: inline
Content-type: text/plain; charset=iso-8859-1
From: Gene Heskett <gene.heskett@gmail.com>
Organization: Organization? very little
To: Yinghai Lu <yinghai@kernel.org>
Subject: Re: New ASUS 1701 bios for M2N SLI DELUXE
Date: Sat, 14 Mar 2009 00:40:18 -0400
User-Agent: KMail/1.11.0 (Linux/2.6.29-rc8; KDE/4.2.0; i686; ; )
Cc: Robert Hancock <hancockrwd@gmail.com>, Robin.Laing@drdc-rddc.gc.ca,
       LKML <linux-kernel@vger.kernel.org>,
       David Newall <davidn@davidnewall.com>
References: <200903131642.54925.gene.heskett@gmail.com>
 <49BB172D.5060609@gmail.com>
 <86802c440903132126w3738533dn8db7302f202dc4be@mail.gmail.com>
In-reply-to: <86802c440903132126w3738533dn8db7302f202dc4be@mail.gmail.com>
Message-id: <200903140040.18740.gene.heskett@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 14 March 2009, Yinghai Lu wrote:
>On Fri, Mar 13, 2009 at 7:32 PM, Robert Hancock <hancockrwd@gmail.com> wrote:
>> Gene Heskett wrote:
>>> Hi Robin, David and lkml list;
>>>
>>> I said I would report.
>>>
>>> I just reinstalled the 1502 version bios after spending the last 2 days
>>> trying to get an hours worth of uptime without an oops.  Gave up.
[...]
>> That's not an oops, it's a warning. Those do normally taint the kernel. I
>> don't think this should really be a WARN, IMHO, as it's a BIOS bug and not
>> the kernel's fault, and it's fixed up the problem. CCing Yinghai Lu, which
>> it looks like wrote this warning.
>
>need to tone down the warning?

Yes, please & thank you.  And maybe look at the tests that determine its bad 
and has to be fixed.  IMO, something fubar in the later bios versions is 
getting by that test.  Results are extremely unstable with either the 1604beta 
or 1701 versions of that bios.  1502 does trigger the fix, and the fix is pure 
gold.

>>> So based on that, I'll now go build a 2.6.29-rc8 and see how that runs.
>>>
>>> The biggest problem with the 2.6.29 series is that apparently, for
>>> security reasons, they are now doing a PHY disable in a graceful
>>> shutdown, which none of the previous kernels knows how to re-enable.
>>>
>>> So to reboot to the 2.6.28.7 stable, you have to use the front panel
>>> reset button to reboot or you will not have any onboard ethernet until
>>> you do a full, pull ALL the power plugs for at least 30 seconds (I go
>>> make a cup of tea, about 3 minutes) to reset the PHY's back to
>>> operational status. TBT, the reset button is easier.
>>>
>>> Frankly, that seems like a thoroughly busted security idea, but I suppose
>>> we're stuck with it.
>>
>> I doubt it's for security reasons. Could be due to power management or
>> suspend/resume changes?
>
>what is nic? could be put in D3 somehow.
>
>YH

The nic's (2 of them) are in the motherboards MCP55 chipset according to what 
I have been told.

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
Mencken and Nathan's Ninth Law of The Average American:
	The quality of a champagne is judged by the amount of noise the
	cork makes when it is popped.

