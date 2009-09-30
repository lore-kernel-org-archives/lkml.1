Return-Path: <linux-kernel-owner+w=401wt.eu-S1754146AbZI3KWk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754146AbZI3KWk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 06:22:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753921AbZI3KWk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 06:22:40 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:52793 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753086AbZI3KWj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 06:22:39 -0400
Message-ID: <4AC3316F.4080200@pobox.com>
Date: Wed, 30 Sep 2009 06:22:39 -0400
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Zdenek Kabelac <zdenek.kabelac@gmail.com>
CC: linux-ide@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: WARNING: at drivers/ata/libata-core.c:5027 ata_qc_complete+0x200/0x210()
References: <c4e36d110909170213v61c61c94m3b4b3270333dafcc@mail.gmail.com> <c4e36d110909300233u6f949058j82a28b05644fe265@mail.gmail.com>
In-Reply-To: <c4e36d110909300233u6f949058j82a28b05644fe265@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/30/2009 05:33 AM, Zdenek Kabelac wrote:
> 2009/9/17 Zdenek Kabelac<zdenek.kabelac@gmail.com>:
>> Hi
>>
>> Somewhere during recent merge commits this message started to appear
>> in my qemu kvm guest
>> (already present with some 2.6.31-040xxx commit)
>>
>> Is this fault of kvm emulation ?
>>
>>
>> WARNING: at drivers/ata/libata-core.c:5027 ata_qc_complete+0x200/0x210()
>> Hardware name:
>> Modules linked in:
>> Pid: 167, comm: ata/0 Not tainted 2.6.31-05317-ged0ecd1 #42
>> Call Trace:
>>   [<ffffffff81051ddb>] warn_slowpath_common+0x7b/0xc0
>>   [<ffffffff81051e34>] warn_slowpath_null+0x14/0x20
>>   [<ffffffff81323690>] ata_qc_complete+0x200/0x210
>>   [<ffffffff81330243>] ata_do_link_abort+0xf3/0x110
>>   [<ffffffff81330270>] ata_port_abort+0x10/0x20
>>   [<ffffffff813302af>] ata_port_freeze+0x2f/0x50
>>   [<ffffffff81334101>] ata_hsm_qc_complete+0x131/0x140
>>   [<ffffffff81335347>] ata_sff_hsm_move+0x197/0x760
>>   [<ffffffff8125891a>] ? delay_tsc+0x8a/0xe0
>>   [<ffffffff81335ca0>] ? ata_pio_task+0x0/0x120
>>   [<ffffffff81335ca0>] ? ata_pio_task+0x0/0x120
>>   [<ffffffff81335cd7>] ata_pio_task+0x37/0x120
>>   [<ffffffff8106f88a>] worker_thread+0x21a/0x400
>>   [<ffffffff8106f839>] ? worker_thread+0x1c9/0x400
>>   [<ffffffff81075a20>] ? autoremove_wake_function+0x0/0x40
>>   [<ffffffff8106f670>] ? worker_thread+0x0/0x400
>>   [<ffffffff810755f6>] kthread+0x96/0xa0
>>   [<ffffffff8100d29a>] child_rip+0xa/0x20
>>   [<ffffffff81041574>] ? finish_task_switch+0x74/0xf0
>>   [<ffffffff8140d14b>] ? _spin_unlock_irq+0x3b/0x60
>>   [<ffffffff8100cc00>] ? restore_args+0x0/0x30
>>   [<ffffffff81075560>] ? kthread+0x0/0xa0
>>   [<ffffffff8100d290>] ? child_rip+0x0/0x20
>>
>>
>
> Just confirmation that WARNING trace is still present with 2.6.32-rc1.

hrm, I thought we'd fixed that with 4dc738ed2adf28f62f46dd53ef700a51603777f7

	Jeff



