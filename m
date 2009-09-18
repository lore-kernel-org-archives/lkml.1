Return-Path: <linux-kernel-owner+w=401wt.eu-S1756441AbZIRN1T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756441AbZIRN1T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 09:27:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752628AbZIRN1T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 09:27:19 -0400
Received: from mail-ew0-f206.google.com ([209.85.219.206]:38551 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751750AbZIRN1S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 09:27:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=icnXxMh+vAHuuZuBv/4TrabGg2i018S8VxtWqvu9MmN3uL9VoZhh73/jZdcLx6kxAI
         rMKVj2g4DpoqlbFHdwjcXLQiSrGZb4HWE1x7mNlbOYaUnWCiPXqhstuXQPx0jXo9BNYh
         eD1F9plDGQmjs10SxltVxJ3j8urCbA7JSZ3nw=
MIME-Version: 1.0
Date: Fri, 18 Sep 2009 15:27:20 +0200
Message-ID: <8db1092f0909180627p7c6baaa9l8d1b840144676bd6@mail.gmail.com>
Subject: [MTRR?] [2.6.31-git7] Xorg:2342 conflicting memory types 
	d0000000-e0000000 uncached-minus<->write-combining
From: Maciej Rutecki <maciej.rutecki@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-mm@kvack.org, airlied@linux.ie
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Last known good: 2.6.31-git3
Bad: 2.6.31-git7

Hardware:
00:02.0 VGA compatible controller: Intel Corporation 82G33/G31 Express
Integrated Graphics Controller (rev 02)

When KDM starts stops workin Ctrl+Alt+Fn (n=1...7) keys
When KDE4 starts keyboard stops working.

Dmesg shows:
[   24.471355] [drm] Initialized drm 1.1.0 20060810
[   24.488789] pci 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[   24.488799] pci 0000:00:02.0: setting latency timer to 64
[   24.495113] pci 0000:00:02.0: irq 27 for MSI/MSI-X
[   24.495151] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
[   25.645224] Xorg:2342 conflicting memory types d0000000-e0000000
uncached-minus<->write-combining
[   25.645231] reserve_memtype failed 0xd0000000-0xe0000000, track
uncached-minus, req uncached-minus
[   25.698026] Xorg:2342 conflicting memory types d0000000-e0000000
uncached-minus<->write-combining
[   25.698034] reserve_memtype failed 0xd0000000-0xe0000000, track
uncached-minus, req uncached-minus
[   25.721034] Xorg:2342 conflicting memory types d0000000-e0000000
uncached-minus<->write-combining
[   25.721042] reserve_memtype failed 0xd0000000-0xe0000000, track
uncached-minus, req uncached-minus
[   25.725961] Xorg:2342 freeing invalid memtype d0000000-e0000000
[   25.741993] Xorg:2342 conflicting memory types d0000000-e0000000
uncached-minus<->write-combining
[   25.742013] reserve_memtype failed 0xd0000000-0xe0000000, track
uncached-minus, req uncached-minus
[   25.746995] Xorg:2342 freeing invalid memtype d0000000-e0000000
[   25.762992] Xorg:2342 conflicting memory types d0000000-e0000000
uncached-minus<->write-combining
[   25.763013] reserve_memtype failed 0xd0000000-0xe0000000, track
uncached-minus, req uncached-minus
[   25.767984] Xorg:2342 freeing invalid memtype d0000000-e0000000
[   45.864618] CPU0 attaching NULL sched-domain.
[   45.864626] CPU1 attaching NULL sched-domain.
[   45.868189] CPU0 attaching sched-domain:
[   45.868194]  domain 0: span 0-1 level MC
[   45.868199]   groups: 0 1
[   45.868206] CPU1 attaching sched-domain:
[   45.868210]  domain 0: span 0-1 level MC
[   45.868213]   groups: 1 0
[   53.018506] Xorg:2342 conflicting memory types d0000000-e0000000
uncached-minus<->write-combining
[   53.018511] reserve_memtype failed 0xd0000000-0xe0000000, track
uncached-minus, req uncached-minus
[   53.021711] Xorg:2342 freeing invalid memtype d0000000-e0000000
[   53.490119] Xorg:2342 conflicting memory types d0000000-e0000000
uncached-minus<->write-combining
[   53.490139] reserve_memtype failed 0xd0000000-0xe0000000, track
uncached-minus, req uncached-minus
[   53.495587] Xorg:2342 freeing invalid memtype d0000000-e0000000
[   87.989188] Xorg:2342 freeing invalid memtype d0000000-e0000000


Logs from X.org shows:
(EE) XKB: Could not invoke xkbcomp
(EE) XKB: Couldn't compile keymap
(EE) XKB: Could not invoke xkbcomp
(EE) XKB: Couldn't compile keymap
(II) USB-compliant keyboard: Close
(II) UnloadModule: "evdev"
(II) USB-compliant keyboard: Close
(II) UnloadModule: "evdev"
(II) Power Button: Close
(II) UnloadModule: "evdev"
(II) Power Button: Close
(II) UnloadModule: "evdev"
(II) PATEN USB/PS2 Combo Receiver: Close
(II) UnloadModule: "evdev"
(II) Open ACPI successful (/var/run/acpid.socket)
(II) APM registered successfully
(II) intel(0): Kernel reported 746240 total, 1 used
(II) intel(0): I830CheckAvailableMemory: 2984956 kB available
(II) intel(0): [DRI2] Setup complete
(**) intel(0): Framebuffer compression disabled
(**) intel(0): Tiling enabled
(**) intel(0): SwapBuffers wait enabled
(EE) intel(0): Failed to initialize kernel memory manager
(==) intel(0): VideoRam: 262144 KB
(II) intel(0): Attempting memory allocation with tiled buffers.

Backtrace:
0: /usr/bin/X(xorg_backtrace+0x3b) [0x81314bb]
1: /usr/bin/X(xf86SigHandler+0x51) [0x80c1c61]
2: [0xb804b400]
3: /usr/lib/xorg/modules/drivers//intel_drv.so(i830_allocate_memory+0x286)
[0xb7b58576]
4: /usr/lib/xorg/modules/drivers//intel_drv.so(i830_allocate_2d_memory+0xbf)
[0xb7b5901f]
5: /usr/lib/xorg/modules/drivers//intel_drv.so [0xb7b4de74]
6: /usr/lib/xorg/modules/drivers//intel_drv.so [0xb7b52918]
7: /usr/bin/X(AddScreen+0x19d) [0x807121d]
8: /usr/bin/X(InitOutput+0x206) [0x80add66]
9: /usr/bin/X(main+0x1db) [0x807190b]
10: /lib/i686/cmov/libc.so.6(__libc_start_main+0xe5) [0xb7cf47a5]
11: /usr/bin/X [0x8070fa1]

Fatal server error:
Caught signal 11.  Server aborting


Please consult the The X.Org Foundation support
	 at http://wiki.x.org
 for help.
Please also check the log file at "/var/log/Xorg.0.log" for additional
information.

>From 2.6.31:
cat /proc/mtrr
reg00: base=0x000000000 (    0MB), size= 2048MB, count=1: write-back
reg01: base=0x080000000 ( 2048MB), size= 1024MB, count=1: write-back
reg02: base=0x0bf600000 ( 3062MB), size=    2MB, count=1: uncachable
reg03: base=0x0bf800000 ( 3064MB), size=    8MB, count=1: uncachable
reg04: base=0x0d0000000 ( 3328MB), size=  256MB, count=1: write-combining


Dmesg:
http://unixy.pl/maciek/download/kernel/2.6.31-git7/zlom/dmesg-2.6.31-git7.txt

Xorg.0.log:
http://unixy.pl/maciek/download/kernel/2.6.31-git7/zlom/Xorg.0.log

Config:
http://unixy.pl/maciek/download/kernel/2.6.31-git7/zlom/config-2.6.31-git7

lspci -vv -nn:
http://unixy.pl/maciek/download/kernel/2.6.31-git7/zlom/lspci.txt

Regards

-- 
Maciej Rutecki
http://www.maciek.unixy.pl
