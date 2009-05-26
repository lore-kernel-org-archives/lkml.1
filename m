Return-Path: <linux-kernel-owner+w=401wt.eu-S1755037AbZEZOAn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755037AbZEZOAn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 10:00:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753502AbZEZOAd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 10:00:33 -0400
Received: from yx-out-2324.google.com ([74.125.44.30]:54203 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752402AbZEZOAc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 10:00:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Io4e4x7kcrOIfAZwKlH4JHrfQUoCv61gWOSL6JA7KeDLL2bgx8CPeoco0sTjVVQ6Ml
         nh5+SwxgCjMo82uMeEDiMCAJyaCzAIXrzjudCX4/J38+Jkb12Xa8ahBf1Y4v29gzh7vy
         clGRztdIDFlDJEirXiWKOfzaBK5e1+ol96xpY=
MIME-Version: 1.0
In-Reply-To: <4A18FE80.30403@gmail.com>
References: <a44ae5cd0905230731q4df31403nd54ff9e2c496c77a@mail.gmail.com>
	 <200905232223.35780.rjw@sisk.pl> <4A18FE80.30403@gmail.com>
Date: Tue, 26 May 2009 10:00:32 -0400
Message-ID: <a44ae5cd0905260700x488f94a3i5f53f5137aff5b7@mail.gmail.com>
Subject: Re: 2.6.30=rc6=git6 -- ata_piix 0000:00:1f.2: DMA-API: device driver 
	maps memory from kernel text or rodata [addr=c0fff000]
From: Miles Lane <miles.lane@gmail.com>
To: Robert Hancock <hancockrwd@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
       linux-scsi <linux-scsi@vger.kernel.org>, Tejun Heo <tj@kernel.org>,
       "IDE/ATA development list" <linux-ide@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 24, 2009 at 4:00 AM, Robert Hancock <hancockrwd@gmail.com> wrote:
> Rafael J. Wysocki wrote:
>>
>> Adding CCs.
>>
>> On Saturday 23 May 2009, Miles Lane wrote:
>>>
>>> [  865.788574] WARNING: at lib/dma-debug.c:576
>>> check_for_illegal_area+0xdb/0x105()
>>> [  865.788585] Hardware name: 1000HE
>>> [  865.788596] ata_piix 0000:00:1f.2: DMA-API: device driver maps
>>> memory from kernel text or rodata [addr=c0fff000] [size=4096]
>>> [  865.788607] Modules linked in: sco bnep rfcomm l2cap pci_slot
>>> snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_hwdep
>>> snd_pcm_oss snd_mixer_oss snd_pcm snd_seq_dummy snd_seq_oss
>>> snd_seq_midi_event btusb snd_seq bluetooth snd_timer snd_seq_device
>>> ath9k snd soundcore snd_page_alloc atl1e
>>> [  865.788718] Pid: 1559, comm: mount.ntfs Not tainted 2.6.30-rc6-git6 #2
>>> [  865.788727] Call Trace:
>>> [  865.788745]  [<c10206f4>] warn_slowpath_common+0x65/0x7c
>>> [  865.788761]  [<c11666e2>] ? check_for_illegal_area+0xdb/0x105
>>> [  865.788777]  [<c102073f>] warn_slowpath_fmt+0x24/0x27
>>> [  865.788793]  [<c11666e2>] check_for_illegal_area+0xdb/0x105
>>> [  865.788811]  [<c1167629>] debug_dma_map_sg+0x10f/0x11b
>>> [  865.788829]  [<c121347e>] ata_qc_issue+0x1b0/0x233
>>> [  865.788848]  [<c1218cf0>] __ata_scsi_queuecmd+0x15a/0x1a7
>>> [  865.788864]  [<c11fde34>] ? scsi_done+0x0/0xd
>>> [  865.788879]  [<c12187d4>] ? ata_scsi_rw_xlat+0x0/0x1e9
>>> [  865.788895]  [<c1218dbe>] ata_scsi_queuecmd+0x45/0x73
>>> [  865.788909]  [<c11fde34>] ? scsi_done+0x0/0xd
>>> [  865.788925]  [<c11fdf6e>] scsi_dispatch_cmd+0x12d/0x165
>>> [  865.788941]  [<c1202253>] scsi_request_fn+0x299/0x3ca
>>> [  865.788956]  [<c10282bf>] ? del_timer+0x47/0x4e
>>> [  865.788974]  [<c11505b8>] __generic_unplug_device+0x26/0x29
>>> [  865.788990]  [<c11505ff>] generic_unplug_device+0x21/0x2f
>>> [  865.789006]  [<c11516c6>] blk_unplug+0x16/0x19
>>> [  865.789021]  [<c11516d4>] blk_backing_dev_unplug+0xb/0xd
>>> [  865.789038]  [<c10a57cf>] block_sync_page+0x24/0x28
>>> [  865.789053]  [<c1069728>] sync_page+0x38/0x41
>>> [  865.789068]  [<c106973a>] sync_page_killable+0x9/0x37
>>> [  865.789085]  [<c13ab475>] __wait_on_bit_lock+0x34/0x6f
>>> [  865.789099]  [<c1069731>] ? sync_page_killable+0x0/0x37
>>> [  865.789115]  [<c1069613>] __lock_page_killable+0x71/0x78
>>> [  865.789132]  [<c1030d9f>] ? wake_bit_function+0x0/0x37
>>> [  865.789147]  [<c1069642>] lock_page_killable+0x28/0x2b
>>> [  865.789162]  [<c106ad22>] generic_file_aio_read+0x315/0x493
>>> [  865.789183]  [<c108c36c>] do_sync_read+0xaa/0xe5
>>> [  865.789199]  [<c113181d>] ? file_has_perm+0x87/0xa1
>>> [  865.789216]  [<c1030d70>] ? autoremove_wake_function+0x0/0x2f
>>> [  865.789234]  [<c112e180>] ? security_file_permission+0xf/0x11
>>> [  865.789250]  [<c108c43c>] ? rw_verify_area+0x95/0xb6
>>> [  865.789265]  [<c108c2c2>] ? do_sync_read+0x0/0xe5
>>> [  865.789280]  [<c108ca03>] vfs_read+0x8d/0xea
>>> [  865.789296]  [<c108cab3>] sys_pread64+0x53/0x6b
>>> [  865.789313]  [<c1002c34>] syscall_call+0x7/0xb
>>> [  865.789325] ---[ end trace 1ec3ba9a74f5a8d5 ]---
>
> Well, this seems to tell us that somebody's apparently doing SCSI reads or
> writes using kernel addresses. Unfortunately it doesn't really tell us where
> this request came from. The stack trace occurred inside the mount.ntfs
> process.. could FUSE be doing something bad?
>
> Was anything strange happening on the machine when this showed up?
>

I have just hit this again with a build of 2.6.30-rc7.  I did not do
anything "unusual", but it might be helpful to know that this is
Ubuntu 9.10 (development) running with WUBI.  WUBI uses a file mounted
via loopback from an NTFS partition.  This file is ~10GB and contains
EXT3 root filesystem.

Any debugging suggestions?

Miles
