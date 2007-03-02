Return-Path: <linux-kernel-owner+w=401wt.eu-S1422907AbXCBHEq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422907AbXCBHEq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 02:04:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422908AbXCBHEq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 02:04:46 -0500
Received: from mail.kroah.org ([69.55.234.183]:39571 "EHLO perch.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422907AbXCBHEp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 02:04:45 -0500
Date: Thu, 1 Mar 2007 23:03:59 -0800
From: Greg KH <greg@kroah.com>
To: Kunal Trivedi <ktrivedilkml@gmail.com>
Cc: linuxkernel <linux-kernel@vger.kernel.org>,
       Maneesh Soni <maneesh@in.ibm.com>, Steven Rostedt <rostedt@goodmis.org>
Subject: Re: Kernel Null pointer dereference in sysfs_readdir()
Message-ID: <20070302070359.GA8184@kroah.com>
References: <a10e25a30703011754s65c28271v60f0a2849b3bea08@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a10e25a30703011754s65c28271v60f0a2849b3bea08@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 01, 2007 at 05:54:01PM -0800, Kunal Trivedi wrote:
> 5) OOPS messages from console.
>    <1>Unable to handle kernel NULL pointer dereference at virtual
> address 00000018
>    <1> printing eip:
>    <4>e01a40c9
>    <1>*pde = 00000000
>    <1>Oops: 0000 [#1]
>    <4>SMP
>    <4>Modules linked in: ipt_state ip_conntrack iptable_filter
> cls_u32 iptable_mangle lm85 i2c_i801 w83627hf_wdt w83627hf i2c_sensor
> i2c_isa i2c_core slcmi ip_tables e7xxx_edac edac_mc
>    <4>CPU:    2
>    <4>EIP:    0060:[<e01a40c9>]    Tainted: PF     VLI
>    <4>EFLAGS: 00010286   (2.6.9-34.EL-i386_SMP)
>    <4>EIP is at sysfs_readdir+0xd9/0x210
>    <4>eax: 00000000   ebx: f7d6b104   ecx: 00000006   edx: 00000020
>    <4>esi: f7d6b100   edi: f7f1cb87   ebp: f7f1cb80   esp: ef432f48
>    <4>ds: 007b   es: 007b   ss: 0068
>    <4>Process sensors (pid: 2933, threadinfo=ef432000 task=f562c030)
>    <4>Stack: 00000002 00000000 016c32f7 0000000a f7d6cc8c 00000006
> f7ddbbc4 e017a670
>    <4>       ef432fa0 ed6e7280 e0409ba0 ed6e7280 f6f180b0 f6f18120
> e017a33f ef432fa0
>    <4>       e017a670 09ce61b4 ed6e7280 fffffff7 00000000 e017a81e
> 09ce6204 09ce61e4
>    <4>Call Trace:
>    <4> [<e017a670>] filldir64+0x0/0x140
>    <4> [<e017a33f>] vfs_readdir+0xaf/0xd0
>    <4> [<e017a670>] filldir64+0x0/0x140
>    <4> [<e017a81e>] sys_getdents64+0x6e/0xb6
>    <4> [<e039bb5f>] syscall_call+0x7/0xb
>    <4>Code: 26 00 89 f0 e8 89 e8 ff ff 89 c5 b9 ff ff ff ff 31 c0 89
> ef f2 ae f7 d1 49 89 4c 24 14 8b 46 20 85 c0 0f 84 22 01 00 00 8b 40
> 10 <8b> 50 18 0f b7 46 1c 89 54 24 08 8b 4c 24 24 c1 e8 0c 89 44 24
> 
> Please advice.

I suggest contacting the vendor providing the support for this old
kernel version, they should be able to help you out (although they might
ask you to not run a closed source driver in your kernel, as that
probably voids any support contract you might have.)

thanks,

greg k-h
