Return-Path: <linux-kernel-owner+w=401wt.eu-S1754125AbZFZG46@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754125AbZFZG46 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 02:56:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751521AbZFZG4v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 02:56:51 -0400
Received: from mail-bw0-f213.google.com ([209.85.218.213]:65323 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751248AbZFZG4u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 02:56:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=fFECm/JikvDFNNCfaJojnq4abzgOOxgDhENdLWNHQKi2js8sF2INXxJ/1jfqdj0Y1Y
         nT8Kp1m5JXSSJqBxzyV+VAH3wNndhnVmALS9ypbb6rtzEDNyqrihdoNSZ3td9IEbPDDt
         dI6j5QS1FkndsLqXnIST3MD6hdWKd9Ww8QXfs=
MIME-Version: 1.0
Date: Fri, 26 Jun 2009 08:56:52 +0200
Message-ID: <40a4ed590906252356i574f0da4jc3763cfc9f0f65f6@mail.gmail.com>
Subject: 2.6.31-rc1 crashes randomly on my Machine.
From: Zeno Davatz <zdavatz@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

Yesterday I done a fresh pull after Linus released 2.6.31-rc1. After
doing a clean boot, my machine started crashing randomly. I rebooted
several times. Also my X-server and Window-Manager (ion3) did not
start properly and was not really working. The machine suddenly hung
out of nowhere. What do you need? I attached my /var/log/messages

I got stuff like this on my screen:

Jun 25 21:19:12 zenogentoo Code: 00 00 00 c7 47 20 00 00 00 00 c7 47
24 00 00 00 00 c7 47 10 00 00 00 00 c7 47 14 00 00 00 00 c7 47 0c 00
00 00 00 e9 27 ff ff ff <ff> 89 e5 57 56 53 83 ec 34 89 45 d0 89 55 cc
89 4d c8 8b 70 6c
Jun 25 21:19:12 zenogentoo EIP: [<c10d1d35>] seq_read+0x0/0x3a5 SS:ESP
0068:f4b01f44
Jun 25 21:19:12 zenogentoo CR2: 0000000053565be5
Jun 25 21:19:12 zenogentoo ---[ end trace 6254fef9dc80950b ]---
Jun 25 21:19:12 zenogentoo BUG: unable to handle kernel paging request
at 53565be5
Jun 25 21:19:12 zenogentoo IP: [<c10d1d35>] seq_read+0x0/0x3a5
Jun 25 21:19:12 zenogentoo *pde = 00000000
Jun 25 21:19:12 zenogentoo Oops: 0002 [#27] PREEMPT SMP
Jun 25 21:19:12 zenogentoo last sysfs file: /sys/class/dmi/id/chassis_asset_tag
Jun 25 21:19:12 zenogentoo Modules linked in:
Jun 25 21:19:12 zenogentoo
Jun 25 21:19:12 zenogentoo Pid: 2961, comm: sh Tainted: G      D
(2.6.31-rc1 #50) MS-7137
Jun 25 21:19:12 zenogentoo EIP: 0060:[<c10d1d35>] EFLAGS: 00010286 CPU: 0
Jun 25 21:19:12 zenogentoo EIP is at seq_read+0x0/0x3a5
Jun 25 21:19:12 zenogentoo EAX: f6b70400 EBX: f7279d00 ECX: 00000400
EDX: b7fb9000
Jun 25 21:19:12 zenogentoo ESI: fffffffb EDI: c10d1d35 EBP: f635df64
ESP: f635df44
Jun 25 21:19:12 zenogentoo DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
Jun 25 21:19:12 zenogentoo Process sh (pid: 2961, ti=f635c000
task=f64edb60 task.ti=f635c000)
Jun 25 21:19:12 zenogentoo Stack:
Jun 25 21:19:12 zenogentoo c10f29e2 f635df98 00000400 b7fb9000
f6b70400 f6b70400 b7fb9000 00000400
Jun 25 21:19:12 zenogentoo <0> f635df8c c10bbb37 f635df98 00000000
f64cd500 00000073 c10f298b f6b70400
Jun 25 21:19:12 zenogentoo <0> fffffff7 00000000 f635dfac c10bbc96
f635df98 00000000 00000000 00000000
Jun 25 21:19:12 zenogentoo Call Trace:
Jun 25 21:19:12 zenogentoo [<c10f29e2>] ? proc_reg_read+0x57/0x78
Jun 25 21:19:12 zenogentoo [<c10bbb37>] ? vfs_read+0x8b/0x141
Jun 25 21:19:12 zenogentoo [<c10f298b>] ? proc_reg_read+0x0/0x78
Jun 25 21:19:12 zenogentoo [<c10bbc96>] ? sys_read+0x3d/0x6b
Jun 25 21:19:12 zenogentoo [<c1021290>] ? sysenter_do_call+0x12/0x2c
Jun 25 21:19:12 zenogentoo Code: 00 00 00 c7 47 20 00 00 00 00 c7 47
24 00 00 00 00 c7 47 10 00 00 00 00 c7 47 14 00 00 00 00 c7 47 0c 00
00 00 00 e9 27 ff ff ff <ff> 89 e5 57 56 53 83 ec 34 89 45 d0 89 55 cc
89 4d c8 8b 70 6c
Jun 25 21:19:12 zenogentoo EIP: [<c10d1d35>] seq_read+0x0/0x3a5 SS:ESP
0068:f635df44
Jun 25 21:19:12 zenogentoo CR2: 0000000053565be5
Jun 25 21:19:12 zenogentoo ---[ end trace 6254fef9dc80950c ]---

See attachment.

lscpi:
00:00.0 Host bridge: Intel Corporation 82915G/P/GV/GL/PL/910GL Memory
Controller Hub (rev 0e)
00:02.0 VGA compatible controller: Intel Corporation 82915G/GV/910GL
Integrated Graphics Controller (rev 0e)
00:1b.0 Audio device: Intel Corporation 82801FB/FBM/FR/FW/FRW (ICH6
Family) High Definition Audio Controller (rev 05)
00:1d.0 USB Controller: Intel Corporation 82801FB/FBM/FR/FW/FRW (ICH6
Family) USB UHCI #1 (rev 05)
00:1d.1 USB Controller: Intel Corporation 82801FB/FBM/FR/FW/FRW (ICH6
Family) USB UHCI #2 (rev 05)
00:1d.2 USB Controller: Intel Corporation 82801FB/FBM/FR/FW/FRW (ICH6
Family) USB UHCI #3 (rev 05)
00:1d.3 USB Controller: Intel Corporation 82801FB/FBM/FR/FW/FRW (ICH6
Family) USB UHCI #4 (rev 05)
00:1d.7 USB Controller: Intel Corporation 82801FB/FBM/FR/FW/FRW (ICH6
Family) USB2 EHCI Controller (rev 05)
00:1e.0 PCI bridge: Intel Corporation 82801 PCI Bridge (rev d5)
00:1f.0 ISA bridge: Intel Corporation 82801FB/FR (ICH6/ICH6R) LPC
Interface Bridge (rev 05)
00:1f.1 IDE interface: Intel Corporation 82801FB/FBM/FR/FW/FRW (ICH6
Family) IDE Controller (rev 05)
00:1f.2 IDE interface: Intel Corporation 82801FB/FW (ICH6/ICH6W) SATA
Controller (rev 05)
00:1f.3 SMBus: Intel Corporation 82801FB/FBM/FR/FW/FRW (ICH6 Family)
SMBus Controller (rev 05)
02:03.0 FireWire (IEEE 1394): VIA Technologies, Inc. IEEE 1394 Host
Controller (rev 80)
02:06.0 Ethernet controller: Intel Corporation 82541GI Gigabit
Ethernet Controller (rev 05)

Thank you for your Feedback.

Best
Zeno
