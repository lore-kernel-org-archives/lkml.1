Return-Path: <linux-kernel-owner+w=401wt.eu-S1754388AbZIPB5p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754388AbZIPB5p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 21:57:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753047AbZIPB5n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 21:57:43 -0400
Received: from mail-yw0-f180.google.com ([209.85.211.180]:52597 "EHLO
	mail-yw0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752243AbZIPB5m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 21:57:42 -0400
X-Greylist: delayed 444 seconds by postgrey-1.27 at vger.kernel.org; Tue, 15 Sep 2009 21:57:42 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=v1+mW6a97FcsVDSnOxfWj2H+5QewdK8MIycMrpnzGeAntH6Mw6WIqeAFu1SLAVkBXE
         SCcWR5Ax2VYOecMmR5ExhZpDvuwqrt7UhgyJiy2tDBptwCr8JSG5osoORLI1PD/Zv6dr
         SAiJn7tvW/49P0ePN811iiBNbyLD54xhG9si4=
MIME-Version: 1.0
Date: Tue, 15 Sep 2009 21:50:21 -0400
Message-ID: <a44ae5cd0909151850y1f7bd385x4e7d323b7fcd3215@mail.gmail.com>
Subject: 2.6.31-git4 -- ATL1E 0000:03:00.0: DMA-API: device driver frees DMA 
	memory with wrong function [device address=0x0000000036b92802] [size=90 
	bytes] [mapped as single] [unmapped as page]
From: Miles Lane <miles.lane@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>, Jay Cliburn <jcliburn@gmail.com>,
       Chris Snook <chris.snook@gmail.com>, Jie Yang <jie.yang@atheros.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Resending.  The first time I was composing with HTML enabled.  Sorry.

[   25.059969] WARNING: at lib/dma-debug.c:816 check_unmap+0x383/0x55c()
[   25.059976] Hardware name: 1000HE
[   25.059984] ATL1E 0000:03:00.0: DMA-API: device driver frees DMA
memory with wrong function [device address=0x0000000036b92802]
[size=90 bytes] [mapped as single] [unmapped as page]
[   25.059992] Modules linked in: snd_hda_codec snd_pcm_oss
snd_mixer_oss snd_pcm snd_seq_dummy snd_seq_oss snd_seq_midi
snd_rawmidi snd_seq_midi_event uvcvideo snd_seq snd_timer
snd_seq_device videodev v4l1_compat ath9k rtc_cmos snd ath rtc_core
soundcore rtc_lib rng_core snd_page_alloc eeepc_laptop hid_logitech
usbhid ehci_hcd uhci_hcd atl1e usbcore
[   25.060026] Pid: 1465, comm: NetworkManager Not tainted 2.6.31-git4 #8
[   25.060026] Call Trace:
[   25.060026]  [<c102d19c>] warn_slowpath_common+0x65/0x7c
[   25.060026]  [<c11b01c8>] ? check_unmap+0x383/0x55c
[   25.060026]  [<c102d1e7>] warn_slowpath_fmt+0x24/0x27
[   25.060026]  [<c11b01c8>] check_unmap+0x383/0x55c
[   25.060026]  [<c11b04f9>] debug_dma_unmap_page+0x53/0x5b
[   25.060026]  [<f80efaa6>] T.896+0x42/0x4c [atl1e]
[   25.060026]  [<f80f06cc>] atl1e_intr+0x2b1/0x37c [atl1e]
[   25.060026]  [<c106d552>] handle_IRQ_event+0x55/0x10a
[   25.060026]  [<c106ecb7>] handle_edge_irq+0xa9/0xec
[   25.060026]  [<c106ec0e>] ? handle_edge_irq+0x0/0xec
[   25.060026]  <IRQ>  [<c1004152>] ? do_IRQ+0x44/0x97
[   25.060026]  [<c10032f5>] ? common_interrupt+0x35/0x3c
[   25.060026] ---[ end trace 5c0b2c80cbd34aa4 ]---
[   25.060026] Mapped at:
[   25.060026]  [<c11b079a>] debug_dma_map_page+0x53/0x115
[   25.060026]  [<f80ef1e1>] T.895+0x8c/0x97 [atl1e]
[   25.060026]  [<f80ef7e7>] atl1e_xmit_frame+0x5fb/0x878 [atl1e]
[   25.060026]  [<c12c9a37>] dev_hard_start_xmit+0x21f/0x2a5
[   25.060026]  [<c12d7cd7>] sch_direct_xmit+0x50/0x12a
