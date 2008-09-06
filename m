Return-Path: <linux-kernel-owner+w=401wt.eu-S1753430AbYIFKLb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753430AbYIFKLb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Sep 2008 06:11:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752435AbYIFKLW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Sep 2008 06:11:22 -0400
Received: from smtp239.poczta.interia.pl ([217.74.64.239]:3009 "EHLO
	smtp239.poczta.interia.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752301AbYIFKLV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Sep 2008 06:11:21 -0400
Date: Sat, 6 Sep 2008 12:18:16 +0200
From: Krzysztof Helt <krzysztof.h1@poczta.fm>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Nick Piggin <nickpiggin@yahoo.com.au>,
       Dave Airlie <airlied@linux.ie>, Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: 2.6.27-rc5-mm1: 3 WARN_ON dumps during boot (acpi +
 vmap_pte_range)
Message-Id: <20080906121816.e12ed118.krzysztof.h1@poczta.fm>
In-Reply-To: <20080905235014.fc31b2b0.akpm@linux-foundation.org>
References: <20080906084558.dff614d4.krzysztof.h1@poczta.fm>
	<20080905235014.fc31b2b0.akpm@linux-foundation.org>
X-Mailer: Sylpheed 2.4.3 (GTK+ 2.11.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-EMID: c8e2b138
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 5 Sep 2008 23:50:14 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Sat, 6 Sep 2008 08:45:58 +0200 Krzysztof Helt <krzysztof.h1@poczta.fm> wrote:
> 
> This one I reported to Nick and Dave yesterday - no response as yet.

I wanted only to report. I cannot use the 2.6.27-rc5-mm1 because
the Xorg does not start (hangs) with it. My card is AGP so can it be
related to the warnings?

> 
> > ------------[ cut here ]------------
> > WARNING: at mm/vmalloc.c:105 vmap_pte_range+0xcb/0x100()
> > Modules linked in:
> > Pid: 776, comm: modprobe Tainted: G        W 2.6.27-rc5-mm1 #1
> >  [<c012526f>] warn_on_slowpath+0x5f/0x90
> >  [<c01617e9>] handle_mm_fault+0x1d9/0x210
> >  [<c01bd0a0>] ext3_get_block+0x0/0x100
> >  [<c011759b>] do_page_fault+0x12b/0x4f0
> >  [<c0105dde>] do_IRQ+0x7e/0xd0
> >  [<c0154ce4>] __alloc_pages_internal+0x94/0x410
> >  [<c0117470>] do_page_fault+0x0/0x4f0
> >  [<c038506a>] error_code+0x72/0x78
> >  [<c015496c>] buffered_rmqueue+0x12c/0x210
> >  [<c014fbab>] find_get_page+0x2b/0xa0
> >  [<c016768b>] vmap_pte_range+0xcb/0x100
> >  [<c01676ed>] vmap_pmd_range+0x2d/0x40
> >  [<c016772d>] vmap_pud_range+0x2d/0x40
> >  [<c01677a6>] vmap_page_range+0x66/0x90
> >  [<c016844f>] map_vm_area+0x2f/0x50
> >  [<c0168996>] __vmalloc_area_node+0xb6/0x110
> >  [<c0168a95>] __vmalloc_node+0x85/0xb0
> >  [<c0148eb9>] load_module+0x89/0xd90
> >  [<c0168b01>] vmalloc+0x21/0x30
> >  [<c0148eb9>] load_module+0x89/0xd90
> >  [<c0148eb9>] load_module+0x89/0xd90
> >  [<c01380e0>] autoremove_wake_function+0x0/0x50
> >  [<c0177db0>] vfs_read+0x90/0x150
> >  [<c0149c44>] sys_init_module+0x44/0x1a0
> >  [<c0178111>] sys_read+0x41/0x70
> >  [<c01031fa>] syscall_call+0x7/0xb
> >  =======================
> > ---[ end trace 4eaa2a86a8e2da22 ]---
> > Intel ICH 0000:00:1f.5: PCI INT B -> GSI 17 (level, low) -> IRQ 17
> > Intel ICH 0000:00:1f.5: setting latency timer to 64
> 
> That's coming out of the module loader and is a new one.  It's the same
> warning as the agp one:
> 

The third one is interesting because it is "moving". One the first reboot
(the posted was the second) this warning happened when the snd_au8820
module was loaded and there was no warning about ext3.

Regards,
Krzysztof

----------------------------------------------------------------------
Nie zwlekaj! Tapetuj z nami!
Sprawdz >>  http://link.interia.pl/f1f01

