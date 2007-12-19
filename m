Return-Path: <linux-kernel-owner+w=401wt.eu-S1757237AbXLSTio@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757237AbXLSTio (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 14:38:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753672AbXLSTig
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 14:38:36 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:39821 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753126AbXLSTif (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 14:38:35 -0500
Date: Wed, 19 Dec 2007 20:38:34 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Jiri Slaby <jirislaby@gmail.com>
cc: ManojKwal <kmanojcse23@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: kobject_add failed for tts/0 (-13)-EACCES
In-Reply-To: <4769702D.90000@gmail.com>
Message-ID: <Pine.LNX.4.64.0712192033510.5524@fbirervta.pbzchgretzou.qr>
References: <14384475.post@talk.nabble.com> <4769702D.90000@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Dec 19 2007 20:25, Jiri Slaby wrote:
>On 12/18/2007 06:39 AM, ManojKwal wrote:
>> io scheduler cfq registered
>> serial_dtsp_init()
>> serial_dtsp_probe()
>> dtsp_uart.0: tts/0 at MMIO 0x20200000 (irq = 2) is a ttyS
>> kobject_add failed for tts/0 (-13)
>> [<c001d918>] (dump_stack+0x0/0x14) from [<c00c9d74>]
>> (kobject_add+0x168/0x1a4)
>> [<c00c9c0c>] (kobject_add+0x0/0x1a4) from [<c00eab84>]
>> (class_device_add+0x88/0x420)
>>  r8 = C0114240  r7 = 0CC00040  r6 = C3E11BC0  r5 = C0323440
>>  r4 = C0323440 
>> [<c00eaafc>] (class_device_add+0x0/0x420) from [<c00eaf38>]
>> (class_device_register+0x1c/0x20)
>> [<c00eaf1c>] (class_device_register+0x0/0x20) from [<c00eafc8>]
>> (class_device_create+0x8c/0xc4)
>>  r4 = C0323440 
>> [<c00eaf3c>] (class_device_create+0x0/0xc4) from [<c00d0ef0>]
>> (tty_register_device+0xc8/0xe8)
>> [<c00d0e28>] (tty_register_device+0x0/0xe8) from [<c00e500c>]
>> (uart_add_one_port+0x22c/0x2a0)
>>  r7 = C011FAE4  r6 = 00000002  r5 = 00000000  r4 = 60000013
>> [<c00e4de0>] (uart_add_one_port+0x0/0x2a0) from [<c00e6a9c>]
>> (serial_dtsp_probe+0x40/0x60)
>
>Actually this is the first time google sees this function name. Where's that
>kernel from?
>
And tts/0 looks quite devfs-era -- and, what's more, I can image that in that
era, kobject does not yet handle '/' in paths (but I may be wrong - Kay
Sievers should know better as the issue recently turned up wrt. MD).
