Return-Path: <linux-kernel-owner+w=401wt.eu-S1754836AbXFTPrM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754836AbXFTPrM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 11:47:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752157AbXFTPq7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 11:46:59 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:48299 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751788AbXFTPq6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 11:46:58 -0400
Date: Wed, 20 Jun 2007 08:48:23 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Aaron Porter <atporter@primate.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: NFS Oops 2.6.20.14
Message-Id: <20070620084823.3c212959.randy.dunlap@oracle.com>
In-Reply-To: <20070618200507.GS6601@primate.net>
References: <20070618200507.GS6601@primate.net>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Jun 2007 13:05:07 -0700 Aaron Porter wrote:

> 
> 	Reproducable, every time nfs-kernel-server exits:

Kernel .config file, please...


> nfsd: unexporting all filesystems
> BUG: unable to handle kernel paging request at virtual address 6b6b6b6f
>  printing eip:
> f92a7751
> *pde = 6b6b6b6b
> Oops: 0000 [#1]
> PREEMPT SMP 
> Modules linked in: xt_tcpudp iptable_nat nf_nat nf_conntrack_ipv4 nf_conntrack nfnetlink ip_tables x_tables nfs nfsd exportfs lockd sunrpc capability commoncap ipv6 ohci_hcd usbcore amd_rng rng_core i2c_amd8111 generic amd74xx shpchp pci_hotplug ide_scsi w83627hf eeprom lm85 hwmon_vid i2c_isa i2c_amd756 i2c_core rtc unix
> CPU:    0
> EIP:    0060:[<f92a7751>]    Not tainted VLI
> EFLAGS: 00010202   (2.6.20.14-20070612 #2)
> EIP is at cache_clean+0x101/0x1e6 [sunrpc]
> eax: 00000000   ebx: 6b6b6b6b   ecx: 00000001   edx: f92eb940
> esi: dfd9e800   edi: 00000000   ebp: efc7e000   esp: f56bbf84
> ds: 007b   es: 007b   ss: 0068
> Process nfsd (pid: 2856, ti=f56ba000 task=c74daaa0 task.ti=f56ba000)
> Stack: f92eb940 f70ddd50 00000000 f92a7880 f92a78aa f70ddd24 f92cae61 f92a1b8c 
>        f92a1fe1 00000009 00000000 00000009 00000000 f92c36b2 f92dd07d efc7e000 
>        fffffeff ffffffff fffffef8 ffffffff f92c3448 00000000 00000000 00000000 
> Call Trace:
>  [<f92a7880>] cache_flush+0xc/0x1f [sunrpc]
>  [<f92a78aa>] cache_purge+0x17/0x20 [sunrpc]
>  [<f92cae61>] nfsd_export_flush+0x14/0x28 [nfsd]
>  [<f92a1b8c>] svc_destroy+0x96/0x100 [sunrpc]
>  [<f92a1fe1>] svc_exit_thread+0x69/0x7d [sunrpc]
>  [<f92c36b2>] nfsd+0x26a/0x27b [nfsd]
>  [<f92c3448>] nfsd+0x0/0x27b [nfsd]
>  [<c010364b>] kernel_thread_helper+0x7/0x10
>  =======================
> Code: f9 0f 8d f9 00 00 00 8d 42 0c e8 dd 26 11 c7 a1 60 ea 2b f9 8b 50 08 a1 64 ea 2b f9 8d 34 82 8b 1e 85 db 74 6d 8b 15 60 ea 2b f9 <8b> 43 04 39 42 54 7e 04 40 89 42 54 8b 43 04 3b 05 00 f6 52 c0 
> EIP: [<f92a7751>] cache_clean+0x101/0x1e6 [sunrpc] SS:ESP 0068:f56bbf84
>  <6>note: nfsd[2856] exited with preempt_count 2
> 


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
