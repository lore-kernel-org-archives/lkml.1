Return-Path: <linux-kernel-owner+w=401wt.eu-S1757917AbZGKBBl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757917AbZGKBBl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 21:01:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757626AbZGKBBb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 21:01:31 -0400
Received: from vms173005pub.verizon.net ([206.46.173.5]:61634 "EHLO
	vms173005pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757558AbZGKBBa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 21:01:30 -0400
Date: Fri, 10 Jul 2009 21:01:25 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@localhost.localdomain
To: Ingo Molnar <mingo@elte.hu>
Cc: x86@kernel.org, sfi-devel@simplefirmware.org, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org
Subject: Re: [PATCH v2 for 2.6.32] SFI - Simple Firmware Interface support
In-reply-to: <20090710051848.GB22218@elte.hu>
Message-id: <alpine.LFD.2.00.0907102059320.4088@localhost.localdomain>
References: <1247026438-20891-1-git-send-email-lenb@kernel.org>
 <20090710051848.GB22218@elte.hu>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> 
> > Feng Tang (10):
> >       SFI, x86: add CONFIG_SFI
> >       SFI: document boot param "sfi=off"
> >       SFI: create include/linux/sfi.h
> >       SFI: add core support
> >       ACPI, x86: remove ACPI dependency on some IO-APIC routines
> >       SFI: add x86 support
> >       SFI, x86: hook e820() for memory map initialization
> >       SFI: Enable SFI to parse ACPI tables
> >       SFI, PCI: Hook MMCONFIG
> >       SFI: add boot-time initialization hooks
> 
> Now that commit quality is all the rage, let me point out a 
> (trivial) detail that could be improved: patch title capitalization. 
> 
> In particular for commits touching arch/x86/ we try to standardize 
> on capitalizing the word after the 'x86: ' tag. But in the above 
> titles the capitalization is mixed-case:
> 
>  [aligned vertically for easier readability ]
> 
> >       SFI, x86:  add CONFIG_SFI
> >       SFI:       document boot param "sfi=off"
> >       SFI:       create include/linux/sfi.h
> >       SFI:       add core support
> >       ACPI, x86: remove ACPI dependency on some IO-APIC routines
> >       SFI:       add x86 support
> >       SFI, x86:  hook e820() for memory map initialization
> >       SFI:       Enable SFI to parse ACPI tables
> >       SFI, PCI:  Hook MMCONFIG
> >       SFI:       add boot-time initialization hooks
> 
> So it would be more consistent to have:
> 
> >       SFI, x86:  Add CONFIG_SFI
> >       SFI:       Document boot param "sfi=off"
> >       SFI:       Create include/linux/sfi.h
> >       SFI:       Add core support
> >       ACPI, x86: Remove ACPI dependency on some IO-APIC routines
> >       SFI:       Add x86 support
> >       SFI, x86:  Hook e820() for memory map initialization
> >       SFI:       Enable SFI to parse ACPI tables
> >       SFI, PCI:  Hook MMCONFIG
> >       SFI:       Add boot-time initialization hooks
> 
> ( Capitalizing like that has the added (minor) benefit of making it 
>   slightly easier to read these titles - the 'real' natural language 
>   sentence portion of the title begins with a capital letter. )

Ingo,
While I really do appreciate your attention to detail,
a little time off might be good for you:-)

cheers,
-Len

