Return-Path: <linux-kernel-owner+w=401wt.eu-S1755107AbZCSCr7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755107AbZCSCr7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 22:47:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754572AbZCSCru
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 22:47:50 -0400
Received: from mail-ew0-f165.google.com ([209.85.219.165]:45364 "EHLO
	mail-ew0-f165.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753602AbZCSCrt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 22:47:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=mswFlSDOB/8SClTjrCCKloIHW4MwSHkKwfGN4zRz9cS24D2qwrymcYrSpZ7Q4E5eTE
         28NCLf3v7P76d9kdls0nHn1KI/4vWVeynKhjvbeRGsENQmZQzKOoFHTUq/72S9TryZmt
         gR5uNxGtjcT/vhTE/3YivJM+4vDOwwOOZhBpI=
MIME-Version: 1.0
In-Reply-To: <49C173EA.4030904@amcc.com>
References: <91b13c310903180551j4b86880cr269b01b58055febc@mail.gmail.com>
	 <49C173EA.4030904@amcc.com>
Date: Thu, 19 Mar 2009 10:47:44 +0800
Message-ID: <91b13c310903181947s6bdf50b7u323b5630a0ea5fce@mail.gmail.com>
Subject: Re: About [AMCC 460EX/canyonlands board] Synopsys DesignWare Cores 
	(DWC) SATA host driver
From: Cheng Renquan <crquan@gmail.com>
To: Feng Kan <fkan@amcc.com>, support@amcc.com
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 19, 2009 at 6:21 AM, Feng Kan <fkan@amcc.com> wrote:
> Hi RenQuan:
>
> We are aware of the issue, currently the sata is only supported up to
> 2.6.25.7. We are working on a patchable version
> to submit to main line.

Well, we want some new kernel features on amcc borads,
(squashfs/ubifs/layered fs/..) those are only in newer mainline
kernels, so please respond soon, thanks.

BTW, the author declared in drivers/ata/sata_dwc.c Mark Miesfeld
<mmiesfeld@amcc.com> seems not receive mail permanently, pruned here,
and please consider change another maintainer of that file.

>
> Thanks
> Feng Kan

Besides, here's some kernel panic message on 2.6.28.7,

NIP: c0195a18 LR: c01807a8 CTR: c01959ec
REGS: df82bb60 TRAP: 0300   Not tainted  (2.6.28.7-dirty)
MSR: 00029000 <EE,ME>  CR: 44008048  XER: 00000000
DEAR: 00000008, ESR: 00000000
TASK = df82c000[1] 'swapper' THREAD: df82a000
GPR00: c01807a8 df82bc10 df82c000 df92d588 00000002 df92d59c 4ebc7fe3 00000001
GPR08: 4ebc7fe3 00000000 c032f0b4 00000008 24008042 1005543c 1ffb1100 00000000
GPR16: 1000bd80 1000bda8 00000000 c0360000 00000000 c02c5934 c02c5918 c032f774
GPR24: c02c4ed0 00000000 df874950 df874950 00000002 df92d59c 00000002 df92d588
NIP [c0195a18] sata_dwc_scr_read+0x2c/0x88
LR [c01807a8] sata_scr_read+0x7c/0x90
Call Trace:
[df82bc10] [c0179664] scsi_sysfs_add_host+0x94/0xac (unreliable)
[df82bc20] [c01807a8] sata_scr_read+0x7c/0x90
[df82bc40] [c01807dc] sata_link_init_spd+0x20/0x238
[df82bc80] [c01851e4] ata_host_register+0x174/0x2e0
[df82bcc0] [c0185404] ata_host_activate+0xb4/0x124
[df82bcf0] [c0196974] sata_dwc_probe+0x334/0x52c
[df82bd60] [c0162f78] platform_drv_probe+0x20/0x30
[df82bd70] [c0161de0] driver_probe_device+0xb8/0x1e8
[df82bd90] [c0161fb4] __driver_attach+0xa4/0xa8
[df82bdb0] [c01612e4] bus_for_each_dev+0x5c/0x98
[df82bde0] [c0161be8] driver_attach+0x24/0x34
[df82bdf0] [c0161934] bus_add_driver+0x1d8/0x258
[df82be20] [c01621c4] driver_register+0x5c/0x158
[df82be40] [c01631d4] platform_driver_register+0xac/0xbc
[df82be50] [c030c0c0] sata_dwc_init+0x18/0x28
[df82be60] [c00013dc] do_one_initcall+0x38/0x19c
[df82bfd0] [c02f3168] kernel_init+0x88/0xf4
[df82bff0] [c000d5e4] kernel_thread+0x4c/0x68
Instruction dump:
4e800020 2b840004 9421fff0 7c0802a6 bfc10008 90010014 7c9e2378 7c7f1b78
419d0038 81230060 548b103a 7c0004ac <7c095c2c> 0c000000 4c00012c 90050000
---[ end trace e066981a4cd0462b ]---
Kernel panic - not syncing: Attempted to kill init!
Rebooting in 1 seconds..

-- 
Cheng Renquan (程任全), from Shenzhen, China
Samuel Beckett  - "Birth was the death of him."
