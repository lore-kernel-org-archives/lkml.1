Return-Path: <linux-kernel-owner+w=401wt.eu-S932885AbXK2VKM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932885AbXK2VKM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 16:10:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933701AbXK2VJv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 16:09:51 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47808 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933726AbXK2VJu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 16:09:50 -0500
Date: Thu, 29 Nov 2007 13:09:05 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org, apw@shadowen.org,
       balbir@linux.vnet.ibm.com
Subject: Re: [BUG] 2.6.24-rc3-mm2 soft lockup while running tbench
Message-Id: <20071129130905.c31431f3.akpm@linux-foundation.org>
In-Reply-To: <474D7C32.1070809@linux.vnet.ibm.com>
References: <20071128034140.648383f0.akpm@linux-foundation.org>
	<474D7C32.1070809@linux.vnet.ibm.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Nov 2007 20:03:22 +0530
Kamalesh Babulal <kamalesh@linux.vnet.ibm.com> wrote:

> Hi Andrew,
> 
> while running tbench on the powerpc with 2.6.24-rc3-mm2 softlock up occurs
> 
> BUG: soft lockup - CPU#0 stuck for 11s! [tbench:12183]
> NIP: c0000000000ac978 LR: c0000000000acff0 CTR: c00000000005c648
> REGS: C00000076F0F3200 TRAP: 0901   Not tainted  (2.6.24-rc3-mm2-autotest)
> MSR: 8000000000009032 <EE,ME,IR,DR>  CR: 44000482  XER: 00000000
> TASK = C00000076F4BC000[12183] 'tbench' THREAD: C00000076F0F0000 CPU: 0
> NIP [c0000000000ac978] .get_page_from_freelist+0x1cc/0x754
> LR [c0000000000acff0] .__alloc_pages+0xb0/0x3a8
> Call Trace:
> [c00000076f0f3480] [c00000076f0f3560] 0xc00000076f0f3560 (unreliable)
> [c00000076f0f3590] [c0000000000acff0] .__alloc_pages+0xb0/0x3a8
> [c00000076f0f3680] [c0000000000ce2e4] .alloc_pages_current+0xa8/0xc8
> [c00000076f0f3710] [c0000000000ac6ec] .__get_free_pages+0x20/0x70
> [c00000076f0f3790] [c0000000000d75c8] .__kmalloc_node_track_caller+0x60/0x148
> [c00000076f0f3840] [c0000000002c22b0] .__alloc_skb+0x98/0x184
> [c00000076f0f38f0] [c000000000306cd8] .tcp_sendmsg+0x1fc/0xe24
> [c00000076f0f3a10] [c0000000002b963c] .sock_sendmsg+0xe4/0x128
> [c00000076f0f3c10] [c0000000002ba4ec] .sys_sendto+0xd4/0x120
> [c00000076f0f3d90] [c0000000002df2f8] .compat_sys_socketcall+0x148/0x214
> [c00000076f0f3e30] [c00000000000872c] syscall_exit+0x0/0x40
> Instruction dump:
> 720b0001 eb970000 40820070 72000002 4182000c e8bc0000 48000018 72080004 
> 4182000c e8bc0008 48000008 e8bc0010 <e8c10078> 7f83e378 7de407b4 7e078378 
> 

hm.  Beats me.  Does the machine recover OK?
