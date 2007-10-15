Return-Path: <linux-kernel-owner+w=401wt.eu-S1764756AbXJOM5a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764756AbXJOM5a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 08:57:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759947AbXJOM5W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 08:57:22 -0400
Received: from tac.ki.iif.hu ([193.6.222.43]:46988 "EHLO tac.ki.iif.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759855AbXJOM5W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 08:57:22 -0400
From: Ferenc Wagner <wferi@niif.hu>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: Re: RocketPort Linux driver errors on module reload
References: <bububu786234897832@pripojeni.net>
Date: Mon, 15 Oct 2007 14:57:18 +0200
In-Reply-To: <bububu786234897832@pripojeni.net> (Jiri Slaby's message of "Mon,
	15 Oct 2007 14:25:11 +0200 (CEST)")
Message-ID: <87k5pozgb5.fsf@tac.ki.iif.hu>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Slaby <jirislaby@gmail.com> writes:

>> -------------------- Start of forwarded message --------------------
>> From: Ferenc Wagner <wferi@niif.hu>
>> To: support@comtrol.co.uk
>> Subject: RocketPort Linux driver errors on module reload
>> Date: Fri, 12 Oct 2007 00:22:17 +0200
>> Message-ID: <87fy0hwaue.fsf@tac.ki.iif.hu>
>> 
>> [...]
>> However, if I remove the module from the kernel, and then insert it
>> again, lots of error messages result:
>> 
>> RocketPort device driver module, version 2.09, 12-June-2003
>> Comtrol PCI controller #0 ID 0x802 found in bus:slot:fn 0000:01:08.0 at address d800, 1 AIOP(s) (RocketPort UPCI 8 port w/external I/F)
>> Installing RocketPort UPCI 8 port w/external I/F, creating /dev/ttyR0 - 7
>> kobject_add failed for ttyR0 with -EEXIST, don't try to register things with the same name in the same directory.
>>  [<c01ccdb4>] kobject_shadow_add+0x156/0x188
>>  [<c01cd095>] kobject_set_name+0x2b/0x92
>>  [<c022d022>] device_add+0x87/0x50f
>>  [<c01cce24>] kobject_init+0x2f/0x3f
>>  [<c022da2c>] device_create+0x77/0x97
>>  [<c02154cb>] tty_register_device+0xb5/0xbd
>>  [<f8a130d3>] init_r_port+0x5f1/0x623 [rocket]
>>  [<c02409a9>] pci_read+0x29/0x2e
>>  [<f8b74ff7>] rp_init+0xff7/0x111a [rocket]
>>  [<c013fd38>] __link_module+0x0/0x1f
>>  [<c01421de>] sys_init_module+0x1470/0x15a9
>>  [<c01296a7>] __request_region+0x0/0x80
>>  [<c0103e12>] sysenter_past_esp+0x6b/0xa1
>>  =======================
>> And so on for each device.
>> 
>> However, the card seems to operate all right.  Still, the messages
>> suggest something isn't quite right and could use some fixing.  Hope
>> you can find the problem.
>
> Could you try the attached patch below?
> [...]

You are the man, Jiri!  That indeed fixes the problem.
Thank you very much.  What a turnaround...

Shouldn't Documentation/rocket.txt also be changed?  I'm not sure
whether that support email is still valid.
-- 
Regards,
Feri.
