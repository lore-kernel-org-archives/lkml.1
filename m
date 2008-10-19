Return-Path: <linux-kernel-owner+w=401wt.eu-S1751969AbYJSSu0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751969AbYJSSu0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2008 14:50:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751742AbYJSSuO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Oct 2008 14:50:14 -0400
Received: from mail.bencastricum.nl ([213.84.203.196]:52980 "EHLO
	bencastricum.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751714AbYJSSuN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2008 14:50:13 -0400
Message-ID: <C7D8EA1750C540FF84D4C36F414AD7C3@Seven>
From: "Ben Castricum" <lk0810@bencastricum.nl>
To: <linux-kernel@vger.kernel.org>
Subject: Re: NULL pointer derefence since 2.6.27 in (e)poll
Date: Sun, 19 Oct 2008 20:50:09 +0200
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2900.5512
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.5579
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 19 Oct 2008, Hugh Dickins wrote:

> Isn't it the issue fixed by
>
> http://marc.info/?l=linux-kernel&m=122428548613067&w=2

I am not sure, below is the latest bug message. My knowledge of git is very 
limited, how can I tell if this is before or after the patch?

Thanks,
Ben


BUG: unable to handle kernel NULL pointer dereference at 00000020
IP: [<b0254b74>] sock_poll+0xc/0x12
*pde = 00000000
Oops: 0000 [#1] SMP
last sysfs file: 
/sys/devices/pci0000:00/0000:00:1f.3/i2c-adapter/i2c-0/0-002e/cpu0_vid
Modules linked in: ipt_MASQUERADE ipt_REJECT ipt_LOG xt_recent xt_tcpudp 
xt_state iptable_filter nf_conntrack_ftp iptable_nat ip_tables nf_nat 
x_tables n
f_conntrack_ipv4 nf_conntrack nf_defrag_ipv4 af_packet usb_storage usbhid 
8139too mii tg3 libphy cdc_acm ehci_hcd uhci_hcd usbcore lm85 hwmon_vid 
i2c_i80
1 softdog rtc ext2 [last unloaded: firmware_class]

Pid: 1717, comm: squid Not tainted (2.6.27-05178-g2e532d6 #111) HP d530 
SFF(PL110ES)
EIP: 0060:[<b0254b74>] EFLAGS: 00010246 CPU: 0
EIP is at sock_poll+0xc/0x12
EAX: ea872d80 EBX: 00000000 ECX: 00000000 EDX: eee50e00
ESI: e9a9bf00 EDI: ef304b80 EBP: ea84af44 ESP: ea84af40
 DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
Process squid (pid: 1717, ti=ea84a000 task=ea96e330 task.ti=ea84a000)
Stack:
 e9a9bf0c ea84afb0 b017ff04 ea84af9c 00000002 00000000 eabe1300 ef304b98
 00000003 ef304bac ef304ba4 e9a9bf0c ef304ba0 ef304b94 00000046 ef304b84
 ea84af9c b03ce000 b014248d ea84af94 b0126765 ea84afb0 b0105909 ea84af9c
Call Trace:
 [<b017ff04>] ? sys_epoll_wait+0x245/0x3a7
 [<b014248d>] ? handle_fasteoi_irq+0x0/0xad
 [<b0126765>] ? irq_exit+0x53/0x77
 [<b0105909>] ? do_IRQ+0xae/0xc4
 [<b0103905>] ? sysenter_do_call+0x12/0x25
Code: 8b 58 54 b8 ea ff ff ff 85 db 74 0c ff 75 0c ff 75 08 89 f0 ff d3 5a 
59 8d 65 f8 5b 5e 5d c3 55 89 e5 53 89 d1 8b 50 6c 8b 5a 0c <ff> 53 20 5b 5d 
c
3 55 89 e5 53 89 d1 8b 50 6c 8b 5a 0c ff 53 4c
EIP: [<b0254b74>] sock_poll+0xc/0x12 SS:ESP 0068:ea84af40
---[ end trace 6e50fb78d788d751 ]--- 

