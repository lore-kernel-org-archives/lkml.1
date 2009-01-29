Return-Path: <linux-kernel-owner+w=401wt.eu-S1758906AbZA2Ow0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758906AbZA2Ow0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 09:52:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754091AbZA2OwS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 09:52:18 -0500
Received: from wf-out-1314.google.com ([209.85.200.172]:55492 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754153AbZA2OwR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 09:52:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:reply-to:date:x-google-sender-auth:message-id
         :subject:from:to:content-type:content-transfer-encoding;
        b=QO9jaowonNFIdW/FYN5S3b9qmlk90QWMaxjDT6gN03eAGqolzITDX1iY0W810xpHgT
         Px81P0bm7/YnjmndJCr5ea2/gvgPdi1u8WJHLMGyWfopO/AXCgowQ3u2EOZ46znpDEwM
         kwKhXkYJOixfHpah/uVG3IhM3NUsvYWWiAFjI=
MIME-Version: 1.0
Reply-To: vsriram@mistralsolutions.com
Date: Thu, 29 Jan 2009 20:22:15 +0530
X-Google-Sender-Auth: 002bbf12974c3901
Message-ID: <8bf247760901290652j44562471x173ceca987f4ca2a@mail.gmail.com>
Subject: reboot produces a crash.
From: "Sriram V." <vsriram@mistralsolutions.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
   I am using 2.6.28 kernel. When i reboot. I get the following dump.

   Am trying to debug this - I want to know which module is causing the
   crash.

   How does anyone debug this?

Regards,
sriram


[<c007d97c>] (warn_slowpath+0x0/0x80) from [<c019dd58>] (kobject_put+0x3c/0x5c)
 r3:0000034f r2:c037041a
 r6:00000000 r5:c730c200 r4:c7802c20
[<c019dd1c>] (kobject_put+0x0/0x5c) from [<c01da150>]
(device_shutdown+0x88/0xa0)
 r4:c03f9fbc
[<c01da0c8>] (device_shutdown+0x0/0xa0) from [<c008ac14>]
(kernel_restart_prepare+0x2c/0x3c)
 r5:28121969 r4:00000000
[<c008abe8>] (kernel_restart_prepare+0x0/0x3c) from [<c008ac64>]
(kernel_restart+0x14/0x48)
[<c008ac50>] (kernel_restart+0x0/0x48) from [<c008c08c>] (sys_reboot+0xd4/0x1b0)
 r5:28121969 r4:01234567
[<c008bfb8>] (sys_reboot+0x0/0x1b0) from [<c0050e40>]
(ret_fast_syscall+0x0/0x2c)
 r7:00000058 r6:00000001 r5:00018380 r4:afe35e60
---[ end trace 3e890316ac4bb261 ]---
------------[ cut here ]------------
WARNING: at lib/kobject.c:592 kobject_put+0x3c/0x5c()
kobject: '<NULL>' (c7802c60): is not initialized, yet kobject_put() is
being called.
Modules linked in:
 r5:28121969 r4:00000000
[<c008abe8>] (kernel_restart_prepare+0x0/0x3c) from [<c008ac64>]
(kernel_restart+0x14/0x48)
[<c008ac50>] (kernel_restart+0x0/0x48) from [<c008c08c>] (sys_reboot+0xd4/0x1b0)
 r5:28121969 r4:01234567
[<c008bfb8>] (sys_reboot+0x0/0x1b0) from [<c0050e40>]
(ret_fast_syscall+0x0/0x2c)
 r7:00000058 r6:00000001 r5:00018380 r4:afe35e60
---[ end trace 3e890316ac4bb261 ]---
------------[ cut here ]------------
WARNING: at lib/kobject.c:592 kobject_put+0x3c/0x5c()
kobject: '<NULL>' (c7802ca0): is not initialized, yet kobject_put() is
being called.
Modules linked in:
[<c0054f0c>] (dump_stack+0x0/0x14) from [<c007d9e0>] (warn_slowpath+0x64/0x80)
[<c007d97c>] (warn_slowpath+0x0/0x80) from [<c019dd58>] (kobject_put+0x3c/0x5c)
 r3:0000032c r2:c037041a
 r6:00000000 r5:c730c200 r4:c7802ca0
[<c019dd1c>] (kobject_put+0x0/0x5c) from [<c01da160>]
(device_shutdown+0x98/0xa0)
 r4:c03f9fbc
