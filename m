Return-Path: <linux-kernel-owner+w=401wt.eu-S1758494AbZGKI1T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758494AbZGKI1T (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jul 2009 04:27:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752040AbZGKI1J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Jul 2009 04:27:09 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:46433 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752007AbZGKI1H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jul 2009 04:27:07 -0400
Date: Sat, 11 Jul 2009 10:26:49 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Len Brown <lenb@kernel.org>
Cc: x86@kernel.org, sfi-devel@simplefirmware.org, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org
Subject: Re: [PATCH v2 for 2.6.32] SFI - Simple Firmware Interface support
Message-ID: <20090711082649.GB11522@elte.hu>
References: <1247026438-20891-1-git-send-email-lenb@kernel.org> <20090710051848.GB22218@elte.hu> <alpine.LFD.2.00.0907102059320.4088@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0907102059320.4088@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Len Brown <lenb@kernel.org> wrote:

> 
> > 
> > > Feng Tang (10):
> > >       SFI, x86: add CONFIG_SFI
> > >       SFI: document boot param "sfi=off"
> > >       SFI: create include/linux/sfi.h
> > >       SFI: add core support
> > >       ACPI, x86: remove ACPI dependency on some IO-APIC routines
> > >       SFI: add x86 support
> > >       SFI, x86: hook e820() for memory map initialization
> > >       SFI: Enable SFI to parse ACPI tables
> > >       SFI, PCI: Hook MMCONFIG
> > >       SFI: add boot-time initialization hooks
> > 
> > Now that commit quality is all the rage, let me point out a 
> > (trivial) detail that could be improved: patch title capitalization. 
> > 
> > In particular for commits touching arch/x86/ we try to standardize 
> > on capitalizing the word after the 'x86: ' tag. But in the above 
> > titles the capitalization is mixed-case:
> > 
> >  [aligned vertically for easier readability ]
> > 
> > >       SFI, x86:  add CONFIG_SFI
> > >       SFI:       document boot param "sfi=off"
> > >       SFI:       create include/linux/sfi.h
> > >       SFI:       add core support
> > >       ACPI, x86: remove ACPI dependency on some IO-APIC routines
> > >       SFI:       add x86 support
> > >       SFI, x86:  hook e820() for memory map initialization
> > >       SFI:       Enable SFI to parse ACPI tables
> > >       SFI, PCI:  Hook MMCONFIG
> > >       SFI:       add boot-time initialization hooks
> > 
> > So it would be more consistent to have:
> > 
> > >       SFI, x86:  Add CONFIG_SFI
> > >       SFI:       Document boot param "sfi=off"
> > >       SFI:       Create include/linux/sfi.h
> > >       SFI:       Add core support
> > >       ACPI, x86: Remove ACPI dependency on some IO-APIC routines
> > >       SFI:       Add x86 support
> > >       SFI, x86:  Hook e820() for memory map initialization
> > >       SFI:       Enable SFI to parse ACPI tables
> > >       SFI, PCI:  Hook MMCONFIG
> > >       SFI:       Add boot-time initialization hooks
> > 
> > ( Capitalizing like that has the added (minor) benefit of making it 
> >   slightly easier to read these titles - the 'real' natural language 
> >   sentence portion of the title begins with a capital letter. )
> 
> Ingo,
> While I really do appreciate your attention to detail,
> a little time off might be good for you:-)

No objections on my part ;-)

	Ingo
