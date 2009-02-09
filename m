Return-Path: <linux-kernel-owner+w=401wt.eu-S1755809AbZBIVbY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755809AbZBIVbY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 16:31:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754034AbZBIVbM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 16:31:12 -0500
Received: from ftp.linux-mips.org ([213.58.128.207]:60436 "EHLO
	ftp.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753995AbZBIVbL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 16:31:11 -0500
Date: Mon, 9 Feb 2009 21:31:09 +0000 (GMT)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Sam Ruby <rubys@intertwingly.net>, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org, x86@kernel.org
Subject: Re: [APIC] Kernel panic, rsync corruption, intel q8200, 2.6.28-rc8
In-Reply-To: <20090203114849.b661f1ce.akpm@linux-foundation.org>
Message-ID: <alpine.LFD.1.10.0902092129050.12457@ftp.linux-mips.org>
References: <4978767D.4060700@intertwingly.net> <20090130000758.1dff0113.akpm@linux-foundation.org> <498885CC.4060509@intertwingly.net> <20090203114849.b661f1ce.akpm@linux-foundation.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Feb 2009, Andrew Morton wrote:

> > >> [    0.296001] ..MP-BIOS bug: 8254 timer not connected to IO-APIC
> > >> [    0.296001] Kernel panic - not syncing: IO-APIC + timer doesn't work! 
> > >>   Boot with apic=debug and send a report.  Then try booting with the 
> > >> 'noapic' option.
> > >> [    0.296001]
> > >>
> > >> Able to get past this issue using "noapic", at which point things mostly 
> > >> work,
> > > 
> > > Join the ever-growing noapic club :(
> > > 
> > > I assume this is an ACPI problem.  Or at least, a BIOS problem which
> > > ACPI can solve for us.
> > 
> > My understanding is that APCI and APIC are two different things.
> 
> They sure are.  But it is ACPI which communicates with the BIOS to tell
> the kernel about the APIC, hwo it's wired up, etc.
> 
> Although in this case it looks like the problem might be with the
> mp-bios tables, which ACPI does not handle.  In which case it would be
> core x86 code which will have to fix this up, not ACPI.

 The message is misleading.  It predates the ACPI and has never been 
updated.  It applies equally to both MPS and ACPI systems.  Earlier 
bootstrap messages can be used to determine which configuration method has 
been used by the kernel on this system (many systems provide both).

  Maciej
