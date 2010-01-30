Return-Path: <linux-kernel-owner+w=401wt.eu-S1753888Ab0A3SdQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753888Ab0A3SdQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jan 2010 13:33:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752907Ab0A3SdP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Jan 2010 13:33:15 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:61267 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752218Ab0A3SdO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jan 2010 13:33:14 -0500
Date: Sat, 30 Jan 2010 19:33:11 +0100
From: Heinz Diehl <htd@fancy-poultry.org>
To: linux-kernel@vger.kernel.org
Subject: 2.6.33-rc6, swapper - not tainted
Message-ID: <20100130183311.GA6464@fancy-poultry.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Accept-Language: no,dk,se,en,de
Organization: private site
X-OpenPGP-KeyID: 0xA9353F12
X-OpenPGP-Fingerprint: C67E 9A93 1033 DF8A 9321  9F90 DC39 B8C3 A935 3F12
X-OpenPGP-URL: http://www.fritha.org/htd.asc
User-Agent: Mutt/1.5.20+20091213 (GNU/Linux)
X-Provags-ID: V01U2FsdGVkX1/w6wvMJ9SJ3gHG1riksXZqhc6paphkR3LAqN/
 XcslyRbp8aOOIRIwvcikcpataFJGopvkWEMKQV6j4a/8n62Gic
 XTvAPRLP4nQjs9KyjRPLA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

booting 2.6.33-rc6, i get this in my log. 2.6.33-rc5 and below were fine.
Please contact me if you need further information.

[....]
<6>cpuidle: using governor ladder
<6>cpuidle: using governor menu
<4>Netfilter messages via NETLINK v0.30.
<3>kmem_cache_create: duplicate cache ccid2_h
<4>Pid: 1, comm: swapper Not tainted 2.6.33-rc6 #1
<4>Call Trace:
<4> [<ffffffff810cf8d0>] ? kmem_cache_create+0x4a0/0x550
<4> [<ffffffff814007fe>] ? ccid_kmem_cache_create+0x5e/0x70
<4> [<ffffffff8176cdf9>] ? ccid_initialize_builtins+0x59/0xb0
<4> [<ffffffff8176d1c6>] ? dccp_init+0x376/0x3d7
<4> [<ffffffff8176ce50>] ? dccp_init+0x0/0x3d7
<4> [<ffffffff810001d5>] ? do_one_initcall+0x35/0x190
<4> [<ffffffff8173764d>] ? kernel_init+0x174/0x1ce
<4> [<ffffffff81003b54>] ? kernel_thread_helper+0x4/0x10
<4> [<ffffffff817374d9>] ? kernel_init+0x0/0x1ce
<4> [<ffffffff81003b50>] ? kernel_thread_helper+0x0/0x10
<6>input: AT Translated Set 2 keyboard as
/devices/platform/i8042/serio0/input/input0
<6>input: ImPS/2 Logitech Wheel Mouse as
/devices/platform/i8042/serio1/input/input1
<4>registered taskstats version 1
<6>Freeing unused kernel memory: 1344k freed
[....]

