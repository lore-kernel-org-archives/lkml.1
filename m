Return-Path: <linux-kernel-owner+w=401wt.eu-S1755388AbXI0MKu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755388AbXI0MKu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2007 08:10:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751774AbXI0MKm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Sep 2007 08:10:42 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:42647 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751552AbXI0MKl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2007 08:10:41 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Norbert Preining <preining@logic.at>
Subject: Re: kernel Oops in ext3 code
Date: Thu, 27 Sep 2007 14:25:06 +0200
User-Agent: KMail/1.9.5
Cc: ext2-devel@lists.sourceforge.net,
       linux-kernel <linux-kernel@vger.kernel.org>
References: <20070927103122.GB27783@gamma.logic.tuwien.ac.at>
In-Reply-To: <20070927103122.GB27783@gamma.logic.tuwien.ac.at>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709271425.06470.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 27 September 2007 12:31, Norbert Preining wrote:
> Hi all!
> 
> (Please Cc)
> 
> kernel 2.6.23-rc6
> Debian/sid

Does it happen with 2.6.22?

> kernel ooops:
> 
> BUG: unable to handle kernel paging request at virtual address 1000004b
>  printing eip:
>  c0195bd3
>  *pde = 00000000
>  Oops: 0000 [#1]
>  PREEMPT SMP 
>  Modules linked in: vboxdrv binfmt_misc fuse coretemp hwmon gspca videodev v4l2_common v4l1_compat iwl3945 mac80211 tifm_7xx1 tifm_core joydev irda crc_ccitt 8250_pnp 8250 serial_core firewire_ohci firewire_core crc_itu_t
>  CPU:    0
>  EIP:    0060:[<c0195bd3>]    Not tainted VLI
>  EFLAGS: 00010206   (2.6.23-rc6 #1)
>  EIP is at ext3_discard_reservation+0x18/0x4d
>  eax: dff23800   ebx: 10000033   ecx: dfc15ec0   edx: ffffffff
>  esi: c0007c44   edi: 10000033   ebp: dfc2bef4   esp: dfc2beac
>  ds: 007b   es: 007b   fs: 00d8  gs: 0000  ss: 0068
>  Process kswapd0 (pid: 261, ti=dfc2a000 task=dfcac570 task.ti=dfc2a000)
>  Stack: c0007ba4 c0007c44 10000033 c019ec51 c0007c44 c0007d8c 0000002c c0171b1b 
>         0000002c c0007c44 c0007c4c c0171da2 c050880c 00000000 00000080 00000080 
>         c0171fb8 00000080 c0007e48 df9e3910 00007404 c03f5634 00000080 000000d0 
>  Call Trace:
>   [<c019ec51>] ext3_clear_inode+0x5d/0x76
>   [<c0171b1b>] clear_inode+0x6b/0xb9
>   [<c0171da2>] dispose_list+0x48/0xc9
>   [<c0171fb8>] shrink_icache_memory+0x195/0x1bd
>   [<c014f5ec>] shrink_slab+0xe2/0x159
>   [<c014f9a0>] kswapd+0x2d3/0x431
>   [<c0132520>] autoremove_wake_function+0x0/0x33
>   [<c014f6cd>] kswapd+0x0/0x431
>   [<c0132453>] kthread+0x38/0x5d
>   [<c013241b>] kthread+0x0/0x5d
>   [<c0104b73>] kernel_thread_helper+0x7/0x10
>   =======================
>  Code: 83 f8 01 19 c0 f7 d0 83 e0 08 89 42 0c 89 56 b4 5b 5e c3 57 56 89 c6 53 8b 58 b4 8b 80 a4 00 00 00 85 db 8b 80 78 01 00 00 74 30 <83> 7b 18 00 74 2a 8d b8 00 03 00 00 89 f8 e8 b8 ca 1a 00 83 7b 
>  EIP: [<c0195bd3>] ext3_discard_reservation+0x18/0x4d SS:ESP 0068:dfc2beac

Greetings,
Rafael
