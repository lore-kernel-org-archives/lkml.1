Return-Path: <linux-kernel-owner+w=401wt.eu-S932222AbZJCN7q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932222AbZJCN7q (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Oct 2009 09:59:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932174AbZJCN7q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Oct 2009 09:59:46 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:39306 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932173AbZJCN7p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Oct 2009 09:59:45 -0400
Date: Sat, 3 Oct 2009 15:59:45 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Matti Aarnio <matti.aarnio@zmailer.org>,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: ftrace WARNING during boot
Message-ID: <20091003135945.GA18555@elte.hu>
References: <20091003105318.GB32486@mea-ext.zmailer.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091003105318.GB32486@mea-ext.zmailer.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


(Cc:-ed more people)

* Matti Aarnio <matti.aarnio@zmailer.org> wrote:

> This is perhaps already fixed, as I have two a bit newer kernels than this one,
> but reporting is better than being silent..
> 
>   .....................
>  kernel: rtc_cmos 00:04: setting system clock to 2009-10-02 23:21:17 UTC (1254525677)
>  kernel: Initalizing network drop monitor service
>  kernel: Freeing unused kernel memory: 3196k freed
>  kernel: NX-protecting the kernel data: ffffffff8150e000, 4469 pages
>  kernel: Write protecting the kernel read-only data: 7392k
>  kernel: dracut: dracut-002-2.gitc53acc30.fc12
>  kernel: udev: starting version 145
>  kernel: usb 1-5: new high speed USB device using ehci_hcd and address 4
>  kernel: ------------[ cut here ]------------
>  kernel: WARNING: at kernel/trace/ftrace.c:1003 ftrace_bug+0x198/0x27e() (Not tainted)
>  kernel: Hardware name: System Product Name
>  kernel: Modules linked in: i2c_core(+)
>  kernel: Pid: 87, comm: modprobe Not tainted 2.6.31-33.fc12.x86_64 #1
>  kernel: Call Trace:
>  kernel: [<ffffffff810642ec>] warn_slowpath_common+0x95/0xc3
>  kernel: [<ffffffffa0003072>] ? i2c_new_dummy+0x8/0x5e [i2c_core]
>  kernel: [<ffffffff81064341>] warn_slowpath_null+0x27/0x3d
>  kernel: [<ffffffff810d4ace>] ftrace_bug+0x198/0x27e
>  kernel: [<ffffffffa0003072>] ? i2c_new_dummy+0x8/0x5e [i2c_core]
>  kernel: [<ffffffff810d5d26>] ftrace_convert_nops+0x201/0x2b9
>  kernel: [<ffffffffa0003072>] ? i2c_new_dummy+0x8/0x5e [i2c_core]
>  kernel: [<ffffffff810d5e2a>] ftrace_module_notify+0x4c/0x7f
>  kernel: [<ffffffff81509c65>] notifier_call_chain+0x72/0xba
>  kernel: [<ffffffff81086e71>] ? __blocking_notifier_call_chain+0x4c/0x8e
>  kernel: [<ffffffff81086e88>] __blocking_notifier_call_chain+0x63/0x8e
>  kernel: [<ffffffff81086eda>] blocking_notifier_call_chain+0x27/0x3d
>  kernel: [<ffffffff810a472a>] sys_init_module+0xb7/0x249
>  kernel: [<ffffffff81011f42>] system_call_fastpath+0x16/0x1b
>  kernel: ---[ end trace fbf9054ae0f212c7 ]---
>  kernel: ftrace faulted on writing [<ffffffffa0003072>] i2c_new_dummy+0x8/0x5e [i2c_core]
>  kernel: usb 1-5: New USB device found, idVendor=0424, idProduct=2504
>  kernel: usb 1-5: New USB device strings: Mfr=0, Product=0, SerialNumber=0
>  kernel: usb 1-5: configuration #1 chosen from 1 choice
>  kernel: hub 1-5:1.0: USB hub found
>  kernel: hub 1-5:1.0: 4 ports detected
>   ..................
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
