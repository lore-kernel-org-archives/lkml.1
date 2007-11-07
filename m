Return-Path: <linux-kernel-owner+w=401wt.eu-S1757267AbXKGGQE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757267AbXKGGQE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 01:16:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751023AbXKGGPx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 01:15:53 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56616 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750826AbXKGGPw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 01:15:52 -0500
Date: Tue, 6 Nov 2007 22:15:09 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "werner" <werner@copaya.yi.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: crash 2.6.24-rc1-git10
Message-Id: <20071106221509.a9c5c674.akpm@linux-foundation.org>
In-Reply-To: <1193943446.4959@copaya.yi.org>
References: <1193943446.4959@copaya.yi.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.19; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On Thu, 01 Nov 2007 15:57:27 -0300 (GFT) "werner" <werner@copaya.yi.org> wrote:
> Kernel Crash -- Details see below
> globc 2.7  glib2 2.14.2
> W.Landgraf
> www.copaya.yi.org
> =============================================================================================================
> 2.6.24-rc1-git10
> EIP 0600: <c0407284> EFLAGS 00010212 CPU 0
> EIUP is at xor_sse_2+0x34/0x200
> EAX: 10 EBX fffedb22 ECX c183f000 EDX c183c000 ESS 8005003b EDI c0929614 EBP c183f000 ESP c1823ef0   
> DS 7b ES 7b FS d8 GS 0 SS 68
> Process swapper  pid 1  ti: c182200  task c1820000 task.ti c=1822000
> Stack:  8x 0    8x 0   fffedb22  0  c04067b3  10  c0849b62  c1030780  c183f000  c183c000
> call trace
> c0 4067b3 do_xor_speed+0x53/0xd0
>    9a9582 calibrate_xor_blocks 0xe2/0x100 (or 1a0 ?)
>   191594  register_filesystem =0X44/0X70
>   991565 kernel_init+0x125/0x2f0
>    10420a  ret_from_fork +0x6/0x1c  (or 0xb ...)
>   991440 kernel_init+0x0/0x2f0
>        " again
>    c0104edf  kernel_thread_helper+0x7/0x18
> code  08 89 74 24 44 0f 20 cf 0f 06 (or 0b) 0f 11 04 24 0f 11 4c 34 10 0f 11 54 24 20 0f 11 5c 24 30 0f 18 82 00
> 01 00 00 0f 18 82 20 01 00 00 <00> 20x 0
> EIP c0407284 xor_sse_2+0x34/0x200 SS ESP 068: c1823ef0
> kernel panic
> ====================System.map==================================================================================
> 
> 

Five days, no reply?

Is this still reproducible in latest mainline?  If so, please make a fuss.
