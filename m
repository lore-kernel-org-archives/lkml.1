Return-Path: <linux-kernel-owner+w=401wt.eu-S1758944AbZKYVUY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758944AbZKYVUY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 16:20:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758834AbZKYVUX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 16:20:23 -0500
Received: from gerard.telenet-ops.be ([195.130.132.48]:56220 "EHLO
	gerard.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758662AbZKYVUW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 16:20:22 -0500
Date: Wed, 25 Nov 2009 22:20:27 +0100 (CET)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linux/m68k <linux-m68k@vger.kernel.org>
cc: Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: M68k tree updates
Message-ID: <alpine.DEB.2.00.0911252213340.31650@ayla.of.borg>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It took me a while, but finally I managed to update
http://git.kernel.org/?p=linux/kernel/git/geert/linux-m68k.git again.

I added the following to master (the main development branch):

Andreas Schwab (2):
      m68k: use generic code for ptrace requests
      m68k: ptrace fixes

Geert Uytterhoeven (5):
      rtc: Add an RTC driver for the Oki MSM6242
      rtc: Add an RTC driver for the Ricoh RP5C01
      kgdb: Replace strstr() by strchr() for single-character needles
      net: ETHOC should depend on HAS_DMA
      dvb: SMS_SIANO_MDTV should depend on HAS_DMA

John Kacur (1):
      m68k: Remove the BKL from sys_execve

Krzysztof Helt (1):
      fbdev: atafb - add palette register check

Roel Kluin (1):
      m68k: parport_mfc3 - Not makes it a bool before the comparison.

Stephen Rothwell (1):
      m68k: don't export static inline functions

Tim Abbott (2):
      m68k: Make thread_info.h usable from assembly.
      m68k: Cleanup linker scripts using new linker script macros.


I added the following to for-next (aka for-2.6.33, to submit when the merge
window for 2.6.33 opens):

Andreas Schwab (2):
      m68k: use generic code for ptrace requests
      m68k: ptrace fixes

Geert Uytterhoeven (2):
      rtc: Add an RTC driver for the Oki MSM6242
      rtc: Add an RTC driver for the Ricoh RP5C01

John Kacur (1):
      m68k: Remove the BKL from sys_execve

Krzysztof Helt (1):
      fbdev: atafb - add palette register check

Roel Kluin (1):
      m68k: parport_mfc3 - Not makes it a bool before the comparison.

Stephen Rothwell (1):
      m68k: don't export static inline functions

Tim Abbott (2):
      m68k: Make thread_info.h usable from assembly.
      m68k: Cleanup linker scripts using new linker script macros.


I haven't updated m68k-queue (the branch with clean m68k changes w.r.t.
Linus' tree) yet.

If anything is missing, please tell me. Thx!

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
