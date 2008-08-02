Return-Path: <linux-kernel-owner+w=401wt.eu-S1754757AbYHBVcW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754757AbYHBVcW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Aug 2008 17:32:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753946AbYHBVcD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Aug 2008 17:32:03 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:64430 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753767AbYHBVcA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Aug 2008 17:32:00 -0400
Date: Sat, 2 Aug 2008 17:31:58 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: John Kacur <jkacur@gmail.com>
cc: linux-rt-users@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Can't boot 2.6.26-rt1
In-Reply-To: <520f0cf10808021416n286855f9s126d416230aee249@mail.gmail.com>
Message-ID: <alpine.DEB.1.10.0808021731010.15392@gandalf.stny.rr.com>
References: <520f0cf10808021416n286855f9s126d416230aee249@mail.gmail.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, 2 Aug 2008, John Kacur wrote:

> VFS: Cannot open root device

Do you use an initrd boot disk? If so make sure the initrd is correct. 
Sometimes it is best to first get a 2.6.26 kernel booting without initrd 
and then use that same config on the -rt kernel.

-- Steve


> "disk/by-id/scsi-SATA_WDC_WD1600BEVS-WD-WXEZ07100576-part 7" or
> unknown block(0,0)
> Please append a correct "root = " boot option; here are the available
> partitions.
> Pid:1,comm:swapper Not tainted
> 2.6.26-rt1-default#1linux-rt-users@vger.kernel.org
> [< ffff ffff 8046 c149 >] rt_mutex_lock+0x22/0x50
> [< ffff ffff 8046 cae6 >] _mutex_unlock+0xe/0x10
> [< ffff ffff 8020 cb00 >] exit_intr+0x10/0x1e
> [< ffff ffff 8028 633d >] trace_hardirqs_on_caller+0x1e/0x133
> [< ffff ffff 8020 d608 >] child_rip+0xa/0x12
> [< ffff ffff 8020 cb69 >] restore_args+0x0/0x30
> [< ffff ffff 8020 d5fe >] child_rip+0x0/0x12
> 
> preempt count 00000001
> 1-level deep critical section nesting
> [< ffff ffff 8047 43e2 >] .... panic +0x43/0x167
> [< ffff ffff 8073 6338 >] (<= mount_block_root+0x258/0x26f
> 

