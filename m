Return-Path: <linux-kernel-owner+w=401wt.eu-S1762034AbYETING@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762034AbYETING (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 04:13:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756426AbYETIMx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 04:12:53 -0400
Received: from lucidpixels.com ([75.144.35.66]:45198 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754528AbYETIMv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 04:12:51 -0400
Date: Tue, 20 May 2008 04:12:50 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: linux-kernel@vger.kernel.org
Subject: Kernel 2.6.25.4 crashed upon bootup [BUG: NMI Watchdog detected
 LOCKUP]
Message-ID: <alpine.DEB.1.10.0805200406200.9677@p34.internal.lan>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the first time my machine has ever crashed while booting up.

Kernel = 2.6.25.4

May 20 03:57:23 box1 [   13.917884] BUG: NMI Watchdog detected LOCKUP
May 20 03:57:23 box1  on CPU1, ip c010146e, registers:
May 20 03:57:23 box1 [   13.917884] Modules linked in:
May 20 03:57:23 box1  snd_hda_intel
May 20 03:57:23 box1  snd_hwdep
May 20 03:57:23 box1
May 20 03:57:23 box1 [   13.917884]
May 20 03:57:23 box1 [   13.917884] Pid: 0, comm: swapper Not tainted (2.6.25.4 #1)
May 20 03:57:23 box1 [   13.917884] EIP: 0060:[<c010146e>] EFLAGS: 00000246 CPU: 1
May 20 03:57:23 box1 [   13.917884] EIP is at mwait_idle_with_hints+0x3e/0x50
May 20 03:57:23 box1 [   13.917884] EAX: 00000000 EBX: 00000000 ECX: 00000000 EDX: 00000000
May 20 03:57:23 box1 [   13.917884] ESI: 00000000 EDI: c055a6c0 EBP: 00000000 ESP: f7c45fa0
May 20 03:57:23 box1 [   13.917884]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
May 20 03:57:23 box1 [   13.917884] Process swapper (pid: 0, ti=f7c44000 task=f7c3eaf0 task.ti=f7c44000)
May 20 03:57:23 box1
May 20 03:57:23 box1 [   13.917884] Stack:
May 20 03:57:23 box1 c0101480
May 20 03:57:23 box1 00000001
May 20 03:57:23 box1 c01019a5
May 20 03:57:23 box1 01020800
May 20 03:57:23 box1 00000000
May 20 03:57:23 box1 last message repeated 3 times
May 20 03:57:23 box1
May 20 03:57:23 box1 [   13.917884]
May 20 03:57:23 box1 00000000
May 20 03:57:23 box1 last message repeated 6 times
May 20 03:57:23 box1 000000d8
May 20 03:57:23 box1
May 20 03:57:23 box1 [   13.917884]
May 20 03:57:23 box1 00000000
May 20 03:57:23 box1 last message repeated 7 times
May 20 03:57:23 box1
May 20 03:57:23 box1 [   13.917884] Call Trace:
May 20 03:57:23 box1 [   13.917884]  [<c0101480>]
May 20 03:57:23 box1 mwait_idle+0x0/0x10
May 20 03:57:23 box1 [   13.917884]  [<c01019a5>]
May 20 03:57:23 box1 cpu_idle+0x45/0xa0
May 20 03:57:23 box1 [   13.917884]  =======================
May 20 03:57:23 box1 [   13.917884] Code:
May 20 03:57:23 box1 89

My boot parameters are as follows:

append="netconsole=4444@xxx.xxx.x.xx/eth0,514@xxx.xxx.x.xx/xx:xx:xx:xx:xx:xx nmi_watchdog=1"

The full dmesg (from netconsole) is attached.

Should I not be using nmi_watchdog, is there a bug/problem with that code?

Originally I wanted to use it so if the kernel ever crashed, it would reboot
the host automatically, but that did not happen either.

After power cycling, the host came up OK the second time?

Any idea what happened here?

Justin.

