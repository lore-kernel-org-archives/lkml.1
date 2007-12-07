Return-Path: <linux-kernel-owner+w=401wt.eu-S1752604AbXLGIga@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752604AbXLGIga (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2007 03:36:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751144AbXLGIgU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Dec 2007 03:36:20 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:38826 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750952AbXLGIgT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2007 03:36:19 -0500
Date: Fri, 7 Dec 2007 09:36:18 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Nix <nix@esperi.org.uk>
cc: Justin Piszcz <jpiszcz@lucidpixels.com>, linux-kernel@vger.kernel.org,
       linux-raid@vger.kernel.org, apiszcz@solarrain.com
Subject: Re: Kernel 2.6.23.9 + mdadm 2.6.2-2 + Auto rebuild RAID1?
In-Reply-To: <877ijrynb3.fsf@hades.wkstn.nix>
Message-ID: <Pine.LNX.4.64.0712070935140.1262@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0712010614070.25643@p34.internal.lan>
 <Pine.LNX.4.64.0712011305250.30316@fbirervta.pbzchgretzou.qr>
 <87tzmxym73.fsf@hades.wkstn.nix> <Pine.LNX.4.64.0712061607420.19266@fbirervta.pbzchgretzou.qr>
 <877ijrynb3.fsf@hades.wkstn.nix>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Dec 7 2007 07:30, Nix wrote:
>On 6 Dec 2007, Jan Engelhardt verbalised:
>> On Dec 5 2007 19:29, Nix wrote:
>>>> On Dec 1 2007 06:19, Justin Piszcz wrote:
>>>>
>>>>> RAID1, 0.90.03 superblocks (in order to be compatible with LILO, if
>>>>> you use 1.x superblocks with LILO you can't boot)
>>>>
>>>> Says who? (Don't use LILO ;-)
>>>
>>>Well, your kernels must be on a 0.90-superblocked RAID-0 or RAID-1
>>>device. It can't handle booting off 1.x superblocks nor RAID-[56]
>>>(not that I could really hope for the latter).
>>
>> If the superblock is at the end (which is the case for 0.90 and 1.0),
>> then the offsets for a specific block on /dev/mdX match the ones for /dev/sda,
>> so it should be "easy" to use lilo on 1.0 too, no?
>
>Sure, but you may have to hack /sbin/lilo to convince it to create the
>superblock there at all. It's likely to recognise that this is an md
>device without a v0.90 superblock and refuse to continue. (But I haven't
>tested it.)
>
In that case, see above - move to a different bootloader.
