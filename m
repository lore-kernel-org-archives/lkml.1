Return-Path: <linux-kernel-owner+w=401wt.eu-S1759861AbXKTIRj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759861AbXKTIRj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 03:17:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755963AbXKTIRc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 03:17:32 -0500
Received: from mailout08.sul.t-online.de ([194.25.134.20]:37646 "EHLO
	mailout08.sul.t-online.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755505AbXKTIRb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 03:17:31 -0500
Message-ID: <4742980A.60407@t-online.de>
Date: Tue, 20 Nov 2007 09:17:14 +0100
From: Harald Dunkel <harald.dunkel@t-online.de>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
CC: Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.23.8, ondemand scaling governor: "BUG: soft lockup detected
 on CPU#0!"
References: <474227F9.8050909@t-online.de> <924EFEDD5F540B4284297C4DC59F3DEE251A40@orsmsx423.amr.corp.intel.com>
In-Reply-To: <924EFEDD5F540B4284297C4DC59F3DEE251A40@orsmsx423.amr.corp.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-ID: GoQQekZlwhBcB3I0qCdByKRjseuJcbBsMaNjR+5bJiAnVnwzYmhXJGG-HcwZWIdw48
X-TOI-MSGID: 8f88021c-d52e-4b38-a188-252a7b141f14
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pallipadi, Venkatesh wrote:
> 
> Can you try switching to powersave governor (which should always run CPU
> at 400MHz) and see whether you see similar error?
> 

Yes, if I move from performance to powersave, then I see a similar
error:

Nov 20 09:06:48 bugs kernel: BUG: soft lockup detected on CPU#0!
Nov 20 09:06:48 bugs kernel:  [<c013cf8d>] softlockup_tick+0x91/0xa6
Nov 20 09:06:48 bugs kernel:  [<c012269c>] update_process_times+0x3a/0x5d
Nov 20 09:06:48 bugs kernel:  [<c0131219>] tick_sched_timer+0x115/0x164
Nov 20 09:06:48 bugs kernel:  [<c012d311>] hrtimer_interrupt+0x102/0x191
Nov 20 09:06:48 bugs kernel:  [<c0106cd6>] timer_interrupt+0x2e/0x34
Nov 20 09:06:48 bugs kernel:  [<c013d1f6>] handle_IRQ_event+0x1a/0x3f
Nov 20 09:06:48 bugs kernel:  [<c013e4e1>] handle_level_irq+0xa8/0xb7
Nov 20 09:06:48 bugs kernel:  [<c0106367>] do_IRQ+0x53/0x6c
Nov 20 09:06:48 bugs kernel:  [<c0104853>] common_interrupt+0x23/0x28
Nov 20 09:06:48 bugs kernel:  =======================


Please mail. Regards

Harri

