Return-Path: <linux-kernel-owner+w=401wt.eu-S1753511AbZDMS22@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753511AbZDMS22 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 14:28:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752243AbZDMS2Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 14:28:16 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:51457 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752139AbZDMS2P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 14:28:15 -0400
Date: Mon, 13 Apr 2009 20:27:46 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jeff Garzik <jeff@garzik.org>, Peter Oruba <peter.oruba@amd.com>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       amd64-microcode@amd64.org, Andreas Herrmann <andreas.herrmann3@amd.com>
Cc: LKML <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: microcode driver newly spews warnings
Message-ID: <20090413182746.GA9954@elte.hu>
References: <49E38331.3090808@garzik.org> <49E38393.8000700@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49E38393.8000700@garzik.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


(added Cc:s)

* Jeff Garzik <jeff@garzik.org> wrote:

> Jeff Garzik wrote:
>>
>> Kernel: 2.6.30-rc1-00306-g8371f87
>> Hardware: ICH10 x86-64
>>
>> This is a regression from 2.6.29.  Microcode spews the following 
>> WARNING multiple times during boot:
>>
>>> ------------[ cut here ]------------
>>> WARNING: at fs/sysfs/group.c:138 sysfs_remove_group+0xeb/0xf0()
>>> Hardware name:         sysfs group ffffffffa0209700 not found for  
>>> kobject 'cpu0'
>>> Modules linked in: microcode(-) kvm_intel kvm uinput sr_mod i2c_i801  
>>> cdrom i2c_c
>>> ore ata_generic sg firewire_ohci snd_hda_codec_realtek pata_marvell  
>>> snd_hda_inte
>>> l snd_hda_codec snd_pcm_oss snd_mixer_oss snd_pcm snd_page_alloc  
>>> e1000e ahci lib
>>> ata sd_mod scsi_mod crc_t10dif ext3 jbd uhci_hcd ehci_hcd [last  
>>> unloaded: scsi_w
>>> ait_scan]
>>> Pid: 2161, comm: rmmod Not tainted 2.6.30-rc1-00306-g8371f87 #1
>>> Call Trace:
>>>  [<ffffffff80241a2f>] warn_slowpath+0xaf/0x110
>>>  [<ffffffff80324046>] ? sysfs_addrm_finish+0x1a6/0x250
>>>  [<ffffffff802294d9>] ? __phys_addr+0x9/0x50
>>>  [<ffffffff802294d9>] ? __phys_addr+0x9/0x50
>>>  [<ffffffff8036c49d>] ? kobject_release+0x5d/0xa0
>>>  [<ffffffff802ba7c2>] ? __vunmap+0x12/0x110
>>>  [<ffffffff80325a8b>] sysfs_remove_group+0xeb/0xf0
>>>  [<ffffffffa0207468>] mc_sysdev_remove+0x38/0x50 [microcode]
>>>  [<ffffffff803fc2f8>] sysdev_driver_unregister+0x68/0xa0
>>>  [<ffffffffa0207eed>] microcode_exit+0x39/0x65 [microcode]
>>>  [<ffffffff8026c511>] sys_delete_module+0x191/0x250
>>>  [<ffffffff8020b5bb>] system_call_fastpath+0x16/0x1b
>>> ---[ end trace 0a72bfd99e89dde6 ]---
>>> ------------[ cut here ]------------
>>
>>
>> Full dmesg and lspci attached.
>
> Whoops, forgot kernel config.  Attached.
>
> 	Jeff
>
>
>


