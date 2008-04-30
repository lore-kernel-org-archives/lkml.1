Return-Path: <linux-kernel-owner+w=401wt.eu-S1763965AbYD3SVP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763965AbYD3SVP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 14:21:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759340AbYD3SVA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 14:21:00 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50654 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758975AbYD3SU7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 14:20:59 -0400
Date: Wed, 30 Apr 2008 11:20:28 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Balaji Rao <balajirrao@gmail.com>
Cc: linux-kernel@vger.kernel.org,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: Re: IDE probe failure in 2.6.25-mm1
Message-Id: <20080430112028.ae20df4a.akpm@linux-foundation.org>
In-Reply-To: <200804302343.14949.balajirrao@gmail.com>
References: <200804302343.14949.balajirrao@gmail.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Apr 2008 23:43:14 +0530
Balaji Rao <balajirrao@gmail.com> wrote:

> Hi Andrew,
> 
> IDE probe fails in 2.6.25-mm1 on qemu.
> 
> [    0.664164] Uniform Multi-Platform E-IDE driver
> [    1.571508] ide0: DISABLED, NO IRQ
> [    1.572380] ide0: failed to initialize IDE interface
> 
> This is the output with linux-2.6.git
> 
> [    1.567368] ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
> [    1.571430] hda: max request size: 512KiB
> [    1.574302] hda: 10485760 sectors (5368 MB) w/256KiB Cache, CHS=10402/255/63
> [    1.583896] hda: cache flushes supported
> [    1.585053]  hda: hda1
> 
> This is apparently due to the invasive changes in hwif_t's io_ports member.
> 

OK, thanks.

I _think_ Bart idenfitied a patch which caused this (or something like it)
and dropped it?

