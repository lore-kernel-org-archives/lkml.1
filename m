Return-Path: <linux-kernel-owner+w=401wt.eu-S1756460AbZBGDfr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756460AbZBGDfr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 22:35:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751880AbZBGDfh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 22:35:37 -0500
Received: from vms173007pub.verizon.net ([206.46.173.7]:26342 "EHLO
	vms173007pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752917AbZBGDfh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 22:35:37 -0500
Date: Fri, 06 Feb 2009 22:35:24 -0500 (EST)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@localhost.localdomain
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       linux-acpi@vger.kernel.org
Subject: Re: [PATCH] x86: find nr_irqs_gsi with mp_ioapic_routing
In-reply-to: <498CCEDB.8050708@kernel.org>
Message-id: <alpine.LFD.2.00.0902062221050.26256@localhost.localdomain>
References: <498CCEDB.8050708@kernel.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org




> Impact: find right nr_irqs_gsi on some systems.
> 
> one system has gap between gsi.
> [    0.000000] ACPI: IOAPIC (id[0x04] address[0xfec00000] gsi_base[0])
> [    0.000000] IOAPIC[0]: apic_id 4, version 0, address 0xfec00000, GSI 0-23
> [    0.000000] ACPI: IOAPIC (id[0x05] address[0xfeafd000] gsi_base[48])
> [    0.000000] IOAPIC[1]: apic_id 5, version 0, address 0xfeafd000, GSI 48-54
> [    0.000000] ACPI: IOAPIC (id[0x06] address[0xfeafc000] gsi_base[56])
> [    0.000000] IOAPIC[2]: apic_id 6, version 0, address 0xfeafc000, GSI 56-62
> ...
> [    0.000000] nr_irqs_gsi: 38

I've never seen gaps in GSIs.
I've never seen IOAPICs with 7 redirection table entries.

This system looks quite broken even before the probe for nr_irqs_gsi.
Do you have more information on it?

thanks,
-Len
--
Intel Open Source Technology Center
