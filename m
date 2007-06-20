Return-Path: <linux-kernel-owner+w=401wt.eu-S1761985AbXFTHXQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761985AbXFTHXQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 03:23:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756775AbXFTHXF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 03:23:05 -0400
Received: from ug-out-1314.google.com ([66.249.92.170]:65059 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757495AbXFTHXD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 03:23:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=Uk/4k0C6YnuZV02GNlgcL3NNtb5FU3dMMdMI84iEIzzn3D/lF77Tp04SBCYc/m6jZrZkUm8W4OC9azY9Rm58mlD6FQqkf7/1++4NkeFZac+Ju+j9HljFj4ATTU6FomMZy1GUHAxGlHbKchaZyTjS6uzXRa4336AwtbYyglqqDug=
Message-ID: <4678D5DB.40609@gmail.com>
Date: Wed, 20 Jun 2007 09:23:07 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.4 (X11/20070604)
MIME-Version: 1.0
To: =?UTF-8?B?IkouQS4gTWFnYWxsw7NuIg==?= <jamagallon@ono.com>
CC: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
Subject: Re: 2.6.22-rc4-mm2
References: <20070606220313.8f7c1fab.akpm@linux-foundation.org>	<20070619155357.0741dd22@werewolf-wl> <20070619163400.3c51ac1e@werewolf-wl>
In-Reply-To: <20070619163400.3c51ac1e@werewolf-wl>
X-Enigmail-Version: 0.95.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

J.A. Magallón napsal(a):
> On Tue, 19 Jun 2007 15:53:57 +0200, "J.A. Magallón" <jamagallon@ono.com> wrote:
> 
>> On Wed, 6 Jun 2007 22:03:13 -0700, Andrew Morton <akpm@linux-foundation.org> wrote:
>>
>>> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.22-rc4/2.6.22-rc4-mm2/
>>>
>>> - Basically a bugfixed version of 2.6.22-rc4-mm1.  None of the subsystem
>>>   trees were repulled, several bad patches were dropped, a few were fixed.
>>>
>> I get this warning when I plug a USB stick:
>>
> 
> Oops, forgot to say that this is not plain -rc4-mm2, but with CFS scheduler v17.
> CC'ing Ingo for if it is related...
> 
>> Jun 19 15:50:53 werewolf-wl kernel: usb 1-8: new high speed USB device using ehci_hcd and address 4
>> Jun 19 15:50:53 werewolf-wl kernel: usb 1-8: new device found, idVendor=090c, idProduct=1000
>> Jun 19 15:50:53 werewolf-wl kernel: usb 1-8: new device strings: Mfr=1, Product=2, SerialNumber=3
>> Jun 19 15:50:53 werewolf-wl kernel: usb 1-8: Product: USBDrive
>> Jun 19 15:50:53 werewolf-wl kernel: usb 1-8: Manufacturer: LG
>> Jun 19 15:50:53 werewolf-wl kernel: usb 1-8: SerialNumber: AA04012700012034
>> Jun 19 15:50:53 werewolf-wl kernel: usb 1-8: configuration #1 chosen from 1 choice
>> Jun 19 15:50:53 werewolf-wl kernel: scsi7 : SCSI emulation for USB Mass Storage devices
>> Jun 19 15:50:53 werewolf-wl kernel: usb-storage: device found at 4
>> Jun 19 15:50:53 werewolf-wl kernel: usb-storage: waiting for device to settle before scanning
>> Jun 19 15:50:58 werewolf-wl kernel: WARNING: at drivers/usb/core/urb.c:293 usb_submit_urb()

Does this help?
http://lkml.org/lkml/2007/6/7/197

regards,
-- 
http://www.fi.muni.cz/~xslaby/            Jiri Slaby
faculty of informatics, masaryk university, brno, cz
e-mail: jirislaby gmail com, gpg pubkey fingerprint:
B674 9967 0407 CE62 ACC8  22A0 32CC 55C3 39D4 7A7E
