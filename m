Return-Path: <linux-kernel-owner+w=401wt.eu-S1757160AbYBXLZR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757160AbYBXLZR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2008 06:25:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753329AbYBXLZE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Feb 2008 06:25:04 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:52271 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752979AbYBXLZC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2008 06:25:02 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Julian Blake Kongslie <jblake@omgwallhack.org>
Subject: Re: Hang on suspend
Date: Sun, 24 Feb 2008 12:23:46 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: linux-kernel@vger.kernel.org
References: <1203553943.4422.25.camel@dukephillips.omgwallhack.org> <200802232143.31903.rjw@sisk.pl> <1203827444.4202.18.camel@dukephillips.omgwallhack.org>
In-Reply-To: <1203827444.4202.18.camel@dukephillips.omgwallhack.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802241223.46930.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 24 of February 2008, Julian Blake Kongslie wrote:
> On Sat, 2008-02-23 at 21:43 +0100, Rafael J. Wysocki wrote:
> > Can you please apply the appened patch and retest?
> 
> Didn't apply cleanly to v2.6.25-rc2; I had to mangle one or two lines.
> The patch I applied follows at the end of this message.
> 
> Unfortunately, it's about the same as before. I got:
> 
> Freezing user space processes ... (elapsed 0.00 seconds) done.
> Freezing remaining freezable tasks ... (elapsed 0.00 seconds) done.
> ACPI: Preparing to enter system sleep state S3
> sd 0:0:0:0: [sda] Synchronizing SCSI cache
> sd 0:0:0:0: [sda] Stopping disk
> nsc-ircc 00:0b: disabled
> parport_pc 00:0a: disabled
> eth1: Going into suspend...
> ACPI: PCI interrupt for device 0000:0b:02.0 disabled
> ACPI: PCI interrupt for device 0000:00:1e.3 disabled
> ACPI: PCI interrupt for device 0000:00:1e.2 disabled
> ACPI: PCI interrupt for device 0000:00:1d.7 disabled
> ACPI: PCI interrupt for device 0000:00:1d.3 disabled
> ACPI: PCI interrupt for device 0000:00:1d.2 disabled
> ACPI: PCI interrupt for device 0000:00:1d.1 disabled
> ACPI: PCI interrupt for device 0000:00:1d.0 disabled
> BUG: unable to handle kernel NULL pointer dereference at 00000090

Can you please check what's at the address platform_suspend_late+0x19?

You can used "gdb vmlinux" and then "l *platform_suspend_late+0x19" under the
gdb for this purpose.

Thanks,
Rafael
