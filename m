Return-Path: <linux-kernel-owner+w=401wt.eu-S1765303AbXGWQTl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765303AbXGWQTl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 12:19:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760081AbXGWQTd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 12:19:33 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:14854 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757205AbXGWQTb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 12:19:31 -0400
Subject: Re: 2.6.22.1-rt4 lockups
From: Daniel Walker <dwalker@mvista.com>
To: Rui Nuno Capela <rncbc@rncbc.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       RT-Users <linux-rt-users@vger.kernel.org>
In-Reply-To: <46A283A1.6030005@rncbc.org>
References: <1184325752.12353.312.camel@chaos>  <46A283A1.6030005@rncbc.org>
Content-Type: text/plain
Date: Mon, 23 Jul 2007 09:08:25 -0700
Message-Id: <1185206905.2573.52.camel@imap.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-1.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-07-21 at 23:07 +0100, Rui Nuno Capela wrote:

> Call Trace:
>  [<c010622a>] show_trace_log_lvl+0x1a/0x30
>  [<c01062f6>] show_stack_log_lvl+0xb6/0xe0
>  [<c0106521>] show_registers+0x201/0x330
>  [<c0106768>] die+0x118/0x260
>  [<c0304233>] do_page_fault+0x193/0x600
>  [<c030294a>] error_code+0x72/0x78
>  [<c011b4af>] activate_task+0x4f/0xb0
>  [<c011e09d>] try_to_wake_up+0x2bd/0x420
>  [<c011e279>] wake_up_process_mutex+0x19/0x20
>  [<c01425cc>] wakeup_next_waiter+0xec/0x1a0
>  [<c030173c>] rt_spin_lock_slowunlock+0x4c/0x70
>  [<c0301ff6>] rt_spin_unlock+0x26/0x30
>  [<c015b3e4>] put_zone_pcp+0x14/0x20
>  [<c015c265>] get_page_from_freelist+0x145/0x380
>  [<c015c4f4>] __alloc_pages+0x54/0x2d0
>  [<c01652bd>] __handle_mm_fault+0x7dd/0x9a0
>  [<c0304398>] do_page_fault+0x2f8/0x600
>  [<c030294a>] error_code+0x72/0x78
>  =======================

I was able to reproduce a similar looking hang when I combine kernbench
running with another load (I used ltpstress.sh from LTP) ..

I'm debugging it now ..

Daniel

