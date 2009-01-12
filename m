Return-Path: <linux-kernel-owner+w=401wt.eu-S1754591AbZALLhs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754591AbZALLhs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 06:37:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751802AbZALLhi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 06:37:38 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:59647 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751643AbZALLhh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 06:37:37 -0500
Date: Mon, 12 Jan 2009 12:37:20 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Stefan Assmann <sassmann@suse.de>
Cc: Len Brown <lenb@kernel.org>, Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Olaf Dabrunz <od@suse.de>,
       Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-acpi@vger.kernel.org, Sven Dietrich <sdietrich@novell.com>
Subject: Re: PCI, ACPI, IRQ, IOAPIC: reroute PCI interrupt to legacy boot
	interrupt equivalent
Message-ID: <20090112113720.GB21051@elte.hu>
References: <alpine.LFD.2.00.0901091743310.20020@localhost.localdomain> <496B24E5.1070804@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <496B24E5.1070804@suse.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Stefan Assmann <sassmann@suse.de> wrote:

> Why can these IRQ lines be brought down by Boot Interrupts? Because 
> there's no handler installed on the primary IO-APIC IRQ line that can 
> take care of them and after too many unhandled IRQs the line will be 
> shut down by the kernel.

The failure mode can be quite nasty: ranging from non-working USB (and 
other) devices to hard lockups due to screaming IRQs.

	Ingo
