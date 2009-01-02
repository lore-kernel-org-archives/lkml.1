Return-Path: <linux-kernel-owner+w=401wt.eu-S1757538AbZABKEs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757538AbZABKEs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 05:04:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757445AbZABKEi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 05:04:38 -0500
Received: from mtagate7.de.ibm.com ([195.212.29.156]:60656 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757381AbZABKEg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 05:04:36 -0500
Date: Fri, 2 Jan 2009 11:04:33 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, linux-s390@vger.kernel.org,
       schwidefsky@de.ibm.com
Subject: Re: [BUG] next-20081231 - S390x kernel panics while bootup at
	init_sched_build_groups()
Message-ID: <20090102100433.GB4730@osiris.boeblingen.de.ibm.com>
References: <20090101003258.eaa44700.sfr@canb.auug.org.au> <20081231160329.GC4268@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20081231160329.GC4268@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 31, 2008 at 09:33:29PM +0530, Kamalesh Babulal wrote:
> 	next-2001231 kernel panic's on S390x box, while boot up
> cpu: 4 configured CPUs, 0 standby CPUs
> cpu: Processor 0 started, address 2, identification 20AB8A
> cpu: Processor 1 started, address 0, identification 00AB8A
> cpu: Processor 2 started, address 1, identification 10AB8A
> cpu: Processor 3 started, address 3, identification 30AB8A
> Brought up 4 CPUs
> Unable to handle kernel pointer dereference at virtual kernel address 0000000100
> 3fa000
> Oops: 003b Ý#1¨ SMP
> Modules linked in:
> CPU: 0 Not tainted 2.6.28-next-20081231-autotest #1
> Process swapper (pid: 1, task: 000000003fe80000, ksp: 000000003fe8ba78)
> Krnl PSW : 0704000180000000 0000000000035632 (init_sched_build_groups+0xae/0x4a4
> )
>            R:0 T:1 IO:1 EX:1 Key:0 M:1 W:0 P:0 AS:0 CC:0 PM:0 EA:3
> Krnl GPRS: 00000000003c27b0 00000001003fa278 0000000000000000 00000000003c2508
>            0000000000000000 000000000026f818 0000000000000000 0000000000000000
>            0000000000000000 000000003fe8be50 00000000ffffffff 000000003fe8bcf0
> Krnl Code: 0000000000035626: a7290000           lghi    00: HCPGSP2629I The virt

Seems to be fixed with linux-next from 2nd of January.
