Return-Path: <linux-kernel-owner+w=401wt.eu-S1754124Ab0AKUEo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754124Ab0AKUEo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 15:04:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753934Ab0AKUEo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 15:04:44 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:35033 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753558Ab0AKUEm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 15:04:42 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: sboyce@blueyonder.co.uk
Subject: Re: [Bug #14946] All kernels after 2.6.32-git10  show only 1 CPU
Date: Mon, 11 Jan 2010 21:04:54 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.33-rc3-rjw; KDE/4.3.3; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>
References: <wnS54-l8PVO.A.TlF.oMlSLB@chimera> <omZ8aBZReyD.A.jbH.QNlSLB@chimera> <4B4A9D8F.9030300@blueyonder.co.uk>
In-Reply-To: <4B4A9D8F.9030300@blueyonder.co.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201001112104.54141.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 11 January 2010, Sid Boyce wrote:
> On 10/01/10 22:32, Rafael J. Wysocki wrote:
> > This message has been generated automatically as a part of a report
> > of recent regressions.
> > 
> > The following bug entry is on the current list of known regressions
> > from 2.6.32.  Please verify if it still should be listed and let me know
> > (either way).
> > 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14946
> > Subject		: All kernels after 2.6.32-git10  show only 1 CPU
> > Submitter	: Sid Boyce <sboyce@blueyonder.co.uk>
> > Date		: 2009-12-23 16:55 (19 days old)
> > References	: http://marc.info/?l=linux-kernel&m=126158734326801&w=4
> > 
> > 
> > 
> > 
> 
> With 2.6.33-rc3-git3 I now see 2 CPU's every on a normal boot, but its
> locking up solid at this part of the boot process as usual.
> ACPI: PCI Interrupt Link [AAZA] enabled at IRQ 22
> HDA Intel 0000:00:0e.1: PCI INT B -> Link[AAZA] -> GSI 22 (level, low)
> -> IRQ 22.
> With acpi=noirq (2 CPU's)
> ================
> kvm: Nested Virtualization enabled.
> IT8716 Super IO detected
> Parport_PC 00:0a: reported by plug and Play ACPI
> Parport 0: PC-Style at 0x378, irq 7 [PCSPP, TRISTATE,EPP]
> parport: irq 7 in use, resorting to polled operation
> HDA Intel 0000:00:0e.1: PCI -> APIC IRQ transform: INT B -> IRQ 11
> 
> With acpi=ht (1 CPU)
> =============
> Hangs at:-
> Loading drivees, configuring devices do_IRQ: 0.65 No irq handler for
> vector (irq -1)
> 
> With acpi=off (2 CPU's)
> ========================
> Hangs at same point as with acpi=noirq.

Thanks for the update.

Rafael
