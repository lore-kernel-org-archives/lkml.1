Return-Path: <linux-kernel-owner+w=401wt.eu-S1758297AbZANWxj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758297AbZANWxj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 17:53:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755364AbZANWx3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 17:53:29 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:60113 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755328AbZANWx2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 17:53:28 -0500
Date: Wed, 14 Jan 2009 17:53:24 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: "Eric W. Biederman" <ebiederm@xmission.com>
cc: Jon Masters <jcm@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Bjorn Helgaas <bjorn.helgaas@hp.com>, Stefan Assmann <sassmann@suse.de>,
       Len Brown <lenb@kernel.org>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Olaf Dabrunz <od@suse.de>, Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-acpi@vger.kernel.org, Sven Dietrich <sdietrich@novell.com>,
       "Maciej W. Rozycki" <macro@linux-mips.org>
Subject: Re: PCI, ACPI, IRQ, IOAPIC: reroute PCI interrupt to legacy boot
 interrupt equivalent
In-Reply-To: <m11vv5wlug.fsf@frodo.ebiederm.org>
Message-ID: <alpine.DEB.1.10.0901141751200.24309@gandalf.stny.rr.com>
References: <alpine.LFD.2.00.0901091743310.20020@localhost.localdomain> <496B24E5.1070804@suse.de> <200901121151.53195.bjorn.helgaas@hp.com> <m1d4esxfk2.fsf@frodo.ebiederm.org> <1231806563.4094.25.camel@perihelion.bos.jonmasters.org> <20090113014723.GA11366@elte.hu>
 <m1prirx3xn.fsf@frodo.ebiederm.org> <1231820798.4094.34.camel@perihelion.bos.jonmasters.org> <20090114114006.GF8625@elte.hu> <1231960709.23174.0.camel@londonpacket.bos.redhat.com> <m11vv5wlug.fsf@frodo.ebiederm.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 14 Jan 2009, Eric W. Biederman wrote:
> Jon Masters <jcm@redhat.com> writes:
> 
> Which leads me to conclude.
> - IRQ handling in the RT kernel is hopelessly broken.
> - IRQ threads are a bad idea.

I would rephrase that to

  -- boot interrupts are hopelessly broken

> 
> Because it is all leading to stupid patches and stupid development.

Hmm, WTF should we have maskable interrupts for anyway? Sounds like broken 
hardware design to me.

> 
> None of this works reliably on level triggered ioapic irqs.
> 

I guess this means that ioapic's are not for RTOS of any kind.

-- Steve

