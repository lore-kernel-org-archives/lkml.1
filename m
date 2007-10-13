Return-Path: <linux-kernel-owner+w=401wt.eu-S1761380AbXJMAy6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761380AbXJMAy6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 20:54:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757740AbXJMAyt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 20:54:49 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45549 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754667AbXJMAys (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 20:54:48 -0400
Date: Fri, 12 Oct 2007 17:54:12 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Greg Cormier" <gcormier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
Message-Id: <20071012175412.ba4931fd.akpm@linux-foundation.org>
In-Reply-To: <29a863790710101217g607b5425g6a3374c2be1d75a5@mail.gmail.com>
References: <29a863790710101217g607b5425g6a3374c2be1d75a5@mail.gmail.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Oct 2007 15:17:19 -0400
"Greg Cormier" <gcormier@gmail.com> wrote:

> I'd like to hop in on this, and add my similar problem. This is my
> first post so please excuse me if I'm doing something wrong.

Please cc linux-ide@vger.kernel.org on ide, sata and pata reports.

A "hard freeze" is fairly serious.

> I've been having issues recently (couple of weeks?) with my server. I
> have three WD5000YS (500gb) drives in RAID5, on an Asus A8N
> motherboard which is nForce 4. I've even RMA'd one of the drives, but
> now I'm thinking the drives are fine.
> 
> The drive seems to have issues under heavy to moderate IO. I unmounted
> my raid, and forced an e2fsck. e2fsck didn't even print anything out,
> I got this.
> 
> Oct 10 14:50:40 zeus kernel: ata3: EH in ADMA mode, notifier 0x0
> notifier_error 0x0 gen_ctl 0x1501000 status 0x400 next cpb count 0x0
> next cpb idx 0x0
> Oct 10 14:50:40 zeus kernel: ata3: CPB 0: ctl_flags 0x1f, resp_flags 0x2
> Oct 10 14:50:40 zeus kernel: ata3: timeout waiting for ADMA IDLE, stat=0x400
> Oct 10 14:50:40 zeus kernel: ata3: timeout waiting for ADMA LEGACY, stat=0x400
> Oct 10 14:50:40 zeus kernel: ata3.00: exception Emask 0x0 SAct 0x1
> SErr 0x1c00000 action 0x2 frozen
> Oct 10 14:50:40 zeus kernel: ata3.00: cmd
> 61/08:00:bf:4b:38/00:00:3a:00:00/40 tag 0 cdb 0x0 data 4096 out
> Oct 10 14:50:40 zeus kernel:          res
> 40/00:f2:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
> Oct 10 14:50:40 zeus kernel: ata3: soft resetting port
> Oct 10 14:50:40 zeus kernel: ata3: SATA link up 3.0 Gbps (SStatus 123
> SControl 300)
> Oct 10 14:50:40 zeus kernel: ata3.00: configured for UDMA/133
> Oct 10 14:50:40 zeus kernel: ata3: EH complete
> Oct 10 14:50:40 zeus kernel: sd 2:0:0:0: [sdb] 976773168 512-byte
> hardware sectors (500108 MB)
> Oct 10 14:50:40 zeus kernel: sd 2:0:0:0: [sdb] Write Protect is off
> Oct 10 14:50:40 zeus kernel: sd 2:0:0:0: [sdb] Write cache: enabled,
> read cache: enabled, doesn't support DPO or FUA
> Oct 10 14:51:40 zeus kernel: ata3: EH in ADMA mode, notifier 0x0
> notifier_error 0x0 gen_ctl 0x1501000 status 0x400 next cpb count 0x0
> next cpb idx 0x0
> Oct 10 14:51:40 zeus kernel: ata3: CPB 0: ctl_flags 0x1f, resp_flags 0x2
> Oct 10 14:51:40 zeus kernel: ata3: timeout waiting for ADMA IDLE, stat=0x400
> Oct 10 14:51:40 zeus kernel: ata3: timeout waiting for ADMA LEGACY, stat=0x400
> Oct 10 14:51:40 zeus kernel: ata3.00: exception Emask 0x0 SAct 0x1
> SErr 0x400000 action 0x2 frozen
> Oct 10 14:51:40 zeus kernel: ata3.00: cmd
> 61/08:00:bf:4b:38/00:00:3a:00:00/40 tag 0 cdb 0x0 data 4096 out
> Oct 10 14:51:40 zeus kernel:          res
> 40/00:f2:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
> Oct 10 14:51:41 zeus kernel: ata3: soft resetting port
> Oct 10 14:51:41 zeus kernel: ata3: SATA link up 3.0 Gbps (SStatus 123
> SControl 300)
> Oct 10 14:51:41 zeus kernel: ata3.00: configured for UDMA/133
> Oct 10 14:51:41 zeus kernel: ata3: EH complete
> Oct 10 14:51:41 zeus kernel: sd 2:0:0:0: [sdb] 976773168 512-byte
> hardware sectors (500108 MB)
> Oct 10 14:51:41 zeus kernel: sd 2:0:0:0: [sdb] Write Protect is off
> Oct 10 14:51:41 zeus kernel: sd 2:0:0:0: [sdb] Write cache: enabled,
> read cache: enabled, doesn't support DPO or FUA
> Oct 10 14:52:19 zeus kernel: device eth0 left promiscuous mode
> Oct 10 14:52:41 zeus kernel: ata3: EH in ADMA mode, notifier 0x0
> notifier_error 0x0 gen_ctl 0x1501000 status 0x400 next cpb count 0x0
> next cpb idx 0x0
> Oct 10 14:52:41 zeus kernel: ata3: CPB 0: ctl_flags 0x1f, resp_flags 0x2
> Oct 10 14:52:41 zeus kernel: ata3: timeout waiting for ADMA IDLE, stat=0x400
> Oct 10 14:52:41 zeus kernel: ata3: timeout waiting for ADMA LEGACY, stat=0x400
> Oct 10 14:52:41 zeus kernel: ata3.00: exception Emask 0x0 SAct 0x1
> SErr 0x400000 action 0x2 frozen
> Oct 10 14:52:41 zeus kernel: ata3.00: cmd
> 61/08:00:bf:4b:38/00:00:3a:00:00/40 tag 0 cdb 0x0 data 4096 out
> Oct 10 14:52:41 zeus kernel:          res
> 40/00:f2:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
> Oct 10 14:52:41 zeus kernel: ata3: soft resetting port
> Oct 10 14:52:42 zeus kernel: ata3: SATA link up 3.0 Gbps (SStatus 123
> SControl 300)
> Oct 10 14:52:42 zeus kernel: ata3.00: configured for UDMA/133
> Oct 10 14:52:42 zeus kernel: ata3: EH complete
> Oct 10 14:52:42 zeus kernel: sd 2:0:0:0: [sdb] 976773168 512-byte
> hardware sectors (500108 MB)
> Oct 10 14:52:42 zeus kernel: sd 2:0:0:0: [sdb] Write Protect is off
> Oct 10 14:52:42 zeus kernel: sd 2:0:0:0: [sdb] Write cache: enabled,
> read cache: enabled, doesn't support DPO or FUA
> 
> These errors have been happening on various .22 kernels, and this
> message is from the hot-off-the-press .23 kernel. This message is
> followed by a hard freeze.
> 
> I'm in the process of figuring out why netconsole isn't quite working,
> so hopefully I can provide more information soon. The server is
> currently frozen, when I get home I can perhaps provide more
> information? lspci?
> 
> Looks like another rebuild of the array when I get home.
> 
> 
> Thanks,
> Greg
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
