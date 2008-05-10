Return-Path: <linux-kernel-owner+w=401wt.eu-S1757204AbYEJUTI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757204AbYEJUTI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 May 2008 16:19:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754032AbYEJUS4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 May 2008 16:18:56 -0400
Received: from aun.it.uu.se ([130.238.12.36]:54681 "EHLO aun.it.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753216AbYEJUSz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 May 2008 16:18:55 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18470.787.498329.144701@harpo.it.uu.se>
Date: Sat, 10 May 2008 22:18:27 +0200
From: Mikael Pettersson <mikpe@it.uu.se>
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
Cc: linux-kernel@vger.kernel.org, sam@ravnborg.org
Subject: 2.6.26-rc1 on x86: ld: warning: dot moved backwards before `.text'
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Building kernel 2.6.26-rc1 on FC6/i386 causes:

  ld -m elf_i386   -T arch/x86/kernel/acpi/realmode/wakeup.lds arch/x86/kernel/acpi/realmode/wakeup.o arch/x86/kernel/acpi/realmode/wakemain.o arch/x86/kernel/acpi/realmode/video-mode.o arch/x86/kernel/acpi/realmode/copy.o arch/x86/kernel/acpi/realmode/video-vga.o arch/x86/kernel/acpi/realmode/video-vesa.o arch/x86/kernel/acpi/realmode/video-bios.o -o arch/x86/kernel/acpi/realmode/wakeup.elf 
ld: warning: dot moved backwards before `.text'
ld: warning: dot moved backwards before `.text'
ld: warning: dot moved backwards before `.text'

This is with gcc-4.2.3 and binutils-2.17.50.0.6-5.fc6 20061020.

The resulting kernel hasn't broken on me yet, however.

A search through the LKML archives showed that this was reported
for 2.6.25-rc3-mm1, but I couldn't find any discussion about it
after that:

<http://marc.info/?l=linux-kernel&m=120470303728010&w=2>

The .config causing this warning is available in
<http://user.it.uu.se/~mikpe/linux/ale/config-2.6.26-rc1>

/Mikael
