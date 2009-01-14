Return-Path: <linux-kernel-owner+w=401wt.eu-S1756632AbZANTTg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756632AbZANTTg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 14:19:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756108AbZANTTI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 14:19:08 -0500
Received: from mx2.redhat.com ([66.187.237.31]:41689 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756073AbZANTTG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 14:19:06 -0500
Subject: Re: PCI, ACPI, IRQ, IOAPIC: reroute PCI interrupt to legacy boot
	interrupt equivalent
From: Jon Masters <jcm@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Bjorn Helgaas <bjorn.helgaas@hp.com>, Stefan Assmann <sassmann@suse.de>,
       Len Brown <lenb@kernel.org>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Olaf Dabrunz <od@suse.de>, Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-acpi@vger.kernel.org, Sven Dietrich <sdietrich@novell.com>,
       "Maciej W. Rozycki" <macro@linux-mips.org>
In-Reply-To: <20090114114006.GF8625@elte.hu>
References: <alpine.LFD.2.00.0901091743310.20020@localhost.localdomain>
	 <496B24E5.1070804@suse.de> <200901121151.53195.bjorn.helgaas@hp.com>
	 <m1d4esxfk2.fsf@frodo.ebiederm.org>
	 <1231806563.4094.25.camel@perihelion.bos.jonmasters.org>
	 <20090113014723.GA11366@elte.hu> <m1prirx3xn.fsf@frodo.ebiederm.org>
	 <1231820798.4094.34.camel@perihelion.bos.jonmasters.org>
	 <20090114114006.GF8625@elte.hu>
Content-Type: text/plain
Organization: Red Hat, Inc.
Date: Wed, 14 Jan 2009 14:18:29 -0500
Message-Id: <1231960709.23174.0.camel@londonpacket.bos.redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-01-14 at 12:40 +0100, Ingo Molnar wrote:

> it's not just -rt, but it is also needed for the concept of threaded IRQ 
> handlers - which was discussed at the Kernel Summit to be desired for 
> mainline.

Right. I'm poking at Thomas' patches and hope to post something soon on
that front - I'm acutely aware that this will be impacted aswell but
because it's vaguely RT related had banded it under that banner.

Jon.


