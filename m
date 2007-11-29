Return-Path: <linux-kernel-owner+w=401wt.eu-S933928AbXK2UTn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933928AbXK2UTn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 15:19:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759259AbXK2UTd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 15:19:33 -0500
Received: from coyote.holtmann.net ([217.160.111.169]:45059 "EHLO
	mail.holtmann.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758979AbXK2UTc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 15:19:32 -0500
Cc: bgsmith@bendcable.com, "BlueZ users" <bluez-users@lists.sourceforge.net>,
       LKML <linux-kernel@vger.kernel.org>
Message-Id: <6EE8D368-C303-400A-B4FE-811228391639@holtmann.org>
From: Marcel Holtmann <marcel@holtmann.org>
To: Dave Young <hidave.darkstar@gmail.com>
In-Reply-To: <a8e1da0711290006x4bd3cc45x1ae8dcaa9c0ab462@mail.gmail.com>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v915)
Subject: Re: [Bluez-users] Lost connections - mouse and keyboard
Date: Thu, 29 Nov 2007 21:19:03 +0100
References: <1196009038.14897.6.camel@pico> <1196056187.4217.54.camel@aeonflux> <1196305426.23029.12.camel@pico> <a8e1da0711290006x4bd3cc45x1ae8dcaa9c0ab462@mail.gmail.com>
X-Mailer: Apple Mail (2.915)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dave,

>> apparently does manage bluetooth devices using bluetooth-input- 
>> service.
>> I  still have the problem of the devices disappearing if idle for too
>> long such as when i lock the desktop or log out for  a long period.
>> Sometimes I can re-enable the devices, but sometimes I cannot.   
>> This is
>> frustrating.
>>
>> I see a the following several times in the system log if i restart
>> bluetooth:
>> Nov 28 18:53:39 pico kernel: WARNING: at drivers/hid/hid-core.c:784
>> implement() (Tainted: P       )
>> Nov 28 18:53:39 pico kernel:
>> Nov 28 18:53:39 pico kernel: Call Trace:
>> Nov 28 18:53:39 pico kernel:  [<ffffffff811d8549>] hid_output_report
>> +0x1c5/0x232
>> Nov 28 18:53:39 pico kernel:  [<ffffffff811ddaf1>] hid_submit_ctrl
>> +0x60/0x24b
>> Nov 28 18:53:39 pico kernel:  [<ffffffff811dde45>]  
>> usbhid_submit_report
>> +0x169/0x19e
>> Nov 28 18:53:39 pico kernel:  [<ffffffff811e030b>] hiddev_ioctl
>> +0x368/0x919
>> Nov 28 18:53:39 pico kernel:  [<ffffffff810f54c5>] inode_has_perm
>> +0x65/0x72
>> Nov 28 18:53:39 pico kernel:  [<ffffffff81120c17>] __up_read 
>> +0x19/0x7f
>> Nov 28 18:53:39 pico kernel:  [<ffffffff8125eecc>] do_page_fault
>> +0x490/0x7e4
>> Nov 28 18:53:39 pico kernel:  [<ffffffff810a7399>] do_ioctl+0x55/0x6b
>> Nov 28 18:53:39 pico kernel:  [<ffffffff810a75f2>] vfs_ioctl 
>> +0x243/0x25c
>> Nov 28 18:53:39 pico kernel:  [<ffffffff810a7664>] sys_ioctl 
>> +0x59/0x79
>> Nov 28 18:53:39 pico kernel:  [<ffffffff8100bd45>] tracesys+0xd5/0xda
>>
>
> Does bluetooth input devices have something to do with usbhid? I don't
> know, perhaps this is another problem in kernel.

in case you have a HID proxy dongle the usbhid driver can be involved.  
And since this is hiddev, then it will be caused by the hid2hci program.

Regards

Marcel

