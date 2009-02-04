Return-Path: <linux-kernel-owner+w=401wt.eu-S1755273AbZBDEfr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755273AbZBDEfr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 23:35:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751717AbZBDEfi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 23:35:38 -0500
Received: from vms173003pub.verizon.net ([206.46.173.3]:26550 "EHLO
	vms173003pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751472AbZBDEfh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 23:35:37 -0500
Date: Tue, 03 Feb 2009 23:35:33 -0500 (EST)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@localhost.localdomain
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Sam Ruby <rubys@intertwingly.net>, LKML <linux-kernel@vger.kernel.org>,
       linux-acpi@vger.kernel.org, x86@kernel.org,
       "Maciej W. Rozycki" <macro@linux-mips.org>
Subject: Re: [APIC] Kernel panic, rsync corruption, intel q8200, 2.6.28-rc8
In-reply-to: <alpine.LFD.2.00.0902032152180.22800@localhost.localdomain>
Message-id: <alpine.LFD.2.00.0902032332190.5607@localhost.localdomain>
References: <4978767D.4060700@intertwingly.net>
 <20090130000758.1dff0113.akpm@linux-foundation.org>
 <498885CC.4060509@intertwingly.net>
 <20090203114849.b661f1ce.akpm@linux-foundation.org>
 <alpine.LFD.2.00.0902032152180.22800@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > > >> [    0.296001] ..MP-BIOS bug: 8254 timer not connected to IO-APIC
> > > >> [    0.296001] Kernel panic - not syncing: IO-APIC + timer doesn't work! 

just for the record, check_timer() is x86 IO-APIC code, not ACPI code.
So if the machine actually has MPS support, you'll probably get the 
same result with "acpi=off".  (of course if it doesn't have MPS,
then acpi=off would boot in uniprocessor legacy PIC mode)

cheers,
-Len

