Return-Path: <linux-kernel-owner+w=401wt.eu-S1753921AbZBQSRR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753921AbZBQSRR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 13:17:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751810AbZBQSRE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 13:17:04 -0500
Received: from smtp-12.star.net.uk ([212.125.75.81]:34040 "HELO
	smtp-12.star.net.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751535AbZBQSRB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 13:17:01 -0500
Date: Tue, 17 Feb 2009 18:15:17 +0000
From: Bob Wilkinson <bob@fourtheye.org>
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PROBLEM] Multiple BUG: unable to handle kernel paging request
Message-ID: <20090217181517.GA828@fourtheye.org>
References: <20090216211012.GA31416@fourtheye.org> <20090216134129.6f9e7458@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090216134129.6f9e7458@infradead.org>
X-Operating-System: Linux spain 2.6.26-1-sparc64
X-Debian-Version: 5.0
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 16, 2009 at 01:41:29PM -0800, Arjan van de Ven wrote:
> On Mon, 16 Feb 2009 21:10:12 +0000
> Bob Wilkinson <bob@fourtheye.org> wrote:
> 
> > Hello
> > 
> >      I have been having many problems with the stability of one of
> > my machines. It does have a lot of attached peripherals, and
> > regularly crashes. It does not always boot. I have attached as much
> > information as I know to.
> > 
> > There are multiple 
> > 
> > BUG: unable to handle kernel paging request 
> 
> you're using a rather old kernel; it might be better to report such an
> issue to your distribution instead.
> 
> 
> however, one thing to try is to put "mem=750M" on the kernel command
> line; if your bios lies to you about how much memory you have that
> would work around it.

Hi Arjan

Thanks for your suggestion. I added this to the end of the boot line in 
grub.conf. I needed to restart again today and saw this in the kern.log.

Feb 17 09:21:57 italy kernel: [    0.114545] ACPI: Core revision 20080321
Feb 17 09:21:57 italy kernel: [    0.123946] ACPI: setting ELCR to 0200 (from 0e00)
Feb 17 09:21:57 italy kernel: [    0.128008] weird, boot CPU (#0) not listedby the BIOS.
Feb 17 09:21:57 italy kernel: [    0.128008] SMP motherboard not detected.
Feb 17 09:21:57 italy kernel: [    0.128008] Local APIC not detected. Using dummy APIC emulation.
Feb 17 09:21:57 italy kernel: [    0.128008] SMP disabled
Feb 17 09:21:57 italy kernel: [    0.128008] Brought up 1 CPUs
Feb 17 09:21:57 italy kernel: [    0.128070] Total of 1 processors activated (1863.87 BogoMIPS).

I do find it weird that the BIOS does not list the one - and only
- CPU.

I will build a newer kernel from source and see how I get on with
that. I do suspect that I have some combination of intermittently
faulty hardware. I quite often have a locked up machine - sometimes
with three keyboard lights flashing, sometimes responding to
CTRL-ALT-SYSRQ commands - sometimes not...

> Arjan van de Ven 	Intel Open Source Technology Centre
> For development, discussion and tips for power savings, 
> visit http://www.lesswatts.org

Bob
