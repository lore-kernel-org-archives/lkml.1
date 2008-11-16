Return-Path: <linux-kernel-owner+w=401wt.eu-S1756035AbYKPCPt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756035AbYKPCPt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Nov 2008 21:15:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753758AbYKPCPk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Nov 2008 21:15:40 -0500
Received: from ioctl.codeblau.de ([80.190.240.67]:55721 "EHLO codeblau.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753592AbYKPCPk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Nov 2008 21:15:40 -0500
Date: Sun, 16 Nov 2008 02:15:37 +0000
From: Felix von Leitner <felix-linuxkernel@fefe.de>
To: linux-kernel@vger.kernel.org
Subject: kernel suddenly fails to boot
Message-ID: <20081116021537.GA32090@codeblau.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm talking about kernel 2.6.27, but I also tried 2.6.27.6.
The stunning thing is that the kernel USED to work until right about
now.  I last booted Linux on this box yesterday evening.  I have had
intermittend boot problems, but they always go away after a reset or two.
The box would freeze at boot at a message about ACPI.  Since it usually
went away after a reset, and the box is stable once it boots, I never
really cared enough to fix it.

This is a Core 2 Duo on an Abit IP35 mainboard.  The kernel is a 64-bit
kernel.

The very last line before the current freeze is:

  TIMER: vector=0x30 acpi1=0 pin1=2 apic2=-1 pin2=-1

I googled this line and found people suggesting "nolapic_timer",
"noapic" or "nolapic".  None of these work.  This is a 64-bit SMP
system.  I also tried "noacpi".  All of these get a little farther, but
still freeze the kernel before it even starts looking for SATA devices.

Windows (32-bit XP) still works on the box.

Any ideas what I could do now?

I tried updating the BIOS after this problem hit, but the BIOS update
utility said I already have the latest BIOS.

I have four gigs of RAM in the box, Windows XP only uses 3.25 of those.
Could this be a problem on the remaining RAM?

I also tried "memtest=1", which paused a little but then booted the same
kernel and also froze just the same.

Felix
