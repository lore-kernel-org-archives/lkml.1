Return-Path: <linux-kernel-owner+w=401wt.eu-S1757080AbYEJUYS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757080AbYEJUYS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 May 2008 16:24:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754814AbYEJUYL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 May 2008 16:24:11 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:57114 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754032AbYEJUYK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 May 2008 16:24:10 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Mikael Pettersson <mikpe@it.uu.se>
Subject: Re: 2.6.26-rc1 on x86: ld: warning: dot moved backwards before `.text'
Date: Sat, 10 May 2008 22:23:55 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org, sam@ravnborg.org
References: <18470.787.498329.144701@harpo.it.uu.se>
In-Reply-To: <18470.787.498329.144701@harpo.it.uu.se>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805102223.56494.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, 10 of May 2008, Mikael Pettersson wrote:
> Building kernel 2.6.26-rc1 on FC6/i386 causes:
> 
>   ld -m elf_i386   -T arch/x86/kernel/acpi/realmode/wakeup.lds arch/x86/kernel/acpi/realmode/wakeup.o arch/x86/kernel/acpi/realmode/wakemain.o arch/x86/kernel/acpi/realmode/video-mode.o arch/x86/kernel/acpi/realmode/copy.o arch/x86/kernel/acpi/realmode/video-vga.o arch/x86/kernel/acpi/realmode/video-vesa.o arch/x86/kernel/acpi/realmode/video-bios.o -o arch/x86/kernel/acpi/realmode/wakeup.elf 
> ld: warning: dot moved backwards before `.text'
> ld: warning: dot moved backwards before `.text'
> ld: warning: dot moved backwards before `.text'
> 
> This is with gcc-4.2.3 and binutils-2.17.50.0.6-5.fc6 20061020.
> 
> The resulting kernel hasn't broken on me yet, however.

It shouldn't.  Have you tried to suspend to RAM?

> A search through the LKML archives showed that this was reported
> for 2.6.25-rc3-mm1, but I couldn't find any discussion about it
> after that:
> 
> <http://marc.info/?l=linux-kernel&m=120470303728010&w=2>
> 
> The .config causing this warning is available in
> <http://user.it.uu.se/~mikpe/linux/ale/config-2.6.26-rc1>

Well, we don't really know why this happens.  It surely doesn't happen with
newer toolchains (as of OpenSUSE 10.3 for example).

Thanks,
Rafael
