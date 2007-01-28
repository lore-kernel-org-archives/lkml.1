Return-Path: <linux-kernel-owner+w=401wt.eu-S932925AbXA1WbP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932925AbXA1WbP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jan 2007 17:31:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932929AbXA1WbO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jan 2007 17:31:14 -0500
Received: from ug-out-1314.google.com ([66.249.92.172]:44984 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932671AbXA1WbN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jan 2007 17:31:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding:from;
        b=AMPMbqRB5ZdRVVi97MSb1+Gr5AKbij0IfHOmkPUYJJb7c0x054HOZ6SpTKS5z1/cJUrVH8wllhFk8Hp5FvswWJISGS8larKnLtGx/kZwv7d+VJEEjTTaldAX01psyqxues/VmYebouI25roZi8IDowm8efhM//mH28xswKvy7GE=
Message-ID: <45BD2424.7020604@googlemail.com>
Date: Sun, 28 Jan 2007 23:31:00 +0100
User-Agent: Thunderbird 1.5.0.9 (X11/20061219)
MIME-Version: 1.0
To: Andrew Morton <akpm@osdl.org>
CC: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: 2.6.20-rc6-mm1
References: <20070127234928.64d8e437.akpm@osdl.org>
In-Reply-To: <20070127234928.64d8e437.akpm@osdl.org>
X-Enigmail-Version: 0.94.1.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton napisał(a):
> Temporarily at
> 
> 	http://userweb.kernel.org/~akpm/2.6.20-rc6-mm1/
> 
> will appear one day at
> 
> 	ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.20-rc6/2.6.20-rc6-mm1/
> 
> 

Jan 28 22:58:29 euridica kernel: BUG: using smp_processor_id() in preemptible [00000001] code: yum-updatesd/2846
Jan 28 22:58:29 euridica kernel: caller is nf_conntrack_in+0x363/0x47f [nf_conntrack]
Jan 28 22:58:29 euridica kernel:  [<c01053c6>] show_trace_log_lvl+0x1a/0x2f
Jan 28 22:58:29 euridica kernel:  [<c0105ad6>] show_trace+0x12/0x14
Jan 28 22:58:29 euridica kernel:  [<c0105b98>] dump_stack+0x16/0x18
Jan 28 22:58:29 euridica kernel:  [<c0207803>] debug_smp_processor_id+0xb3/0xc8
Jan 28 22:58:29 euridica kernel:  [<fdbf8ad0>] nf_conntrack_in+0x363/0x47f [nf_conntrack]
Jan 28 22:58:29 euridica kernel:  [<fd9c32c4>] ipv4_conntrack_local+0x53/0x5b [nf_conntrack_ipv4]
Jan 28 22:58:29 euridica kernel:  [<c02f2286>] nf_iterate+0x36/0x67
Jan 28 22:58:29 euridica kernel:  [<c02f241b>] nf_hook_slow+0x52/0xbe
Jan 28 22:58:29 euridica kernel:  [<c02fd280>] ip_queue_xmit+0x3d1/0x420
Jan 28 22:58:29 euridica kernel:  [<c030b9b9>] tcp_transmit_skb+0x78b/0x7ca
Jan 28 22:58:29 euridica kernel:  [<c030d452>] __tcp_push_pending_frames+0x732/0x811
Jan 28 22:58:29 euridica kernel:  [<c030e3de>] tcp_send_fin+0x146/0x150
Jan 28 22:58:29 euridica kernel:  [<c03042c9>] tcp_close+0x22b/0x556
Jan 28 22:58:29 euridica kernel:  [<c031d595>] inet_release+0x43/0x49
Jan 28 22:58:29 euridica kernel:  [<c02d74c8>] sock_release+0x17/0x9d
Jan 28 22:58:29 euridica kernel:  [<c02d7843>] sock_close+0x2d/0x33
Jan 28 22:58:29 euridica kernel:  [<c0178a0a>] __fput+0xca/0x198
Jan 28 22:58:29 euridica kernel:  [<c0178c44>] fput+0x32/0x36
Jan 28 22:58:29 euridica kernel:  [<c017606a>] filp_close+0x54/0x5c
Jan 28 22:58:29 euridica kernel:  [<c0124e72>] put_files_struct+0x7d/0xba
Jan 28 22:58:29 euridica kernel:  [<c012625e>] do_exit+0x30d/0x8e6
Jan 28 22:58:29 euridica kernel:  [<c01268b9>] sys_exit_group+0x0/0x11
Jan 28 22:58:29 euridica kernel:  [<c012f177>] get_signal_to_deliver+0x734/0x760
Jan 28 22:58:29 euridica kernel:  [<c010391e>] do_notify_resume+0x94/0x749
Jan 28 22:58:29 euridica kernel:  [<c01044a1>] work_notifysig+0x13/0x1a
Jan 28 22:58:29 euridica kernel:  =======================

http://www.stardust.webpages.pl/files/tbf/euridica/2.6.20-rc6-mm1/mm-config

Regards,
Michal

-- 
Michal K. K. Piotrowski
LTG - Linux Testers Group
(http://www.stardust.webpages.pl/ltg/)
