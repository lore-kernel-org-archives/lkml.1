Return-Path: <linux-kernel-owner+w=401wt.eu-S1757491AbXITTFS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757491AbXITTFS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 15:05:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751960AbXITTFG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 15:05:06 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60633 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751002AbXITTFE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 15:05:04 -0400
Date: Thu, 20 Sep 2007 12:04:49 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: jacquejeremy@gmail.com
Cc: bugme-daemon@bugzilla.kernel.org, linux-kernel@vger.kernel.org,
       linux-fbdev-devel@lists.sourceforge.net
Subject: Re: [Bugme-new] [Bug 9043] New: tty not printed to screen
Message-Id: <20070920120449.54dd5d5d.akpm@linux-foundation.org>
In-Reply-To: <bug-9043-10286@http.bugzilla.kernel.org/>
References: <bug-9043-10286@http.bugzilla.kernel.org/>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


(Please reply via emailed reply-to-all, not via the bugzilla web interface)

On Thu, 20 Sep 2007 05:46:34 -0700 (PDT) bugme-daemon@bugzilla.kernel.org wrote:

> http://bugzilla.kernel.org/show_bug.cgi?id=9043
> 
>            Summary: tty not printed to screen
>            Product: Other
>            Version: 2.5
>      KernelVersion: 2.6.23-rc7
>           Platform: All
>         OS/Version: Linux
>               Tree: Mainline
>             Status: NEW
>           Severity: normal
>           Priority: P1
>          Component: Other
>         AssignedTo: other_other@kernel-bugs.osdl.org
>         ReportedBy: jacquejeremy@gmail.com
> 
> 
> Most recent kernel where this bug did not occur: 2.6.23-rc6
> Distribution: Centos 4.5 (Final)  (Careless Network V3)
> Hardware Environment: NEC PowerMate VL260
>          Output of "lspci":
> 00:00.0 Host bridge: Intel Corporation 82945G/GZ/P/PL Memory Controller Hub
> (rev 02)
> 00:02.0 VGA compatible controller: Intel Corporation 82945G/GZ Integrated
> Graphics Controller (rev 02)
> 00:1c.0 PCI bridge: Intel Corporation 82801G (ICH7 Family) PCI Express Port 1
> (rev 01)
> 00:1d.0 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI
> Controller #1 (rev 01)
> 00:1d.1 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI
> Controller #2 (rev 01)
> 00:1d.2 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI
> Controller #3 (rev 01)
> 00:1d.3 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI
> Controller #4 (rev 01)
> 00:1d.7 USB Controller: Intel Corporation 82801G (ICH7 Family) USB2 EHCI
> Controller (rev 01)
> 00:1e.0 PCI bridge: Intel Corporation 82801 PCI Bridge (rev e1)
> 00:1e.2 Multimedia audio controller: Intel Corporation 82801G (ICH7 Family)
> AC'97 Audio Controller (rev 01)
> 00:1f.0 ISA bridge: Intel Corporation 82801GB/GR (ICH7 Family) LPC Interface
> Bridge (rev 01)
> 00:1f.1 IDE interface: Intel Corporation 82801G (ICH7 Family) IDE Controller
> (rev 01)
> 00:1f.2 IDE interface: Intel Corporation 82801GB/GR/GH (ICH7 Family) SATA IDE
> Controller (rev 01)
> 00:1f.3 SMBus: Intel Corporation 82801G (ICH7 Family) SMBus Controller (rev 01)
> 01:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL8111/8168B PCI
> Express Gigabit Ethernet controller (rev 01)
> 
> 
> 
> Software Environment: 
>           Output of ver_linux :
> Linux careless2 2.6.23-rc7 #1 SMP Thu Sep 20 10:58:53 CEST 2007 i686 i686 i386
> GNU/Linux
> Gnu C                  3.4.6
> Gnu make               3.80
> binutils               2.15.92.0.2
> util-linux             2.12a
> mount                  2.12a
> module-init-tools      3.1-pre5
> e2fsprogs              1.35
> quota-tools            3.12.
> PPP                    2.4.2
> isdn4k-utils           3.3
> nfs-utils              1.0.6
> Linux C Library        3.4
> Dynamic linker (ldd)   2.3.4
> Procps                 3.2.3
> Net-tools              1.60
> Kbd                    1.12
> Sh-utils               5.2.1
> udev                   039
> Modules Loaded         thermal processor fan button uhci_hcd intelfb
> i2c_algo_bit rng_core i2c_i801 i2c_core r8169 dm_snapshot dm_zero dm_mirror
> dm_mod ata_piix libata sd_mod scsi_mod
> 
> 
> 
> Problem Description:
> When booting "init 3", the screen prints "ENTERING SLEEPING MODE"
> and i can't access to any console even by pressing keys.
> When booting "init 5" Xorg starts nicely and works perfectly but when
> pressing CTRL-ALT-F[1-6], the same happens : the screen prints "Entering
> sleeping mode" and i am not able to see anything.
> All the rest works perfectly so i can access on ssh to the box and  i can see a
> new user with the "who" command when logging in on tty1.
> 
> 
> Please let me know how to post attachment, i think my .config and others like
> "lspci -vvv" may be needed.
> 

I don't understnad this report much, but it sounds like a very recent
regression.

You're not actually trying to suspend the machine at the time, are you?

And it doesn't sound like the keyboard has malfunctioned?

Does anyone know where this "ENTERING SLEEPING MODE" message is coming
from?  A bit of googling makes me suspect that it is actually coming from
your monitor, which perhaps indicates that the kernel is sending incorrect
DPMS signalling to the monitor, or something like that?


