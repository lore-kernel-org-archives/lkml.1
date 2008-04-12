Return-Path: <linux-kernel-owner+w=401wt.eu-S1758018AbYDLT6S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758018AbYDLT6S (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Apr 2008 15:58:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756061AbYDLT6J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Apr 2008 15:58:09 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:41560 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755970AbYDLT6H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Apr 2008 15:58:07 -0400
Date: Sat, 12 Apr 2008 12:53:25 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: "Uladzislau Rezki" <urezki@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Kernel Oops within Linux Fedore Core 5
Message-ID: <20080412125325.36bc029d@laptopd505.fenrus.org>
In-Reply-To: <e4957ae10804110813y159019c1p84296058bcc769cf@mail.gmail.com>
References: <e4957ae10804110813y159019c1p84296058bcc769cf@mail.gmail.com>
Organization: Intel
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Apr 2008 18:13:59 +0300
"Uladzislau Rezki" <urezki@gmail.com> wrote:

> HI,
> 
> I am running linux Fedore Core 5 with 2.6.15 linux kernel.
> 
> So , the problem is that, while loading my own kernel module, kernel
> gets Oops.
> 
> ---> usbfs
> ---> tmpfs
> ---> binfmt_misc
> ---> rpc_pipefs
> ---> autofs
> Unable to handle kernel paging request at virtual address dead4ead
> printing eip:
> c7034018
> *pde = 00000000
> Oops: 0000 [#1]
> last sysfs file: /class/net/sit0/address
> Modules linked in: sb_show(U) ipv6 autofs4 hidp rfcomm l2cap bluetooth
> sunrpc dm_mirror dm_mod video button battery ac lp parport_pc parport
> floppy nvram sg i2c_piix4 pcnet32 mii i2c_core ext3 jbd mptspi
> mptscsih sd_mod scsi_mod mptbase
> CPU: 0
> EIP: 0060:[<c7034018>] Not tainted VLI
> EFLAGS: 00010282 (2.6.15-1.2054_FC5.root #1)
> EIP is at sb_show_init+0x18/0x41 [sb_show]
> eax: dead4ead ebx: c0344740 ecx: c5877d90 edx: c7006096
> esi: c1304e00 edi: c57d2b68 ebp: c70065c8 esp: c3962e6c
> ds: 007b es: 007b ss: 0068
> Process insmod (pid: 1675, threadinfo=c3962000 task=c621d000)
> Stack: <0>c57d2b58 c7006580 c0130506 0001027a 00000550 00000320
> c7006580 00000000
> 00000000 00000000 00000000 00000000 00000000 00000000 c72205fc
> 00000000 c59e78c0 c721b8ec c721b5cc c721b914 c720b000 00000004
> 0000000a 00000000 Call Trace:
> [<c0130506>] sys_init_module+0x1382/0x1514 [<c015240f>]


Hi,

normally (read: 99% of the cases) this happens when your Makefile is buggy.
Are you sure your Makefile is correct? Also, are you sure you're compiling
against the right kernel headers ?

Greetings,
   Arjan van de Ven
