Return-Path: <linux-kernel-owner+w=401wt.eu-S1754796AbZFSFdJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754796AbZFSFdJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jun 2009 01:33:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751953AbZFSFc5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Jun 2009 01:32:57 -0400
Received: from mail-gx0-f214.google.com ([209.85.217.214]:38734 "EHLO
	mail-gx0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751906AbZFSFc5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jun 2009 01:32:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=fYDs345o1c3sHsnzvw9ZPttGgTXVEG0lPM0AGGO4g8nSS5UcMuw4t6GIR5l+ya/Ssj
         TPM+CkC7Pg/3l+ei4ZEpj2o0lEBVPASDEuZlOmTJsaGGG/N3xKNhRHZxV+D4h1VY/3/H
         93zAcJLPW4rHZbd8Uo+1uI55StIb6KaQBIxN0=
MIME-Version: 1.0
In-Reply-To: <4A3AC0C4.6060508@goop.org>
References: <4A329CF8.4050502@goop.org>
	 <alpine.LFD.2.00.0906181206190.4213@localhost.localdomain>
	 <4A3A9220.4070807@goop.org> <m1zlc5jqac.fsf@fess.ebiederm.org>
	 <4A3A99FB.7070807@goop.org> <m1vdmtgtt2.fsf@fess.ebiederm.org>
	 <4A3AC0C4.6060508@goop.org>
Date: Thu, 18 Jun 2009 22:32:59 -0700
Message-ID: <86802c440906182232r31088e4fh3613a8da6f8903f7@mail.gmail.com>
Subject: Re: [PATCH RFC] x86/acpi: don't ignore I/O APICs just because there's 
	no local APIC
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Len Brown <lenb@kernel.org>,
       Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "the arch/x86 maintainers" <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

doesn't XEN support per cpu irq vector?

got sth from XEN 3.3 / SLES 11

igb 0000:81:00.0: PCI INT A -> GSI 95 (level, low) -> IRQ 95
igb 0000:81:00.0: setting latency timer to 64
igb 0000:81:00.0: Intel(R) Gigabit Ethernet Network Connection
igb 0000:81:00.0: eth9: (PCIe:2.5Gb/s:Width x4) 00:21:28:3a:d8:0e
igb 0000:81:00.0: eth9: PBA No: ffffff-0ff
igb 0000:81:00.0: Using MSI-X interrupts. 4 rx queue(s), 4 tx queue(s)
vendor=8086 device=3420
(XEN) irq.c:847: dom0: invalid pirq 94 or vector -28
igb 0000:81:00.1: PCI INT B -> GSI 94 (level, low) -> IRQ 94
igb 0000:81:00.1: setting latency timer to 64
(XEN) physdev.c:87: dom0: map irq with wrong vector -28
map irq failed
(XEN) physdev.c:87: dom0: map irq with wrong vector -28
map irq failed

the system need a lot of MSI-X normally.. with current mainline tree
kernel, it will need about 360 irq...

YH
