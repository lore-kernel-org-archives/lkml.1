Return-Path: <linux-kernel-owner+w=401wt.eu-S1754178Ab0A3Sjn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754178Ab0A3Sjn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jan 2010 13:39:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753913Ab0A3Sjm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Jan 2010 13:39:42 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:47058 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753978Ab0A3Sjm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jan 2010 13:39:42 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Heinz Diehl <htd@fancy-poultry.org>
Subject: Re: 2.6.33-rc6, swapper - not tainted
Date: Sat, 30 Jan 2010 19:40:11 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.33-rc6-rjw; KDE/4.3.5; x86_64; ; )
Cc: linux-kernel@vger.kernel.org
References: <20100130183311.GA6464@fancy-poultry.org>
In-Reply-To: <20100130183311.GA6464@fancy-poultry.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201001301940.11477.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 30 January 2010, Heinz Diehl wrote:
> Hi,
> 
> booting 2.6.33-rc6, i get this in my log. 2.6.33-rc5 and below were fine.
> Please contact me if you need further information.
> 
> [....]
> <6>cpuidle: using governor ladder
> <6>cpuidle: using governor menu
> <4>Netfilter messages via NETLINK v0.30.
> <3>kmem_cache_create: duplicate cache ccid2_h
> <4>Pid: 1, comm: swapper Not tainted 2.6.33-rc6 #1
> <4>Call Trace:
> <4> [<ffffffff810cf8d0>] ? kmem_cache_create+0x4a0/0x550
> <4> [<ffffffff814007fe>] ? ccid_kmem_cache_create+0x5e/0x70
> <4> [<ffffffff8176cdf9>] ? ccid_initialize_builtins+0x59/0xb0
> <4> [<ffffffff8176d1c6>] ? dccp_init+0x376/0x3d7
> <4> [<ffffffff8176ce50>] ? dccp_init+0x0/0x3d7
> <4> [<ffffffff810001d5>] ? do_one_initcall+0x35/0x190
> <4> [<ffffffff8173764d>] ? kernel_init+0x174/0x1ce
> <4> [<ffffffff81003b54>] ? kernel_thread_helper+0x4/0x10
> <4> [<ffffffff817374d9>] ? kernel_init+0x0/0x1ce
> <4> [<ffffffff81003b50>] ? kernel_thread_helper+0x0/0x10
> <6>input: AT Translated Set 2 keyboard as
> /devices/platform/i8042/serio0/input/input0
> <6>input: ImPS/2 Logitech Wheel Mouse as
> /devices/platform/i8042/serio1/input/input1
> <4>registered taskstats version 1
> <6>Freeing unused kernel memory: 1344k freed
> [....]

It looks like you cut too much from the log.  Can you please attach
the entire log?

Rafael
