Return-Path: <linux-kernel-owner+w=401wt.eu-S1755059AbZHYOHm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755059AbZHYOHm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 10:07:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755038AbZHYOHl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 10:07:41 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:52412 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755004AbZHYOHl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 10:07:41 -0400
Subject: Re: PROBLEM: oops
From: Peter Zijlstra <peterz@infradead.org>
To: =?UTF-8?Q?Pawe=C5=82_Go=C5=82aszewski?= <blues@gda.pl>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <alpine.LNX.2.00.0908251515380.16876@fgnss.gnfx.tqn.cy>
References: <alpine.LNX.2.00.0908251515380.16876@fgnss.gnfx.tqn.cy>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 25 Aug 2009 16:06:46 +0200
Message-Id: <1251209206.7538.1159.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-08-25 at 15:55 +0200, Paweł Gołaszewski wrote:
> No matter which kernel I'm using (2.6.27 - 2.6.30) it crashes. Works for 
> few minutes and crashes. Even SysRq doesn't work.
> 
> Dunno how to trigger it on other machine than mine (I have two, both 
> affected). If more info is required - just ask.
> [...]
> [24483.211036] BUG: unable to handle kernel NULL pointer dereference at 00000058
> [24483.211144] IP: [<c081cf9a>] pick_next_task_fair+0x6a/0x100
> [24483.211247] Oops: 0000 [#1] SMP 
> [24483.211300] Modules linked in: netconsole configfs dm_mod softdog sch_sfq xfs raid10 uhci_hcd eepro100 ppdev parport_pc floppy parport ehci_hcd e100 piix i2c_piix4 thermal psmouse e1000 container ide_core usbcore mii button pcspkr serio_raw processor i2c_core sg evdev ext3 jbd mbcache scsi_wait_scan sd_mod crc_t10dif ata_piix libata dock aic7xxx sym53c8xx scsi_transport_spi scsi_mod raid1 md_mod
> [24483.211878] 
> [24483.211910] Pid: 1677, comm: md2_raid10 Not tainted (2.6.27.31-1 #1)

So you're saying .30 crashes at the exact same place?


