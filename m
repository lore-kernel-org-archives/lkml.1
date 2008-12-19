Return-Path: <linux-kernel-owner+w=401wt.eu-S1752094AbYLSPBa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752094AbYLSPBa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2008 10:01:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750927AbYLSPBW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Dec 2008 10:01:22 -0500
Received: from mail-qy0-f11.google.com ([209.85.221.11]:64785 "EHLO
	mail-qy0-f11.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750806AbYLSPBV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2008 10:01:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:x-mailer:mime-version:content-type
         :content-transfer-encoding;
        b=uH0Lgn/FYZGBT/vY5E4nh9MRXtlVuWwQR2O7HAd+Sehk6j9GFX0029t4TdK8A5k5jb
         GWYKSeSDXWsgw8B6+eKM2vnbAjm2INpaHJGnwmjEPQzPBC2nAEPU0JkXM3lRv8pVW2Fk
         JjxPKHmAi+coaMICRu3ngU2Kt/h6diu6rxgYA=
Date: Fri, 19 Dec 2008 13:01:14 -0200
From: Guilherme Malschitzky Schroeder <guilherme.m.schroeder@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: 2.6.28-rc9 - ioremap.c:226 warning - GEM stuff?
Message-Id: <20081219130114.5fc87cfc.guilherme.m.schroeder@gmail.com>
X-Mailer: Sylpheed 2.6.0rc (GTK+ 2.14.5; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm running 2.6.28-rc9 on Debian sid/experimental with Xorg 1.5.3, intel driver 2.5.1 and i'm getting this warning in dmesg:

resource map sanity check conflict: 0xe0000000 0xefffffff 0xe0000000 0xe1feffff vesafb
------------[ cut here ]------------
WARNING: at arch/x86/mm/ioremap.c:226 __ioremap_caller+0xc8/0x2cd()
Modules linked in: kvm_intel kvm loop i2c_i801
Pid: 2101, comm: Xorg Not tainted 2.6.28-rc9 #10
Call Trace:
 [<ffffffff8022be25>] warn_on_slowpath+0x51/0x75
 [<ffffffff80230b5d>] iomem_map_sanity_check+0x75/0xac
 [<ffffffff8021fba0>] __ioremap_caller+0xc8/0x2cd
 [<ffffffff80360ffd>] i915_gem_entervt_ioctl+0x444/0x4d0
 [<ffffffff80360ffd>] i915_gem_entervt_ioctl+0x444/0x4d0
 [<ffffffff80360bb9>] i915_gem_entervt_ioctl+0x0/0x4d0
 [<ffffffff803548e3>] drm_ioctl+0x1c9/0x253
 [<ffffffff80280fc3>] vfs_ioctl+0x56/0x6c
 [<ffffffff8028135e>] do_vfs_ioctl+0x385/0x3b2
 [<ffffffff80276994>] vfs_write+0x121/0x136
 [<ffffffff802813c8>] sys_ioctl+0x3d/0x5c
 [<ffffffff8020b18b>] system_call_fastpath+0x16/0x1b
---[ end trace 05cd7e3729e479d6 ]---
Xorg:2101 conflicting memory types e0000000-f0000000 write-combining<->uncached-minus
reserve_memtype failed 0xe0000000-0xf0000000, track write-combining, req write-combining
Xorg:2101 conflicting memory types e0000000-f0000000 write-combining<->uncached-minus
reserve_memtype failed 0xe0000000-0xf0000000, track write-combining, req write-combining

I think is something related to GEM as my card supports it.

(II) intel(0): Integrated Graphics Chipset: Intel(R) Mobile Intel® GM45 Express Chipset

It's ok to just ignore?

If you need more info, let me know.

Thanks.

